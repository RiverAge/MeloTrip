//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_lyrics/desktop_lyrics_plugin_c_api.h>
#include <media_kit_libs_windows_audio/media_kit_libs_windows_audio_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DesktopLyricsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopLyricsPluginCApi"));
  MediaKitLibsWindowsAudioPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MediaKitLibsWindowsAudioPluginCApi"));
}
