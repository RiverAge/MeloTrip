#ifndef FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_
#define FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

#ifdef G_DECLARE_FINAL_TYPE
G_DECLARE_FINAL_TYPE(DesktopLyricsPlugin,
                     desktop_lyrics_plugin,
                     DESKTOP,
                     LYRICS_PLUGIN,
                     GObject)
#else
typedef struct _DesktopLyricsPlugin DesktopLyricsPlugin;
typedef struct {
  GObjectClass parent_class;
} DesktopLyricsPluginClass;

GType desktop_lyrics_plugin_get_type(void);
#endif

FLUTTER_PLUGIN_EXPORT void desktop_lyrics_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_
