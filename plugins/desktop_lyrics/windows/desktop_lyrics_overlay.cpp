#ifndef NOMINMAX
#define NOMINMAX
#endif
#include "desktop_lyrics_overlay.h"

#include <algorithm>
#include <cmath>

namespace desktop_lyrics {
namespace {

constexpr const wchar_t kLyricsWindowClassName[] = L"DESKTOP_LYRICS_OVERLAY";
constexpr int kBottomMargin = 120;

template <typename T>
T ClampValue(T value, T min, T max) {
  return (std::max)(min, (std::min)(value, max));
}

}  // namespace

DesktopLyricsOverlay::DesktopLyricsOverlay() = default;
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
  if (!enabled_ || current_line_.empty()) return;
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
  ReleaseRenderTarget();
  ReleaseBackBuffer();
  if (!hwnd_) return;
  DestroyWindow(hwnd_);
  hwnd_ = nullptr;
}

void DesktopLyricsOverlay::UpdateLyricFrame(const std::wstring& current_line,
                                            double line_progress) {
  has_frame_ = true;
  frame_line_progress_ = ClampValue(line_progress, 0.0, 1.0);
  current_line_ = current_line;
  cached_measure_width_ = 0;
  cached_measure_height_ = 0;
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
  font_size_ = ClampValue(config.font_size, 20.0, 72.0);
  opacity_ = ClampValue(config.opacity, 0.25, 1.0);
  text_argb_ = config.text_argb;
  shadow_argb_ = config.shadow_argb;
  stroke_argb_ = config.stroke_argb;
  stroke_width_ = ClampValue(config.stroke_width, 0.0, 6.0);
  background_argb_ = config.background_argb;
  background_radius_ = ClampValue(config.background_radius, 0.0, 48.0);
  background_padding_ = ClampValue(config.background_padding, 0.0, 36.0);
  text_gradient_enabled_ = config.text_gradient_enabled;
  text_gradient_start_argb_ = config.text_gradient_start_argb;
  text_gradient_end_argb_ = config.text_gradient_end_argb;
  text_gradient_angle_ = config.text_gradient_angle;
  overlay_width_ = static_cast<int>(
      std::round(ClampValue(config.overlay_width, 480.0, 2600.0)));
  auto_overlay_height_ = config.overlay_height <= 0.0;
  if (!auto_overlay_height_) {
    overlay_height_ = static_cast<int>(
        std::round(ClampValue(config.overlay_height, 90.0, 800.0)));
  }
  font_family_ = config.font_family.empty() ? L"Segoe UI" : config.font_family;
  text_align_ = ClampValue(config.text_align, 0, 2);
  font_weight_value_ = ClampValue(config.font_weight_value, 100, 900);
  ResetTextFormats();
  cached_measure_width_ = 0;
  cached_measure_height_ = 0;

  if (!enabled_) {
    if (hwnd_) Hide();
    return;
  }

  if (current_line_.empty()) {
    if (hwnd_) Hide();
    return;
  }

  if (!hwnd_ && !Create()) return;

  if (auto_overlay_height_) {
    overlay_height_ = ComputeAutoOverlayHeight(overlay_width_);
  }

  ApplyWindowStyles();
  SetWindowPos(hwnd_, HWND_TOPMOST, 0, 0, overlay_width_, overlay_height_,
               SWP_NOMOVE | SWP_NOACTIVATE);
  Show();
}

