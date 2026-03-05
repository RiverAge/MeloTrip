//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_lyrics/desktop_lyrics_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) desktop_lyrics_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopLyricsPlugin");
  desktop_lyrics_plugin_register_with_registrar(desktop_lyrics_registrar);
}
