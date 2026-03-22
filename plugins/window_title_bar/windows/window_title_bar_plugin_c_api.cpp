#include "include/window_title_bar/window_title_bar_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "window_title_bar_plugin.h"

void WindowTitleBarPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  WindowTitleBarPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