int DesktopLyricsOverlay::ComputeAutoOverlayHeight(int width) const {
  if (width <= 0) return overlay_height_;
  const std::wstring sample =
      current_line_.empty() ? std::wstring(L"Ag") : current_line_;
  if (sample == cached_text_for_measure_ && width == cached_measure_width_ &&
      cached_measure_height_ > 0) {
    return cached_measure_height_;
  }

  if (!dwrite_factory_) {
    const_cast<DesktopLyricsOverlay*>(this)->EnsureFactories();
  }
  if (!dwrite_factory_) return overlay_height_;
  if (!measure_text_format_) {
    const_cast<DesktopLyricsOverlay*>(this)->EnsureTextFormats();
  }
  if (!measure_text_format_) return overlay_height_;

  const float layout_width = static_cast<float>((std::max)(width - 48, 120));
  Microsoft::WRL::ComPtr<IDWriteTextLayout> layout;
  const HRESULT hr = dwrite_factory_->CreateTextLayout(
      sample.c_str(), static_cast<UINT32>(sample.size()),
      measure_text_format_.Get(), layout_width, 2048.0f, &layout);
  if (FAILED(hr) || !layout) return overlay_height_;

  DWRITE_TEXT_METRICS metrics{};
  if (FAILED(layout->GetMetrics(&metrics))) return overlay_height_;

  const float text_height =
      (std::max)(metrics.height, static_cast<float>(font_size_) * 1.2f);
  const float content_height =
      text_height + 20.0f + static_cast<float>(background_padding_) * 2.0f +
      static_cast<float>(stroke_width_) * 2.0f + 4.0f;
  const int resolved_height =
      static_cast<int>(std::round(ClampValue(content_height, 90.0f, 800.0f)));
  cached_text_for_measure_ = sample;
  cached_measure_width_ = width;
  cached_measure_height_ = resolved_height;
  return resolved_height;
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
  if (backbuffer_dc_ && backbuffer_bitmap_ && backbuffer_width_ == width &&
      backbuffer_height_ == height) {
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
  ReleaseRenderTarget();
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

bool DesktopLyricsOverlay::EnsureFactories() {
  if (!d2d_factory_) {
    if (FAILED(D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED,
                                 d2d_factory_.ReleaseAndGetAddressOf()))) {
      return false;
    }
  }
  if (!dwrite_factory_) {
    if (FAILED(DWriteCreateFactory(
            DWRITE_FACTORY_TYPE_SHARED, __uuidof(IDWriteFactory),
            reinterpret_cast<IUnknown**>(
                dwrite_factory_.ReleaseAndGetAddressOf())))) {
      return false;
    }
  }
  return true;
}

bool DesktopLyricsOverlay::EnsureRenderTarget() {
  if (render_target_) return true;
  if (!EnsureFactories() || !backbuffer_dc_) return false;

  const D2D1_RENDER_TARGET_PROPERTIES props = D2D1::RenderTargetProperties(
      D2D1_RENDER_TARGET_TYPE_DEFAULT,
      D2D1::PixelFormat(DXGI_FORMAT_B8G8R8A8_UNORM,
                        D2D1_ALPHA_MODE_PREMULTIPLIED));
  if (FAILED(d2d_factory_->CreateDCRenderTarget(
          &props, render_target_.ReleaseAndGetAddressOf()))) {
    return false;
  }
  return true;
}

void DesktopLyricsOverlay::ReleaseRenderTarget() { render_target_.Reset(); }

bool DesktopLyricsOverlay::EnsureTextFormats() {
  if (!EnsureFactories()) return false;
  if (text_format_ && measure_text_format_) return true;

  Microsoft::WRL::ComPtr<IDWriteTextFormat> text_format;
  if (FAILED(dwrite_factory_->CreateTextFormat(
          font_family_.c_str(), nullptr, ToFontWeight(),
          DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
          static_cast<FLOAT>(font_size_), L"", &text_format))) {
    return false;
  }
  text_format->SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);
  text_format->SetTextAlignment(ToTextAlignment());
  text_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_CENTER);

  Microsoft::WRL::ComPtr<IDWriteTextFormat> measure_format;
  if (FAILED(dwrite_factory_->CreateTextFormat(
          font_family_.c_str(), nullptr, ToFontWeight(),
          DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
          static_cast<FLOAT>(font_size_), L"", &measure_format))) {
    return false;
  }
  measure_format->SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);
  measure_format->SetTextAlignment(ToTextAlignment());
  measure_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_NEAR);

  text_format_ = text_format;
  measure_text_format_ = measure_format;
  return true;
}

void DesktopLyricsOverlay::ResetTextFormats() {
  text_format_.Reset();
  measure_text_format_.Reset();
}

