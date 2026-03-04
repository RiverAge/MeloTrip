//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_lyrics/desktop_lyrics_plugin.h>
#include <media_kit_libs_linux/media_kit_libs_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) desktop_lyrics_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopLyricsPlugin");
  desktop_lyrics_plugin_register_with_registrar(desktop_lyrics_registrar);
  g_autoptr(FlPluginRegistrar) media_kit_libs_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MediaKitLibsLinuxPlugin");
  media_kit_libs_linux_plugin_register_with_registrar(media_kit_libs_linux_registrar);
}
