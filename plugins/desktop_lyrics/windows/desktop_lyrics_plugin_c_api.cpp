#include "include/desktop_lyrics/desktop_lyrics_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "desktop_lyrics_plugin.h"

void DesktopLyricsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  desktop_lyrics::DesktopLyricsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
