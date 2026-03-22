#ifndef FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_
#define FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(WindowTitleBarPlugin,
                     window_title_bar_plugin,
                     WINDOW_TITLE_BAR,
                     PLUGIN,
                     GObject)

void window_title_bar_plugin_register_with_registrar(FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_WINDOW_TITLE_BAR_PLUGIN_H_
