#include "include/desktop_lyrics/desktop_lyrics_plugin.h"

#include "desktop_lyrics_overlay.h"

#include <flutter_linux/flutter_linux.h>

#include <algorithm>
#include <cmath>
#include <cstring>
#include <memory>
#include <string>
#include <sys/utsname.h>

struct _DesktopLyricsPlugin {
  GObject parent_instance;
  std::unique_ptr<desktop_lyrics::DesktopLyricsOverlay> overlay;
};

G_DEFINE_TYPE(DesktopLyricsPlugin, desktop_lyrics_plugin, g_object_get_type())

namespace {

FlMethodResponse* BuildSuccessResponse() {
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlValue* ReadMapValue(FlValue* map, const char* key) {
  if (map == nullptr || fl_value_get_type(map) != FL_VALUE_TYPE_MAP) return nullptr;
  return fl_value_lookup_string(map, key);
}

std::string ReadStringFromMap(FlValue* map,
                              const char* key,
                              const std::string& fallback = "") {
  FlValue* value = ReadMapValue(map, key);
  if (value == nullptr || fl_value_get_type(value) != FL_VALUE_TYPE_STRING) {
    return fallback;
  }
  const gchar* raw = fl_value_get_string(value);
  return raw == nullptr ? fallback : std::string(raw);
}

int64_t ReadInt64FromMap(FlValue* map, const char* key, int64_t fallback) {
  FlValue* value = ReadMapValue(map, key);
  if (value == nullptr) return fallback;
  switch (fl_value_get_type(value)) {
    case FL_VALUE_TYPE_INT:
      return fl_value_get_int(value);
    case FL_VALUE_TYPE_FLOAT:
      return static_cast<int64_t>(fl_value_get_float(value));
    case FL_VALUE_TYPE_BOOL:
      return fl_value_get_bool(value) ? 1 : 0;
    default:
      return fallback;
  }
}

bool ReadBoolFromMap(FlValue* map, const char* key, bool fallback) {
  FlValue* value = ReadMapValue(map, key);
  if (value == nullptr) return fallback;
  switch (fl_value_get_type(value)) {
    case FL_VALUE_TYPE_BOOL:
      return fl_value_get_bool(value);
    case FL_VALUE_TYPE_INT:
      return fl_value_get_int(value) != 0;
    case FL_VALUE_TYPE_FLOAT:
      return std::abs(fl_value_get_float(value)) > 0.0001;
    default:
      return fallback;
  }
}

double ReadDoubleFromMap(FlValue* map, const char* key, double fallback) {
  FlValue* value = ReadMapValue(map, key);
  if (value == nullptr) return fallback;
  switch (fl_value_get_type(value)) {
    case FL_VALUE_TYPE_FLOAT:
      return fl_value_get_float(value);
    case FL_VALUE_TYPE_INT:
      return static_cast<double>(fl_value_get_int(value));
    default:
      return fallback;
  }
}

void HandleUpdateFrame(DesktopLyricsPlugin* plugin,
                       FlValue* arguments,
                       FlMethodResponse** response_out) {
  if (plugin == nullptr || plugin->overlay == nullptr ||
      arguments == nullptr || fl_value_get_type(arguments) != FL_VALUE_TYPE_MAP) {
    *response_out = BuildSuccessResponse();
    return;
  }

  const std::string line = ReadStringFromMap(arguments, "currentLine");
  const double progress = std::clamp(
      ReadDoubleFromMap(arguments, "lineProgress", 1.0), 0.0, 1.0);
  plugin->overlay->UpdateLyricFrame(line, progress);
  *response_out = BuildSuccessResponse();
}

void HandleUpdateConfig(DesktopLyricsPlugin* plugin,
                        FlValue* arguments,
                        FlMethodResponse** response_out) {
  if (plugin == nullptr || plugin->overlay == nullptr ||
      arguments == nullptr || fl_value_get_type(arguments) != FL_VALUE_TYPE_MAP) {
    *response_out = BuildSuccessResponse();
    return;
  }

  desktop_lyrics::OverlayConfig config;
  config.enabled = ReadBoolFromMap(arguments, "enabled", true);
  config.click_through = ReadBoolFromMap(arguments, "clickThrough", false);
  config.font_size = ReadDoubleFromMap(arguments, "fontSize", 38.0);
  config.opacity = ReadDoubleFromMap(arguments, "opacity", 0.96);
  config.text_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "textColorArgb", 0xFFF6F7FF));
  config.shadow_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "shadowColorArgb", 0x00000000));
  config.stroke_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "strokeColorArgb", 0x00000000));
  config.stroke_width = ReadDoubleFromMap(arguments, "strokeWidth", 0.0);
  config.background_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "backgroundColorArgb", 0x7A220A35));
  config.background_radius = ReadDoubleFromMap(arguments, "backgroundRadius", 22.0);
  config.background_padding =
      ReadDoubleFromMap(arguments, "backgroundPadding", 12.0);
  config.text_gradient_enabled =
      ReadBoolFromMap(arguments, "textGradientEnabled", true);
  config.text_gradient_start_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "textGradientStartArgb", 0xFFFFD36E));
  config.text_gradient_end_argb = static_cast<uint32_t>(
      ReadInt64FromMap(arguments, "textGradientEndArgb", 0xFFFF4D8D));
  config.text_gradient_angle = ReadDoubleFromMap(arguments, "textGradientAngle", 0.0);
  config.overlay_width = ReadDoubleFromMap(arguments, "overlayWidth", 980.0);
  config.overlay_height = ReadDoubleFromMap(arguments, "overlayHeight", -1.0);
  config.font_family = ReadStringFromMap(arguments, "fontFamily", "Sans");
  config.text_align = static_cast<int>(ReadInt64FromMap(arguments, "textAlign", 0));
  config.font_weight_value =
      static_cast<int>(ReadInt64FromMap(arguments, "fontWeightValue", 400));

  plugin->overlay->UpdateConfig(config);
  *response_out = BuildSuccessResponse();
}

}  // namespace

