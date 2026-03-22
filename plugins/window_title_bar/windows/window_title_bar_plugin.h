#ifndef FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_
#define FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_

#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

class WindowTitleBarPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  explicit WindowTitleBarPlugin(flutter::PluginRegistrarWindows* registrar);
  ~WindowTitleBarPlugin() override;

  WindowTitleBarPlugin(const WindowTitleBarPlugin&) = delete;
  WindowTitleBarPlugin& operator=(const WindowTitleBarPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  bool ConfigureCustomTitleBar(bool enabled);
  void MinimizeWindow();
  void ToggleMaximizeWindow();
  bool IsWindowMaximized();
  void CloseWindow();
  HWND GetWindowHandle();
  void AttachWindowProc(HWND window, HWND child_window);
  void DetachWindowProc();
  LRESULT HandleWindowMessage(HWND hwnd,
                              UINT message,
                              WPARAM wparam,
                              LPARAM lparam);
  static LRESULT CALLBACK WindowProc(HWND hwnd,
                                     UINT message,
                                     WPARAM wparam,
                                     LPARAM lparam);
  static LRESULT CALLBACK ChildWindowProc(HWND hwnd,
                                          UINT message,
                                          WPARAM wparam,
                                          LPARAM lparam);

  flutter::PluginRegistrarWindows* registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  HWND window_handle_ = nullptr;
  WNDPROC original_wnd_proc_ = nullptr;
  HWND child_window_handle_ = nullptr;
  WNDPROC original_child_wnd_proc_ = nullptr;
  bool custom_title_bar_enabled_ = false;
  int drag_region_height_dip_ = 60;
  int drag_region_right_inset_dip_ = 180;
};

#endif  // FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_
