#include "window_startup_config.h"

#include <flutter_windows.h>

void ConfigureInitialWindowPositionAndScale(HWND window_handle,
                                            int logical_width,
                                            int logical_height) {
  POINT cursor_pos{};
  GetCursorPos(&cursor_pos);
  HMONITOR monitor = MonitorFromPoint(cursor_pos, MONITOR_DEFAULTTONEAREST);

  MONITORINFO monitor_info{};
  monitor_info.cbSize = sizeof(MONITORINFO);
  GetMonitorInfo(monitor, &monitor_info);

  const RECT work = monitor_info.rcWork;
  const int screen_width = work.right - work.left;
  const int screen_height = work.bottom - work.top;

  const UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
  const double scale_factor = dpi / 96.0;

  const int physical_width = static_cast<int>(logical_width * scale_factor);
  const int physical_height = static_cast<int>(logical_height * scale_factor);

  const int width = physical_width < screen_width ? physical_width : screen_width;
  const int height = physical_height < screen_height ? physical_height : screen_height;

  const int left = work.left + ((screen_width - width) > 0 ? (screen_width - width) / 2 : 0);
  const int top = work.top + ((screen_height - height) > 0 ? (screen_height - height) / 2 : 0);

  SetWindowPos(window_handle, nullptr, left, top, width, height,
               SWP_NOZORDER | SWP_NOACTIVATE);
}