static void desktop_lyrics_plugin_handle_method_call(DesktopLyricsPlugin* self,
                                                     FlMethodCall* method_call) {
  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* arguments = fl_method_call_get_args(method_call);
  g_autoptr(FlMethodResponse) response = nullptr;

  if (std::strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data {};
    uname(&uname_data);
    g_autofree gchar* version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (std::strcmp(method, "show") == 0) {
    if (self->overlay != nullptr) self->overlay->Show();
    response = BuildSuccessResponse();
  } else if (std::strcmp(method, "hide") == 0) {
    if (self->overlay != nullptr) self->overlay->Hide();
    response = BuildSuccessResponse();
  } else if (std::strcmp(method, "dispose") == 0) {
    if (self->overlay != nullptr) self->overlay->Dispose();
    response = BuildSuccessResponse();
  } else if (std::strcmp(method, "updateLyricFrame") == 0) {
    HandleUpdateFrame(self, arguments, &response);
  } else if (std::strcmp(method, "updateConfig") == 0) {
    HandleUpdateConfig(self, arguments, &response);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void desktop_lyrics_plugin_dispose(GObject* object) {
  auto* self = DESKTOP_LYRICS_PLUGIN(object);
  if (self->overlay != nullptr) {
    self->overlay->Dispose();
    self->overlay.reset();
  }
  G_OBJECT_CLASS(desktop_lyrics_plugin_parent_class)->dispose(object);
}

static void desktop_lyrics_plugin_class_init(DesktopLyricsPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = desktop_lyrics_plugin_dispose;
}

static void desktop_lyrics_plugin_init(DesktopLyricsPlugin* self) {
  self->overlay = std::make_unique<desktop_lyrics::DesktopLyricsOverlay>();
}

static void method_call_cb(FlMethodChannel*,
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
                                            g_object_ref(plugin), g_object_unref);

  g_object_unref(plugin);
}
