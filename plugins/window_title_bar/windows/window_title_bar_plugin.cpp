#include "window_title_bar_plugin.h"

#include <windows.h>
#include <dwmapi.h>

#include <flutter/standard_method_codec.h>

#include <memory>

namespace {
constexpr wchar_t kWindowTitleBarPropName[] = L"melo_trip_window_title_bar_plugin";

int GetResizeBorderThickness(HWND hwnd) {
  const UINT dpi = GetDpiForWindow(hwnd);
  const int fallback = MulDiv(8, static_cast<int>(dpi), 96);
  const int frame = GetSystemMetricsForDpi(SM_CXSIZEFRAME, dpi);
  const int padded = GetSystemMetricsForDpi(SM_CXPADDEDBORDER, dpi);
  const int total = frame + padded;
  if (total > 0) {
    return total;
  }
  return fallback > 0 ? fallback : 8;
}

int DipToPx(HWND hwnd, int dip) {
  const UINT dpi = GetDpiForWindow(hwnd);
  return MulDiv(dip, static_cast<int>(dpi), 96);
}

int ReadIntArg(const flutter::EncodableMap& args,
               const char* key,
               int fallback_value) {
  const auto it = args.find(flutter::EncodableValue(key));
  if (it == args.end()) {
    return fallback_value;
  }
  if (const auto* value = std::get_if<int32_t>(&it->second)) {
    return static_cast<int>(*value);
  }
  if (const auto* value = std::get_if<int64_t>(&it->second)) {
    return static_cast<int>(*value);
  }
  if (const auto* value = std::get_if<double>(&it->second)) {
    return static_cast<int>(*value);
  }
  return fallback_value;
}
}  // namespace

void WindowTitleBarPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(),
          "melo_trip/window_title_bar",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<WindowTitleBarPlugin>(registrar);
  plugin->channel_ = std::move(channel);

  plugin->channel_->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

WindowTitleBarPlugin::WindowTitleBarPlugin(
    flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar) {}

WindowTitleBarPlugin::~WindowTitleBarPlugin() {
  DetachWindowProc();
}

void WindowTitleBarPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto& method_name = method_call.method_name();
  if (method_name == "apply") {
    const auto* args =
        std::get_if<flutter::EncodableMap>(method_call.arguments());
    bool enabled = false;
    if (args != nullptr) {
      const auto enabled_it = args->find(flutter::EncodableValue("enabled"));
      if (enabled_it != args->end()) {
        const auto* enabled_value = std::get_if<bool>(&enabled_it->second);
        if (enabled_value != nullptr) {
          enabled = *enabled_value;
        }
      }
      drag_region_height_dip_ = ReadIntArg(*args, "dragRegionHeight", 60);
      drag_region_right_inset_dip_ =
          ReadIntArg(*args, "dragRegionRightInset", 180);
    }
    result->Success(flutter::EncodableValue(ConfigureCustomTitleBar(enabled)));
    return;
  }
  if (method_name == "minimize") {
    MinimizeWindow();
    result->Success();
    return;
  }
  if (method_name == "toggleMaximize") {
    ToggleMaximizeWindow();
    result->Success();
    return;
  }
  if (method_name == "isMaximized") {
    result->Success(flutter::EncodableValue(IsWindowMaximized()));
    return;
  }
  if (method_name == "close") {
    CloseWindow();
    result->Success();
    return;
  }
  result->NotImplemented();
}

bool WindowTitleBarPlugin::ConfigureCustomTitleBar(bool enabled) {
  HWND window = GetWindowHandle();
  if (!window) {
    return false;
  }

  LONG_PTR style = GetWindowLongPtr(window, GWL_STYLE);
  if (enabled) {
    style &= ~WS_CAPTION;
    style |= WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU;
  } else {
    style |= WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX |
             WS_SYSMENU;
  }

  SetWindowLongPtr(window, GWL_STYLE, style);
  if (enabled) {
    auto* view = registrar_->GetView();
    HWND child_window = view ? view->GetNativeWindow() : nullptr;
    AttachWindowProc(window, child_window);

    // Call DwmExtendFrameIntoClientArea to ensure window shadow is maintained 
    // even when the non-client area is removed.
    MARGINS margins = {1, 1, 1, 1};
    DwmExtendFrameIntoClientArea(window, &margins);
  } else {
    DetachWindowProc();
  }
  custom_title_bar_enabled_ = enabled;
  SetWindowPos(window, nullptr, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);

  return true;
}