D2D1_COLOR_F DesktopLyricsOverlay::ToColorF(uint32_t argb) const {
  const float a = static_cast<float>((argb >> 24) & 0xFF) / 255.0f;
  const float r = static_cast<float>((argb >> 16) & 0xFF) / 255.0f;
  const float g = static_cast<float>((argb >> 8) & 0xFF) / 255.0f;
  const float b = static_cast<float>(argb & 0xFF) / 255.0f;
  return D2D1::ColorF(r, g, b, a);
}

DWRITE_TEXT_ALIGNMENT DesktopLyricsOverlay::ToTextAlignment() const {
  switch (text_align_) {
    case 1:
      return DWRITE_TEXT_ALIGNMENT_CENTER;
    case 2:
      return DWRITE_TEXT_ALIGNMENT_TRAILING;
    default:
      return DWRITE_TEXT_ALIGNMENT_LEADING;
  }
}

DWRITE_FONT_WEIGHT DesktopLyricsOverlay::ToFontWeight() const {
  if (font_weight_value_ >= 700) return DWRITE_FONT_WEIGHT_BOLD;
  if (font_weight_value_ >= 600) return DWRITE_FONT_WEIGHT_SEMI_BOLD;
  if (font_weight_value_ >= 500) return DWRITE_FONT_WEIGHT_MEDIUM;
  return DWRITE_FONT_WEIGHT_NORMAL;
}

