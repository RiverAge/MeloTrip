#include "include/desktop_lyrics/desktop_lyrics_plugin.h"

#include <flutter_linux/flutter_linux.h>

#include <cstring>
#include <sys/utsname.h>

struct _DesktopLyricsPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(DesktopLyricsPlugin, desktop_lyrics_plugin, g_object_get_type())

static FlMethodResponse* BuildSuccessResponse() {
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static void desktop_lyrics_plugin_handle_method_call(
    DesktopLyricsPlugin* self,
    FlMethodCall* method_call) {
  const gchar* method = fl_method_call_get_name(method_call);
  g_autoptr(FlMethodResponse) response = nullptr;

  if (std::strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data {};
    uname(&uname_data);
    g_autofree gchar* version =
        g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (std::strcmp(method, "updateConfig") == 0 ||
             std::strcmp(method, "updateLyricFrame") == 0 ||
             std::strcmp(method, "show") == 0 ||
             std::strcmp(method, "hide") == 0 ||
             std::strcmp(method, "dispose") == 0) {
    response = BuildSuccessResponse();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void desktop_lyrics_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(desktop_lyrics_plugin_parent_class)->dispose(object);
}

static void desktop_lyrics_plugin_class_init(DesktopLyricsPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = desktop_lyrics_plugin_dispose;
}

static void desktop_lyrics_plugin_init(DesktopLyricsPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel,
                           FlMethodCall* method_call,
                           gpointer user_data) {
  DesktopLyricsPlugin* plugin = DESKTOP_LYRICS_PLUGIN(user_data);
  desktop_lyrics_plugin_handle_method_call(plugin, method_call);
}

void desktop_lyrics_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  DesktopLyricsPlugin* plugin = DESKTOP_LYRICS_PLUGIN(
      g_object_new(desktop_lyrics_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), "desktop_lyrics",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