void WindowTitleBarPlugin::MinimizeWindow() {
  HWND window = GetWindowHandle();
  if (!window) {
    return;
  }
  ShowWindow(window, SW_MINIMIZE);
}

void WindowTitleBarPlugin::ToggleMaximizeWindow() {
  HWND window = GetWindowHandle();
  if (!window) {
    return;
  }
  ShowWindow(window, IsZoomed(window) ? SW_RESTORE : SW_MAXIMIZE);
}

bool WindowTitleBarPlugin::IsWindowMaximized() {
  HWND window = GetWindowHandle();
  if (!window) {
    return false;
  }
  return IsZoomed(window) != FALSE;
}

void WindowTitleBarPlugin::CloseWindow() {
  HWND window = GetWindowHandle();
  if (!window) {
    return;
  }
  PostMessage(window, WM_CLOSE, 0, 0);
}

HWND WindowTitleBarPlugin::GetWindowHandle() {
  if (window_handle_ != nullptr) {
    return window_handle_;
  }
  auto* view = registrar_->GetView();
  if (view == nullptr) {
    return nullptr;
  }
  HWND window = view->GetNativeWindow();
  if (window == nullptr) {
    return nullptr;
  }
  return GetAncestor(window, GA_ROOT);
}

void WindowTitleBarPlugin::AttachWindowProc(HWND window, HWND child_window) {
  if (window == nullptr) {
    return;
  }
  if (window_handle_ == window && original_wnd_proc_ != nullptr) {
    return;
  }
  DetachWindowProc();

  window_handle_ = window;
  SetPropW(window_handle_, kWindowTitleBarPropName, this);
  original_wnd_proc_ = reinterpret_cast<WNDPROC>(SetWindowLongPtr(
      window_handle_, GWLP_WNDPROC,
      reinterpret_cast<LONG_PTR>(&WindowTitleBarPlugin::WindowProc)));

  if (child_window != nullptr && child_window != window_handle_) {
    child_window_handle_ = child_window;
    SetPropW(child_window_handle_, kWindowTitleBarPropName, this);
    original_child_wnd_proc_ = reinterpret_cast<WNDPROC>(SetWindowLongPtr(
        child_window_handle_, GWLP_WNDPROC,
        reinterpret_cast<LONG_PTR>(&WindowTitleBarPlugin::ChildWindowProc)));
  }
}

void WindowTitleBarPlugin::DetachWindowProc() {
  if (window_handle_ != nullptr) {
    RemovePropW(window_handle_, kWindowTitleBarPropName);
    if (original_wnd_proc_ != nullptr) {
      SetWindowLongPtr(window_handle_, GWLP_WNDPROC,
                       reinterpret_cast<LONG_PTR>(original_wnd_proc_));
    }
    original_wnd_proc_ = nullptr;
    window_handle_ = nullptr;
  }

  if (child_window_handle_ != nullptr) {
    RemovePropW(child_window_handle_, kWindowTitleBarPropName);
    if (original_child_wnd_proc_ != nullptr) {
      SetWindowLongPtr(child_window_handle_, GWLP_WNDPROC,
                       reinterpret_cast<LONG_PTR>(original_child_wnd_proc_));
    }
    original_child_wnd_proc_ = nullptr;
    child_window_handle_ = nullptr;
  }
}

LRESULT WindowTitleBarPlugin::ChildWindowProc(HWND hwnd,
                                              UINT message,
                                              WPARAM wparam,
                                              LPARAM lparam) {
  auto* plugin = reinterpret_cast<WindowTitleBarPlugin*>(
      GetPropW(hwnd, kWindowTitleBarPropName));
  if (plugin == nullptr) {
    return DefWindowProc(hwnd, message, wparam, lparam);
  }
  return plugin->HandleWindowMessage(hwnd, message, wparam, lparam);
}

