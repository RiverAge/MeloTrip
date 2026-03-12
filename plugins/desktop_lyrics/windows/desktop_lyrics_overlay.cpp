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

}  // namespace desktop_lyrics
