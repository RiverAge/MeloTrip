#include "include/window_title_bar/window_title_bar_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <cstring>

struct _WindowTitleBarPlugin {
  GObject parent_instance;
  GtkWindow* window;
};

G_DEFINE_TYPE(WindowTitleBarPlugin, window_title_bar_plugin, g_object_get_type())

static void window_title_bar_plugin_dispose(GObject* object) {
  auto* self = WINDOW_TITLE_BAR_PLUGIN(object);
  self->window = nullptr;
  G_OBJECT_CLASS(window_title_bar_plugin_parent_class)->dispose(object);
}

static void window_title_bar_plugin_class_init(WindowTitleBarPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = window_title_bar_plugin_dispose;
}

static void window_title_bar_plugin_init(WindowTitleBarPlugin* self) {
  self->window = nullptr;
}

static void method_call_cb(FlMethodChannel* channel,
                           FlMethodCall* method_call,
                           gpointer user_data) {
  (void)channel;
  auto* plugin = WINDOW_TITLE_BAR_PLUGIN(user_data);
  const gchar* method = fl_method_call_get_name(method_call);
  GtkWindow* window = plugin->window;

  if (window == nullptr) {
    g_autoptr(FlMethodResponse) response =
        FL_METHOD_RESPONSE(fl_method_error_response_new(
            "window_unavailable", "Window is not available.", nullptr));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  if (strcmp(method, "apply") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    bool enabled = false;
    if (args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue* enabled_value = fl_value_lookup_string(args, "enabled");
      if (enabled_value != nullptr &&
          fl_value_get_type(enabled_value) == FL_VALUE_TYPE_BOOL) {
        enabled = fl_value_get_bool(enabled_value);
      }
    }
    gtk_window_set_decorated(window, !enabled);
    g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(
        fl_method_success_response_new(fl_value_new_bool(TRUE)));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  if (strcmp(method, "minimize") == 0) {
    gtk_window_iconify(window);
    g_autoptr(FlMethodResponse) response =
        FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  if (strcmp(method, "toggleMaximize") == 0) {
    if (gtk_window_is_maximized(window)) {
      gtk_window_unmaximize(window);
    } else {
      gtk_window_maximize(window);
    }
    g_autoptr(FlMethodResponse) response =
        FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  if (strcmp(method, "isMaximized") == 0) {
    g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(
        fl_method_success_response_new(
            fl_value_new_bool(gtk_window_is_maximized(window))));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  if (strcmp(method, "close") == 0) {
    gtk_window_close(window);
    g_autoptr(FlMethodResponse) response =
        FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }

  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  fl_method_call_respond(method_call, response, nullptr);
}

void window_title_bar_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  WindowTitleBarPlugin* plugin = WINDOW_TITLE_BAR_PLUGIN(
      g_object_new(window_title_bar_plugin_get_type(), nullptr));

  FlView* view = fl_plugin_registrar_get_view(registrar);
  if (view != nullptr) {
    GtkWidget* toplevel = gtk_widget_get_toplevel(GTK_WIDGET(view));
    if (GTK_IS_WINDOW(toplevel)) {
      plugin->window = GTK_WINDOW(toplevel);
    }
  }

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "melo_trip/window_title_bar",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