LRESULT WindowTitleBarPlugin::HandleWindowMessage(HWND hwnd,
                                                  UINT message,
                                                  WPARAM wparam,
                                                  LPARAM lparam) {
  WNDPROC original_proc =
      (hwnd == window_handle_) ? original_wnd_proc_ : original_child_wnd_proc_;

  if (!custom_title_bar_enabled_ || original_proc == nullptr) {
    return CallWindowProc(original_proc, hwnd, message, wparam, lparam);
  }

  switch (message) {
    case WM_NCCALCSIZE:
      if (hwnd == window_handle_ && wparam == TRUE) {
        if (IsZoomed(hwnd)) {
          auto* params = reinterpret_cast<NCCALCSIZE_PARAMS*>(lparam);
          const int frame_x =
              GetSystemMetrics(SM_CXSIZEFRAME) + GetSystemMetrics(SM_CXPADDEDBORDER);
          const int frame_y =
              GetSystemMetrics(SM_CYSIZEFRAME) + GetSystemMetrics(SM_CXPADDEDBORDER);
          params->rgrc[0].left += frame_x;
          params->rgrc[0].right -= frame_x;
          params->rgrc[0].top += frame_y;
          params->rgrc[0].bottom -= frame_y;
        }
        // Return 0 to indicate that the entire window rect is the client area.
        return 0;
      }
      break;
    case WM_NCPAINT:
    case WM_NCACTIVATE:
      if (hwnd == window_handle_) {
        // Prevent Windows from drawing the default non-client area (title bar and buttons).
        return (message == WM_NCACTIVATE) ? TRUE : 0;
      }
      break;
    case WM_SIZE:
      if (hwnd == window_handle_ && channel_ != nullptr) {
        flutter::EncodableMap event;
        if (wparam == SIZE_MAXIMIZED) {
          event[flutter::EncodableValue("state")] = "maximized";
        } else if (wparam == SIZE_RESTORED) {
          event[flutter::EncodableValue("state")] = "restored";
        } else if (wparam == SIZE_MINIMIZED) {
          event[flutter::EncodableValue("state")] = "minimized";
        }
        if (!event.empty()) {
          channel_->InvokeMethod("onWindowStateChanged",
                                std::make_unique<flutter::EncodableValue>(event));
        }
      }
      break;
    case WM_NCHITTEST: {
      if (IsZoomed(window_handle_)) {
        return (hwnd == window_handle_) ? HTCLIENT : CallWindowProc(original_proc, hwnd, message, wparam, lparam);
      }

      POINT point = {static_cast<LONG>(static_cast<short>(LOWORD(lparam))),
                     static_cast<LONG>(static_cast<short>(HIWORD(lparam)))};
      ScreenToClient(window_handle_, &point);

      RECT client_rect = {};
      GetClientRect(window_handle_, &client_rect);

      const int border = GetResizeBorderThickness(window_handle_);
      const bool left = point.x >= client_rect.left &&
                        point.x < client_rect.left + border;
      const bool right = point.x < client_rect.right &&
                         point.x >= client_rect.right - border;
      const bool top = point.y >= client_rect.top &&
                       point.y < client_rect.top + border;
      const bool bottom = point.y < client_rect.bottom &&
                          point.y >= client_rect.bottom - border;

      const bool is_resize_border = left || right || top || bottom;

      const int drag_height = DipToPx(window_handle_, drag_region_height_dip_);
      const int right_inset = DipToPx(window_handle_, drag_region_right_inset_dip_);
      const bool is_drag_row =
          point.y >= client_rect.top &&
          point.y < client_rect.top + drag_height &&
          point.x < client_rect.right - right_inset;

      if (hwnd == child_window_handle_) {
        if (is_resize_border || is_drag_row) {
          return HTTRANSPARENT;
        }
        return CallWindowProc(original_proc, hwnd, message, wparam, lparam);
      }

      if (left && top) return HTTOPLEFT;
      if (right && top) return HTTOPRIGHT;
      if (left && bottom) return HTBOTTOMLEFT;
      if (right && bottom) return HTBOTTOMRIGHT;
      if (left) return HTLEFT;
      if (right) return HTRIGHT;
      if (top) return HTTOP;
      if (bottom) return HTBOTTOM;

      if (is_drag_row) {
        return HTCAPTION;
      }
      return HTCLIENT;
    }
    default:
      break;
  }

  return CallWindowProc(original_proc, hwnd, message, wparam, lparam);
}

LRESULT CALLBACK WindowTitleBarPlugin::WindowProc(HWND hwnd,
                                                  UINT message,
                                                  WPARAM wparam,
                                                  LPARAM lparam) {
  auto* plugin = reinterpret_cast<WindowTitleBarPlugin*>(
      GetPropW(hwnd, kWindowTitleBarPropName));
  if (plugin == nullptr) {
    return DefWindowProc(hwnd, message, wparam, lparam);
  }
  return plugin->HandleWindowMessage(hwnd, message, wparam, lparam);
}
