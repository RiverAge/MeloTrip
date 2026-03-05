#ifndef NOMINMAX
#define NOMINMAX
#endif
#include "desktop_lyrics_overlay.h"

#include <gdiplus.h>

#include <algorithm>
#include <cmath>
#include <mutex>

namespace desktop_lyrics {
namespace {

using Gdiplus::Color;
using Gdiplus::Font;
using Gdiplus::Graphics;
using Gdiplus::GraphicsPath;
using Gdiplus::LinearGradientBrush;
using Gdiplus::PointF;
using Gdiplus::RectF;
using Gdiplus::SolidBrush;
using Gdiplus::StringFormat;

constexpr const wchar_t kLyricsWindowClassName[] = L"DESKTOP_LYRICS_OVERLAY";
constexpr int kBottomMargin = 120;

std::once_flag g_gdiplus_once;
ULONG_PTR g_gdiplus_token = 0;

void EnsureGdiplusInitialized() {
  std::call_once(g_gdiplus_once, []() {
    Gdiplus::GdiplusStartupInput startup_input;
    Gdiplus::GdiplusStartup(&g_gdiplus_token, &startup_input, nullptr);
  });
}

Color ArgbToColor(uint32_t argb) {
  const BYTE a = static_cast<BYTE>((argb >> 24) & 0xFF);
  const BYTE r = static_cast<BYTE>((argb >> 16) & 0xFF);
  const BYTE g = static_cast<BYTE>((argb >> 8) & 0xFF);
  const BYTE b = static_cast<BYTE>(argb & 0xFF);
  return Color(a, r, g, b);
}

void BuildRoundedRectPath(GraphicsPath* path, const RectF& rect, float radius) {
  if (!path) return;
  if (radius <= 0.1f) {
    path->AddRectangle(rect);
    return;
  }
  const float r = (std::min)(radius, (std::min)(rect.Width, rect.Height) * 0.5f);
  const float d = r * 2.0f;
  path->AddArc(rect.X, rect.Y, d, d, 180.0f, 90.0f);
  path->AddArc(rect.GetRight() - d, rect.Y, d, d, 270.0f, 90.0f);
  path->AddArc(rect.GetRight() - d, rect.GetBottom() - d, d, d, 0.0f, 90.0f);
  path->AddArc(rect.X, rect.GetBottom() - d, d, d, 90.0f, 90.0f);
  path->CloseFigure();
}

void BuildTextPathWithFallback(GraphicsPath* path,
                               const std::wstring& text,
                               const RectF& rect,
                               const StringFormat& format,
                               const wchar_t* preferred_family,
                               int font_style,
                               float font_size) {
  if (!path) return;
  path->Reset();
  const wchar_t* candidates[] = {
      preferred_family,
      L"Segoe UI",
      L"Microsoft YaHei UI",
      L"Microsoft YaHei",
      L"Yu Gothic UI",
      L"Meiryo",
      L"Malgun Gothic",
  };
  for (const auto* family_name : candidates) {
    if (!family_name || family_name[0] == L'\0') continue;
    const int before = path->GetPointCount();
    Gdiplus::FontFamily family(family_name);
    if (family.GetLastStatus() != Gdiplus::Ok) continue;
    path->AddString(text.c_str(), -1, &family, font_style, font_size, rect, &format);
    if (path->GetPointCount() > before) return;
  }
}

}  // namespace

DesktopLyricsOverlay::DesktopLyricsOverlay()
    : cached_text_path_(std::make_unique<Gdiplus::GraphicsPath>()) {}
DesktopLyricsOverlay::~DesktopLyricsOverlay() { Dispose(); }

bool DesktopLyricsOverlay::Create() {
  if (hwnd_) return true;

  WNDCLASSW wc{};
  wc.lpfnWndProc = DesktopLyricsOverlay::WndProc;
  wc.hInstance = GetModuleHandle(nullptr);
  wc.lpszClassName = kLyricsWindowClassName;
  wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
  RegisterClassW(&wc);

  hwnd_ = CreateWindowExW(
      WS_EX_TOOLWINDOW | WS_EX_TOPMOST | WS_EX_LAYERED | WS_EX_NOACTIVATE |
          WS_EX_TRANSPARENT,
      kLyricsWindowClassName, L"DesktopLyrics", WS_POPUP, CW_USEDEFAULT,
      CW_USEDEFAULT, overlay_width_, overlay_height_, nullptr, nullptr,
      GetModuleHandle(nullptr), this);
  if (!hwnd_) return false;

  ApplyWindowStyles();
  PositionNearBottomCenter();
  return true;
}

void DesktopLyricsOverlay::Show() {
  if (!enabled_) return;
  if (current_line_.empty()) return;
  if (!hwnd_ && !Create()) return;
  PositionNearBottomCenter(false);
  ShowWindow(hwnd_, SW_SHOWNOACTIVATE);
  SetWindowPos(hwnd_, HWND_TOPMOST, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE | SWP_SHOWWINDOW);
  RequestRepaint();
}

void DesktopLyricsOverlay::Hide() {
  if (!hwnd_) return;
  dragging_ = false;
  ShowWindow(hwnd_, SW_HIDE);
}

void DesktopLyricsOverlay::Dispose() {
  ReleaseBackBuffer();
  if (!hwnd_) return;
  DestroyWindow(hwnd_);
  hwnd_ = nullptr;
}

void DesktopLyricsOverlay::UpdateLyricFrame(const std::wstring& current_line,
                                            double line_progress) {
  has_frame_ = true;
  current_line_ = current_line;
  frame_line_progress_ = std::clamp(line_progress, 0.0, 1.0);
  if (current_line_.empty()) {
    Hide();
    return;
  }
  if (enabled_) Show();
  RequestRepaint();
}

void DesktopLyricsOverlay::UpdateConfig(const OverlayConfig& config) {
  enabled_ = config.enabled;
  click_through_ = config.click_through;
  font_size_ = std::clamp(config.font_size, 20.0, 72.0);
  opacity_ = std::clamp(config.opacity, 0.25, 1.0);
  text_argb_ = config.text_argb;
  shadow_argb_ = config.shadow_argb;
  stroke_argb_ = config.stroke_argb;
  stroke_width_ = std::clamp(config.stroke_width, 0.0, 6.0);
  background_argb_ = config.background_argb;
  background_radius_ = std::clamp(config.background_radius, 0.0, 48.0);
  background_padding_ = std::clamp(config.background_padding, 0.0, 36.0);
  text_gradient_enabled_ = config.text_gradient_enabled;
  text_gradient_start_argb_ = config.text_gradient_start_argb;
  text_gradient_end_argb_ = config.text_gradient_end_argb;
  text_gradient_angle_ = config.text_gradient_angle;
  overlay_width_ =
      static_cast<int>(std::round(std::clamp(config.overlay_width, 480.0, 2600.0)));
  auto_overlay_height_ = config.overlay_height <= 0.0;
  if (!auto_overlay_height_) {
    overlay_height_ =
        static_cast<int>(std::round(std::clamp(config.overlay_height, 90.0, 800.0)));
  }
  font_family_ = config.font_family.empty() ? L"Segoe UI" : config.font_family;
  text_align_ = std::clamp(config.text_align, 0, 2);
  font_weight_value_ = std::clamp(config.font_weight_value, 100, 900);

  if (!enabled_) {
    if (hwnd_) Hide();
    return;
  }

  // Only cache config before first lyric frame arrives. This avoids creating
  // and showing an empty native overlay during enable.
  if (current_line_.empty()) {
    if (hwnd_) Hide();
    return;
  }

  if (!hwnd_ && !Create()) return;

  if (auto_overlay_height_) {
    HDC screen_dc = GetDC(hwnd_);
    if (screen_dc) {
      overlay_height_ = ComputeAutoOverlayHeight(screen_dc, overlay_width_);
      ReleaseDC(hwnd_, screen_dc);
    }
  }

  ApplyWindowStyles();
  SetWindowPos(hwnd_, HWND_TOPMOST, 0, 0, overlay_width_, overlay_height_,
               SWP_NOMOVE | SWP_NOACTIVATE);

  Show();
}

int DesktopLyricsOverlay::ComputeAutoOverlayHeight(HDC reference_dc, int width) const {
  if (!reference_dc || width <= 0) return overlay_height_;

  const int font_style =
      font_weight_value_ >= 600 ? Gdiplus::FontStyleBold
                                : Gdiplus::FontStyleRegular;
  Gdiplus::Graphics measure_graphics(reference_dc);
  measure_graphics.SetTextRenderingHint(Gdiplus::TextRenderingHintAntiAlias);
  Gdiplus::Font font(font_family_.c_str(), static_cast<float>(font_size_), font_style,
                     Gdiplus::UnitPixel);
  Gdiplus::StringFormat format;
  format.SetFormatFlags(Gdiplus::StringFormatFlagsNoWrap);
  const float layout_width = static_cast<float>((std::max)(width - 48, 120));
  const Gdiplus::RectF layout(0.0f, 0.0f, layout_width, 2000.0f);
  Gdiplus::RectF measured{};
  const std::wstring sample =
      current_line_.empty() ? std::wstring(L"Ag") : current_line_;
  measure_graphics.MeasureString(sample.c_str(), -1, &font, layout, &format, &measured);

  const float text_height = (std::max)(measured.Height, static_cast<float>(font_size_) * 1.2f);
  const float content_height =
      text_height + 20.0f + static_cast<float>(background_padding_) * 2.0f +
      static_cast<float>((std::max)(0.0, stroke_width_)) * 2.0f + 4.0f;
  return static_cast<int>(
      std::round(std::clamp(content_height, 90.0f, 800.0f)));
}

LRESULT CALLBACK DesktopLyricsOverlay::WndProc(HWND hwnd,
                                               UINT message,
                                               WPARAM wparam,
                                               LPARAM lparam) {
  DesktopLyricsOverlay* self = nullptr;
  if (message == WM_NCCREATE) {
    auto* create_struct = reinterpret_cast<CREATESTRUCTW*>(lparam);
    self = static_cast<DesktopLyricsOverlay*>(create_struct->lpCreateParams);
    SetWindowLongPtrW(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(self));
  } else {
    self = reinterpret_cast<DesktopLyricsOverlay*>(
        GetWindowLongPtrW(hwnd, GWLP_USERDATA));
  }
  if (!self) return DefWindowProcW(hwnd, message, wparam, lparam);
  return self->HandleMessage(hwnd, message, wparam, lparam);
}

LRESULT DesktopLyricsOverlay::HandleMessage(HWND hwnd,
                                            UINT message,
                                            WPARAM wparam,
                                            LPARAM lparam) {
  switch (message) {
    case WM_ERASEBKGND:
      return 1;
    case WM_NCHITTEST:
      return click_through_ ? HTTRANSPARENT : HTCLIENT;
    case WM_LBUTTONDBLCLK:
      has_custom_position_ = false;
      PositionNearBottomCenter(true);
      return 0;
    case WM_LBUTTONDOWN:
      if (!click_through_) {
        dragging_ = true;
        GetCursorPos(&drag_start_cursor_);
        RECT window_rect{};
        GetWindowRect(hwnd, &window_rect);
        drag_start_window_.x = window_rect.left;
        drag_start_window_.y = window_rect.top;
        SetCapture(hwnd);
      }
      return 0;
    case WM_MOUSEMOVE:
      if (dragging_ && !click_through_ && (wparam & MK_LBUTTON)) {
        POINT cursor{};
        GetCursorPos(&cursor);
        const int delta_x = cursor.x - drag_start_cursor_.x;
        const int delta_y = cursor.y - drag_start_cursor_.y;
        const int left = drag_start_window_.x + delta_x;
        const int top = drag_start_window_.y + delta_y;
        has_custom_position_ = true;
        SetWindowPos(hwnd_, HWND_TOPMOST, left, top, 0, 0,
                     SWP_NOSIZE | SWP_NOACTIVATE);
      }
      return 0;
    case WM_LBUTTONUP:
      if (dragging_) {
        dragging_ = false;
        ReleaseCapture();
      }
      return 0;
    case WM_DISPLAYCHANGE:
    case WM_DPICHANGED:
      PositionNearBottomCenter(false);
      return 0;
    case WM_PAINT: {
      PAINTSTRUCT ps;
      BeginPaint(hwnd, &ps);
      EndPaint(hwnd, &ps);
      RenderLayeredWindow();
      return 0;
    }
  }
  return DefWindowProcW(hwnd, message, wparam, lparam);
}

void DesktopLyricsOverlay::PositionNearBottomCenter(bool force) {
  if (!hwnd_) return;
  if (has_custom_position_ && !force) return;

  MONITORINFO monitor_info{};
  monitor_info.cbSize = sizeof(MONITORINFO);
  HMONITOR monitor = MonitorFromWindow(hwnd_, MONITOR_DEFAULTTONEAREST);
  if (!GetMonitorInfoW(monitor, &monitor_info)) return;

  const RECT work = monitor_info.rcWork;
  const int screen_width = work.right - work.left;
  const int screen_height = work.bottom - work.top;
  const int left = work.left + (screen_width - overlay_width_) / 2;
  const int top = work.top + screen_height - overlay_height_ - kBottomMargin;

  SetWindowPos(hwnd_, HWND_TOPMOST, left, top, overlay_width_, overlay_height_,
               SWP_NOACTIVATE);
}

void DesktopLyricsOverlay::RequestRepaint() {
  if (!hwnd_ || !IsWindowVisible(hwnd_)) return;
  RenderLayeredWindow();
}

void DesktopLyricsOverlay::ApplyWindowStyles() {
  if (!hwnd_) return;
  LONG_PTR style = GetWindowLongPtrW(hwnd_, GWL_EXSTYLE);
  if (click_through_) {
    style |= WS_EX_TRANSPARENT;
  } else {
    style &= ~static_cast<LONG_PTR>(WS_EX_TRANSPARENT);
  }
  SetWindowLongPtrW(hwnd_, GWL_EXSTYLE, style);
}

bool DesktopLyricsOverlay::EnsureBackBuffer(HDC screen_dc, int width, int height) {
  if (!screen_dc || width <= 0 || height <= 0) return false;
  if (backbuffer_dc_ && backbuffer_bitmap_ &&
      backbuffer_width_ == width && backbuffer_height_ == height) {
    return true;
  }

  ReleaseBackBuffer();
  backbuffer_dc_ = CreateCompatibleDC(screen_dc);
  if (!backbuffer_dc_) return false;

  BITMAPINFO bmi{};
  bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth = width;
  bmi.bmiHeader.biHeight = -height;
  bmi.bmiHeader.biPlanes = 1;
  bmi.bmiHeader.biBitCount = 32;
  bmi.bmiHeader.biCompression = BI_RGB;

  backbuffer_bitmap_ = CreateDIBSection(backbuffer_dc_, &bmi, DIB_RGB_COLORS,
                                        &backbuffer_bits_, nullptr, 0);
  if (!backbuffer_bitmap_) {
    ReleaseBackBuffer();
    return false;
  }

  backbuffer_old_bitmap_ = SelectObject(backbuffer_dc_, backbuffer_bitmap_);
  backbuffer_width_ = width;
  backbuffer_height_ = height;
  return true;
}

void DesktopLyricsOverlay::ReleaseBackBuffer() {
  if (backbuffer_dc_ && backbuffer_old_bitmap_) {
    SelectObject(backbuffer_dc_, backbuffer_old_bitmap_);
  }
  if (backbuffer_bitmap_) DeleteObject(backbuffer_bitmap_);
  if (backbuffer_dc_) DeleteDC(backbuffer_dc_);
  backbuffer_dc_ = nullptr;
  backbuffer_bitmap_ = nullptr;
  backbuffer_old_bitmap_ = nullptr;
  backbuffer_bits_ = nullptr;
  backbuffer_width_ = 0;
  backbuffer_height_ = 0;
}

void DesktopLyricsOverlay::RenderLayeredWindow() {
  if (!hwnd_ || !enabled_ || !IsWindowVisible(hwnd_)) return;
  EnsureGdiplusInitialized();

  RECT window_rect{};
  if (!GetWindowRect(hwnd_, &window_rect)) return;
  int width = window_rect.right - window_rect.left;
  int height = window_rect.bottom - window_rect.top;
  if (width <= 0 || height <= 0) return;

  HDC screen_dc = GetDC(nullptr);
  if (!screen_dc) return;
  if (auto_overlay_height_) {
    const int desired_height = ComputeAutoOverlayHeight(screen_dc, width);
    if (desired_height != height) {
      overlay_height_ = desired_height;
      if (!has_custom_position_) {
        PositionNearBottomCenter(true);
      } else {
        SetWindowPos(hwnd_, HWND_TOPMOST, 0, 0, overlay_width_, overlay_height_,
                     SWP_NOMOVE | SWP_NOACTIVATE);
      }
      GetWindowRect(hwnd_, &window_rect);
      width = window_rect.right - window_rect.left;
      height = window_rect.bottom - window_rect.top;
    }
  }
  if (!EnsureBackBuffer(screen_dc, width, height)) {
    ReleaseDC(nullptr, screen_dc);
    return;
  }

  {
    Graphics graphics(backbuffer_dc_);
    graphics.SetSmoothingMode(Gdiplus::SmoothingModeAntiAlias);
    graphics.SetTextRenderingHint(Gdiplus::TextRenderingHintAntiAlias);
    graphics.Clear(Color(0, 0, 0, 0));

    const float pad = static_cast<float>(background_padding_);
    const RectF bg_rect(pad, pad, static_cast<float>(width) - pad * 2.0f,
                        static_cast<float>(height) - pad * 2.0f);
    GraphicsPath bg_path;
    const bool has_background = ((background_argb_ >> 24) & 0xFF) > 0;
    if (has_background) {
      BuildRoundedRectPath(&bg_path, bg_rect, static_cast<float>(background_radius_));
      SolidBrush bg_brush(ArgbToColor(background_argb_));
      graphics.FillPath(&bg_brush, &bg_path);
      // Keep text layers inside rounded container so stroke/shadow will not
      // visually cut rounded corners on the right edge.
      graphics.SetClip(&bg_path, Gdiplus::CombineModeIntersect);
    }

    const std::wstring text = current_line_;
    if (!text.empty()) {
      const float stroke_safe_pad =
          static_cast<float>((std::max)(0.0, stroke_width_)) + 2.0f;
      const float left = 24.0f + stroke_safe_pad;
      const float top = 10.0f + stroke_safe_pad * 0.5f;
      const float w = static_cast<float>((std::max)(
          width - static_cast<int>(left * 2.0f), 80));
      const float h = static_cast<float>((std::max)(
          height - static_cast<int>(top * 2.0f), 28));
      const RectF text_rect(left, top, w, h);
      StringFormat format;
      const Gdiplus::StringAlignment horizontal_alignment =
          text_align_ == 1
              ? Gdiplus::StringAlignmentCenter
              : (text_align_ == 2 ? Gdiplus::StringAlignmentFar
                                  : Gdiplus::StringAlignmentNear);
      format.SetAlignment(horizontal_alignment);
      format.SetLineAlignment(Gdiplus::StringAlignmentCenter);
      format.SetTrimming(Gdiplus::StringTrimmingEllipsisCharacter);
      format.SetFormatFlags(Gdiplus::StringFormatFlagsNoWrap);
      const int font_style =
          font_weight_value_ >= 600 ? Gdiplus::FontStyleBold
                                    : Gdiplus::FontStyleRegular;
      Font font(font_family_.c_str(), static_cast<float>(font_size_), font_style,
                Gdiplus::UnitPixel);
      const bool cache_miss = cached_text_ != text ||
                              cached_font_family_ != font_family_ ||
                              cached_width_ != width ||
                              cached_height_ != height ||
                              cached_text_align_ != text_align_ ||
                              cached_font_weight_ != font_weight_value_ ||
                              std::abs(cached_font_size_ -
                                       static_cast<float>(font_size_)) > 0.01f ||
                              std::abs(cached_stroke_width_ -
                                       static_cast<float>(stroke_width_)) > 0.01f;
      if (cache_miss) {
        cached_text_ = text;
        cached_font_family_ = font_family_;
        cached_width_ = width;
        cached_height_ = height;
        cached_text_align_ = text_align_;
        cached_font_weight_ = font_weight_value_;
        cached_font_size_ = static_cast<float>(font_size_);
        cached_stroke_width_ = static_cast<float>(stroke_width_);
        BuildTextPathWithFallback(cached_text_path_.get(), text, text_rect, format,
                                  font_family_.c_str(), font_style,
                                  static_cast<float>(font_size_));
      }
      const bool has_text_path =
          cached_text_path_ && cached_text_path_->GetPointCount() > 0;

      if (((shadow_argb_ >> 24) & 0xFF) > 0) {
        SolidBrush shadow_brush(ArgbToColor(shadow_argb_));
        RectF shadow_rect(text_rect.X + 2.5f, text_rect.Y + 2.5f, text_rect.Width,
                          text_rect.Height);
        graphics.DrawString(text.c_str(), -1, &font, shadow_rect, &format,
                            &shadow_brush);
      }

      const bool should_stroke =
          stroke_width_ > 0.01 && ((stroke_argb_ >> 24) & 0xFF) > 0;
      if (!has_text_path && should_stroke) {
        // DrawString fallback path caps radius for performance; wide values are
        // still honored when path rendering is available (Pen + GraphicsPath).
        const int radius = (std::min)(
            2, (std::max)(1, static_cast<int>(std::round(stroke_width_))));
        SolidBrush stroke_brush(ArgbToColor(stroke_argb_));
        for (int dx = -radius; dx <= radius; ++dx) {
          for (int dy = -radius; dy <= radius; ++dy) {
            if (dx == 0 && dy == 0) continue;
            RectF stroke_rect(text_rect.X + static_cast<float>(dx),
                              text_rect.Y + static_cast<float>(dy),
                              text_rect.Width, text_rect.Height);
            graphics.DrawString(text.c_str(), -1, &font, stroke_rect, &format,
                                &stroke_brush);
          }
        }
      }

      const bool has_frame_progress = has_frame_ && frame_line_progress_ < 0.999;
      const auto paint_gradient = [&]() {
        const float cx = text_rect.X + text_rect.Width * 0.5f;
        const float cy = text_rect.Y + text_rect.Height * 0.5f;
        const float rad =
            static_cast<float>(text_gradient_angle_ * 3.141592653589793 / 180.0);
        const float half = (std::max)(text_rect.Width, text_rect.Height) * 0.5f;
        const float dx = std::cos(rad) * half;
        const float dy = std::sin(rad) * half;
        LinearGradientBrush gradient(PointF(cx - dx, cy - dy), PointF(cx + dx, cy + dy),
                                     ArgbToColor(text_gradient_start_argb_),
                                     ArgbToColor(text_gradient_end_argb_));
        if (has_text_path) {
          graphics.FillPath(&gradient, cached_text_path_.get());
        } else {
          graphics.DrawString(text.c_str(), -1, &font, text_rect, &format, &gradient);
        }
      };
      if (has_frame_progress) {
        // Draw a softer full-line base, then overlay the active progress fill.
        // In gradient mode, use gradient start color as base to avoid invisible
        // "unplayed" text when text color alpha is low/transparent.
        uint32_t base_argb =
            text_gradient_enabled_ ? text_gradient_start_argb_ : text_argb_;
        const uint32_t base_alpha = (base_argb >> 24) & 0xFF;
        const uint32_t softened_alpha =
            (std::max)(base_alpha / 2, static_cast<uint32_t>(0x88));
        base_argb = (base_argb & 0x00FFFFFF) | (softened_alpha << 24);
        SolidBrush base_brush(ArgbToColor(base_argb));
        if (has_text_path) {
          graphics.FillPath(&base_brush, cached_text_path_.get());
        } else {
          graphics.DrawString(text.c_str(), -1, &font, text_rect, &format, &base_brush);
        }

        const RectF progress_rect(
            text_rect.X,
            text_rect.Y,
            text_rect.Width * static_cast<float>(frame_line_progress_),
            text_rect.Height);
        graphics.SetClip(progress_rect, Gdiplus::CombineModeReplace);

        if (text_gradient_enabled_) {
          paint_gradient();
        } else {
          SolidBrush text_brush(ArgbToColor(text_argb_));
          if (has_text_path) {
            graphics.FillPath(&text_brush, cached_text_path_.get());
          } else {
            graphics.DrawString(text.c_str(), -1, &font, text_rect, &format, &text_brush);
          }
        }
        graphics.ResetClip();
      } else if (text_gradient_enabled_) {
        paint_gradient();
      } else {
        SolidBrush text_brush(ArgbToColor(text_argb_));
        if (has_text_path) {
          graphics.FillPath(&text_brush, cached_text_path_.get());
        } else {
          graphics.DrawString(text.c_str(), -1, &font, text_rect, &format,
                              &text_brush);
        }
      }

      if (has_text_path && should_stroke) {
        const float visible_width =
            (std::max)(static_cast<float>(stroke_width_), 1.1f);
        const uint32_t glow_argb =
            (stroke_argb_ & 0x00FFFFFF) | (static_cast<uint32_t>(0x66) << 24);
        Gdiplus::Pen glow_pen(ArgbToColor(glow_argb), visible_width + 1.0f);
        glow_pen.SetLineJoin(Gdiplus::LineJoinRound);
        graphics.DrawPath(&glow_pen, cached_text_path_.get());

        Gdiplus::Pen stroke_pen(ArgbToColor(stroke_argb_), visible_width);
        stroke_pen.SetLineJoin(Gdiplus::LineJoinRound);
        graphics.DrawPath(&stroke_pen, cached_text_path_.get());
      }
    }
    if (has_background) {
      graphics.ResetClip();
    }
  }

  POINT src_pt{0, 0};
  SIZE size{width, height};
  POINT dst_pt{window_rect.left, window_rect.top};
  BLENDFUNCTION blend{};
  blend.BlendOp = AC_SRC_OVER;
  blend.SourceConstantAlpha =
      static_cast<BYTE>(std::round(std::clamp(opacity_, 0.0, 1.0) * 255.0));
  blend.AlphaFormat = AC_SRC_ALPHA;
  UpdateLayeredWindow(hwnd_, screen_dc, &dst_pt, &size, backbuffer_dc_, &src_pt, 0, &blend,
                      ULW_ALPHA);
  ReleaseDC(nullptr, screen_dc);
}

}  // namespace desktop_lyrics