void DesktopLyricsOverlay::RenderLayeredWindow() {
  if (!hwnd_ || !enabled_ || !IsWindowVisible(hwnd_)) return;

  RECT window_rect{};
  if (!GetWindowRect(hwnd_, &window_rect)) return;
  int width = window_rect.right - window_rect.left;
  int height = window_rect.bottom - window_rect.top;
  if (width <= 0 || height <= 0) return;

  HDC screen_dc = GetDC(nullptr);
  if (!screen_dc) return;
  if (auto_overlay_height_) {
    const int desired_height = ComputeAutoOverlayHeight(width);
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
  if (!EnsureBackBuffer(screen_dc, width, height) || !EnsureRenderTarget() ||
      !EnsureTextFormats()) {
    ReleaseDC(nullptr, screen_dc);
    return;
  }

  RECT update_rect{0, 0, width, height};
  if (FAILED(render_target_->BindDC(backbuffer_dc_, &update_rect))) {
    ReleaseDC(nullptr, screen_dc);
    return;
  }

  render_target_->BeginDraw();
  render_target_->Clear(D2D1::ColorF(0, 0.0f));

  const float pad = static_cast<float>(background_padding_);
  const D2D1_ROUNDED_RECT bg_rect = D2D1::RoundedRect(
      D2D1::RectF(pad, pad, static_cast<float>(width) - pad,
                  static_cast<float>(height) - pad),
      static_cast<float>(background_radius_),
      static_cast<float>(background_radius_));

  Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> background_brush;
  const bool has_background = ((background_argb_ >> 24) & 0xFF) > 0;
  if (has_background &&
      SUCCEEDED(render_target_->CreateSolidColorBrush(
          ToColorF(background_argb_), &background_brush))) {
    render_target_->FillRoundedRectangle(&bg_rect, background_brush.Get());
  }

  const D2D1_RECT_F text_rect = D2D1::RectF(
      24.0f + static_cast<float>(stroke_width_),
      8.0f + static_cast<float>(stroke_width_),
      static_cast<float>(width) - 24.0f - static_cast<float>(stroke_width_),
      static_cast<float>(height) - 8.0f - static_cast<float>(stroke_width_));

  if (!current_line_.empty()) {
    if (((shadow_argb_ >> 24) & 0xFF) > 0) {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> shadow_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(shadow_argb_), &shadow_brush))) {
        const D2D1_RECT_F shadow_rect = D2D1::RectF(
            text_rect.left + 2.5f, text_rect.top + 2.5f, text_rect.right + 2.5f,
            text_rect.bottom + 2.5f);
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), shadow_rect, shadow_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    }

    if (stroke_width_ > 0.01 && ((stroke_argb_ >> 24) & 0xFF) > 0) {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> stroke_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(stroke_argb_), &stroke_brush))) {
        const float offsets[] = {-1.4f, 0.0f, 1.4f};
        for (float dx : offsets) {
          for (float dy : offsets) {
            if (std::abs(dx) < 0.01f && std::abs(dy) < 0.01f) continue;
            const D2D1_RECT_F stroke_rect = D2D1::RectF(
                text_rect.left + dx, text_rect.top + dy, text_rect.right + dx,
                text_rect.bottom + dy);
            render_target_->DrawTextW(
                current_line_.c_str(),
                static_cast<UINT32>(current_line_.size()), text_format_.Get(),
                stroke_rect, stroke_brush.Get(), D2D1_DRAW_TEXT_OPTIONS_CLIP);
          }
        }
      }
    }

    const bool has_progress = has_frame_ && frame_line_progress_ < 0.999;
    if (has_progress) {
      uint32_t base_argb =
          text_gradient_enabled_ ? text_gradient_start_argb_ : text_argb_;
      const uint32_t base_alpha = (base_argb >> 24) & 0xFF;
      const uint32_t softened_alpha =
          (std::max)(base_alpha / 2, static_cast<uint32_t>(0x88));
      base_argb = (base_argb & 0x00FFFFFF) | (softened_alpha << 24);
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> base_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(base_argb), &base_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, base_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
      const D2D1_RECT_F progress_clip = D2D1::RectF(
          text_rect.left, text_rect.top,
          text_rect.left +
              (text_rect.right - text_rect.left) *
                  static_cast<float>(frame_line_progress_),
          text_rect.bottom);
      render_target_->PushAxisAlignedClip(progress_clip,
                                          D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
    }

    if (text_gradient_enabled_) {
      const float angle =
          static_cast<float>(text_gradient_angle_ * 3.141592653589793 / 180.0);
      const float center_x = (text_rect.left + text_rect.right) * 0.5f;
      const float center_y = (text_rect.top + text_rect.bottom) * 0.5f;
      const float half_extent =
          (std::max)(text_rect.right - text_rect.left,
                     text_rect.bottom - text_rect.top) *
          0.5f;
      const float dx = std::cos(angle) * half_extent;
      const float dy = std::sin(angle) * half_extent;
      D2D1_GRADIENT_STOP stops[2] = {
          {0.0f, ToColorF(text_gradient_start_argb_)},
          {1.0f, ToColorF(text_gradient_end_argb_)},
      };
      Microsoft::WRL::ComPtr<ID2D1GradientStopCollection> stop_collection;
      Microsoft::WRL::ComPtr<ID2D1LinearGradientBrush> gradient_brush;
      if (SUCCEEDED(render_target_->CreateGradientStopCollection(
              stops, 2, D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_CLAMP,
              &stop_collection)) &&
          SUCCEEDED(render_target_->CreateLinearGradientBrush(
              D2D1::LinearGradientBrushProperties(
                  D2D1::Point2F(center_x - dx, center_y - dy),
                  D2D1::Point2F(center_x + dx, center_y + dy)),
              stop_collection.Get(), &gradient_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, gradient_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    } else {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> text_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(ToColorF(text_argb_),
                                                          &text_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, text_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    }

    if (has_progress) {
      render_target_->PopAxisAlignedClip();
    }
  }

  const HRESULT end_draw = render_target_->EndDraw();
  if (end_draw == D2DERR_RECREATE_TARGET) {
    ReleaseRenderTarget();
  }

  POINT src_pt{0, 0};
  SIZE size{width, height};
  POINT dst_pt{window_rect.left, window_rect.top};
  BLENDFUNCTION blend{};
  blend.BlendOp = AC_SRC_OVER;
  blend.SourceConstantAlpha =
      static_cast<BYTE>(std::round(ClampValue(opacity_, 0.0, 1.0) * 255.0));
  blend.AlphaFormat = AC_SRC_ALPHA;
  UpdateLayeredWindow(hwnd_, screen_dc, &dst_pt, &size, backbuffer_dc_, &src_pt,
                      0, &blend, ULW_ALPHA);
  ReleaseDC(nullptr, screen_dc);
}

}  // namespace desktop_lyrics
