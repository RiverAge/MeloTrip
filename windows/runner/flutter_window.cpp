#include "flutter_window.h"

#include <optional>
#include <flutter_windows.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

// Configures the initial window position and scale based on the monitor 
// where the cursor is currently located. This ensures correct DPI scaling
// when starting on a secondary monitor instead of the primary monitor.
// We must call this AFTER the Flutter engine is initialized so it correctly
// catches the WM_DPICHANGED message and scales all widgets immediately.
void ConfigureInitialWindowPositionAndScale(HWND window_handle, int logical_width, int logical_height) {
  POINT cursor_pos{};
  GetCursorPos(&cursor_pos);
  HMONITOR monitor = MonitorFromPoint(cursor_pos, MONITOR_DEFAULTTONEAREST);
  MONITORINFO monitor_info{};
  monitor_info.cbSize = sizeof(MONITORINFO);
  GetMonitorInfo(monitor, &monitor_info);
  const RECT work = monitor_info.rcWork;
  const int screen_width = work.right - work.left;
  const int screen_height = work.bottom - work.top;
  
  UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
  double scale_factor = dpi / 96.0;
  
  const int physical_width = static_cast<int>(logical_width * scale_factor);
  const int physical_height = static_cast<int>(logical_height * scale_factor);
  
  const int width = physical_width < screen_width ? physical_width : screen_width;
  const int height = physical_height < screen_height ? physical_height : screen_height;
  
  const int left = work.left + ((screen_width - width) > 0 ? (screen_width - width) / 2 : 0);
  const int top = work.top + ((screen_height - height) > 0 ? (screen_height - height) / 2 : 0);

  SetWindowPos(window_handle, nullptr, left, top, width, height, SWP_NOZORDER | SWP_NOACTIVATE);
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  ConfigureInitialWindowPositionAndScale(GetHandle(), 1360, 860);

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
