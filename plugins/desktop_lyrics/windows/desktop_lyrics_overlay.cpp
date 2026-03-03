#include "desktop_lyrics_overlay.h"

#include <algorithm>
#include <cmath>

namespace desktop_lyrics {
namespace {

constexpr const wchar_t kLyricsWindowClassName[] = L"MELOTRIP_DESKTOP_LYRICS";
constexpr int kOverlayWidth = 900;
constexpr int kOverlayHeight = 140;
constexpr int kBottomMargin = 120;
constexpr COLORREF kClearColor = RGB(1, 2, 3);

COLORREF ArgbToColorRef(uint32_t argb) {
  const BYTE r = static_cast<BYTE>((argb >> 16) & 0xFF);
  const BYTE g = static_cast<BYTE>((argb >> 8) & 0xFF);
  const BYTE b = static_cast<BYTE>(argb & 0xFF);
  return RGB(r, g, b);
}

}  // namespace

DesktopLyricsOverlay::DesktopLyricsOverlay() = default;

DesktopLyricsOverlay::~DesktopLyricsOverlay() {
  Dispose();
}

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
      CW_USEDEFAULT, kOverlayWidth, kOverlayHeight, nullptr, nullptr,
      GetModuleHandle(nullptr), this);

  if (!hwnd_) return false;

  ApplyWindowStyles();
  ApplyLayeredOpacity();
  PositionNearBottomCenter();
  return true;
}

void DesktopLyricsOverlay::Show() {
  if (!enabled_) return;
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
  if (!hwnd_) return;
  DestroyWindow(hwnd_);
  hwnd_ = nullptr;
}

void DesktopLyricsOverlay::UpdateTrack(
    const std::wstring& title,
    const std::wstring& artist,
    const std::vector<LyricsLineEntry>& lines) {
  title_ = title;
  artist_ = artist;
  lines_ = lines;
  position_ms_ = 0;
  duration_ms_ = 0;
  current_line_.clear();
  const bool changed = UpdateCurrentLineByPosition();

  if (title_.empty() && artist_.empty() && lines_.empty()) {
    Hide();
    return;
  }
  if (enabled_) Show();
  if (changed) RequestRepaint();
}

void DesktopLyricsOverlay::UpdateProgress(int64_t position_ms,
                                          int64_t duration_ms) {
  position_ms_ = std::max<int64_t>(0, position_ms);
  duration_ms_ = std::max<int64_t>(0, duration_ms);
  const bool changed = UpdateCurrentLineByPosition();
  if (changed) {
    RequestRepaint();
  }
}

void DesktopLyricsOverlay::UpdateConfig(bool enabled,
                                        bool click_through,
                                        double font_size,
                                        double opacity,
                                        uint32_t text_argb,
                                        uint32_t shadow_argb,
                                        uint32_t stroke_argb,
                                        double stroke_width) {
  enabled_ = enabled;
  click_through_ = click_through;
  font_size_ = std::clamp(font_size, 20.0, 72.0);
  opacity_ = std::clamp(opacity, 0.25, 1.0);
  text_argb_ = text_argb;
  shadow_argb_ = shadow_argb;
  stroke_argb_ = stroke_argb;
  stroke_width_ = std::clamp(stroke_width, 0.0, 6.0);

  if (!hwnd_ && !Create()) return;
  ApplyWindowStyles();
  ApplyLayeredOpacity();

  if (!enabled_) {
    Hide();
    return;
  }
  Show();
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
      HDC hdc = BeginPaint(hwnd, &ps);
      RECT rect;
      GetClientRect(hwnd, &rect);

      HBRUSH brush = CreateSolidBrush(kClearColor);
      FillRect(hdc, &rect, brush);
      DeleteObject(brush);

      SetBkMode(hdc, TRANSPARENT);

      const int title_px = static_cast<int>(std::round(font_size_));
      HFONT title_font = CreateFontW(title_px, 0, 0, 0, FW_BOLD, FALSE, FALSE,
                                     FALSE, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS,
                                     CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY,
                                     DEFAULT_PITCH | FF_DONTCARE, L"Segoe UI");

      RECT title_rect = rect;
      title_rect.left += 24;
      title_rect.right -= 24;
      title_rect.top += 10;
      title_rect.bottom -= 10;

      SelectObject(hdc, title_font);
      const std::wstring title_text =
          current_line_.empty() ? title_ : current_line_;
      RECT shadow_rect = title_rect;
      shadow_rect.left += 1;
      shadow_rect.right += 1;
      shadow_rect.top += 1;
      shadow_rect.bottom += 1;
      SetTextColor(hdc, ArgbToColorRef(shadow_argb_));
      DrawTextW(hdc, title_text.c_str(), -1, &shadow_rect,
                DT_CENTER | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);

      if (stroke_width_ > 0.01) {
        const int radius = static_cast<int>(std::round(stroke_width_));
        SetTextColor(hdc, ArgbToColorRef(stroke_argb_));
        for (int dx = -radius; dx <= radius; ++dx) {
          for (int dy = -radius; dy <= radius; ++dy) {
            if (dx == 0 && dy == 0) continue;
            RECT stroke_rect = title_rect;
            stroke_rect.left += dx;
            stroke_rect.right += dx;
            stroke_rect.top += dy;
            stroke_rect.bottom += dy;
            DrawTextW(hdc, title_text.c_str(), -1, &stroke_rect,
                      DT_CENTER | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);
          }
        }
      }

      SetTextColor(hdc, ArgbToColorRef(text_argb_));
      DrawTextW(hdc, title_text.c_str(), -1, &title_rect,
                DT_CENTER | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);

      DeleteObject(title_font);
      EndPaint(hwnd, &ps);
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
  const int left = work.left + (screen_width - kOverlayWidth) / 2;
  const int top = work.top + screen_height - kOverlayHeight - kBottomMargin;

  SetWindowPos(hwnd_, HWND_TOPMOST, left, top, kOverlayWidth, kOverlayHeight,
               SWP_NOACTIVATE);
}

bool DesktopLyricsOverlay::UpdateCurrentLineByPosition() {
  const std::wstring old_line = current_line_;
  if (lines_.empty()) {
    current_line_.clear();
    return old_line != current_line_;
  }

  const auto it = std::upper_bound(
      lines_.begin(), lines_.end(), position_ms_,
      [](int64_t value, const LyricsLineEntry& entry) {
        return value < entry.start_ms;
      });

  if (it == lines_.begin()) {
    current_line_ = lines_.front().text;
    return old_line != current_line_;
  }
  current_line_ = std::prev(it)->text;
  return old_line != current_line_;
}

void DesktopLyricsOverlay::RequestRepaint() {
  if (!hwnd_) return;
  InvalidateRect(hwnd_, nullptr, TRUE);
  UpdateWindow(hwnd_);
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

void DesktopLyricsOverlay::ApplyLayeredOpacity() {
  if (!hwnd_) return;
  const BYTE alpha = static_cast<BYTE>(std::round(opacity_ * 255.0));
  SetLayeredWindowAttributes(hwnd_, kClearColor, alpha,
                             LWA_ALPHA | LWA_COLORKEY);
}

}  // namespace desktop_lyrics
