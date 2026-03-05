#include "desktop_lyrics_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <algorithm>
#include <optional>
#include <memory>
#include <sstream>
#include <string>
#include <vector>

namespace desktop_lyrics {
namespace {

std::wstring Utf8ToWide(const std::string& input) {
  if (input.empty()) return L"";
  const int size_needed = MultiByteToWideChar(CP_UTF8, 0, input.c_str(), -1,
                                              nullptr, 0);
  if (size_needed <= 0) return L"";
  std::wstring output(static_cast<size_t>(size_needed), L'\0');
  MultiByteToWideChar(CP_UTF8, 0, input.c_str(), -1, output.data(),
                      size_needed);
  if (!output.empty() && output.back() == L'\0') output.pop_back();
  return output;
}

std::string ReadStringFromMap(const flutter::EncodableMap& map,
                              const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) return "";
  if (const auto value = std::get_if<std::string>(&it->second)) {
    return *value;
  }
  return "";
}

int64_t ReadInt64FromMap(const flutter::EncodableMap& map,
                         const char* key,
                         int64_t fallback) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) return fallback;

  if (const auto value = std::get_if<int64_t>(&it->second)) return *value;
  if (const auto value = std::get_if<int32_t>(&it->second)) return *value;
  return fallback;
}

bool ReadBoolFromMap(const flutter::EncodableMap& map,
                     const char* key,
                     bool fallback) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) return fallback;

  if (const auto value = std::get_if<bool>(&it->second)) return *value;
  if (const auto value = std::get_if<int64_t>(&it->second)) return *value != 0;
  if (const auto value = std::get_if<int32_t>(&it->second)) return *value != 0;
  return fallback;
}

double ReadDoubleFromMap(const flutter::EncodableMap& map,
                         const char* key,
                         double fallback) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) return fallback;

  if (const auto value = std::get_if<double>(&it->second)) return *value;
  if (const auto value = std::get_if<int64_t>(&it->second)) {
    return static_cast<double>(*value);
  }
  if (const auto value = std::get_if<int32_t>(&it->second)) {
    return static_cast<double>(*value);
  }
  return fallback;
}

std::wstring ParseCurrentLineFromFrame(const flutter::EncodableMap& map) {
  return Utf8ToWide(ReadStringFromMap(map, "currentLine"));
}

}  // namespace

// static
void DesktopLyricsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "desktop_lyrics",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DesktopLyricsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DesktopLyricsPlugin::DesktopLyricsPlugin() {
  overlay_ = std::make_unique<DesktopLyricsOverlay>();
}

DesktopLyricsPlugin::~DesktopLyricsPlugin() {
  if (overlay_) {
    overlay_->Dispose();
    overlay_.reset();
  }
}

void DesktopLyricsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!overlay_) {
    result->Success();
    return;
  }

  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());

  if (method_call.method_name() == "show") {
    overlay_->Show();
    result->Success();
    return;
  }
  if (method_call.method_name() == "hide") {
    overlay_->Hide();
    result->Success();
    return;
  }
  if (method_call.method_name() == "dispose") {
    overlay_->Dispose();
    result->Success();
    return;
  }
  if (method_call.method_name() == "updateLyricFrame") {
    if (!arguments) {
      result->Success();
      return;
    }
    const auto current_line = ParseCurrentLineFromFrame(*arguments);
    const double line_progress =
        std::clamp(ReadDoubleFromMap(*arguments, "lineProgress", 1.0), 0.0, 1.0);
    overlay_->UpdateLyricFrame(current_line, line_progress);
    result->Success();
    return;
  }
  if (method_call.method_name() == "updateConfig") {
    if (!arguments) {
      result->Success();
      return;
    }
    OverlayConfig config;
    config.enabled = ReadBoolFromMap(*arguments, "enabled", true);
    config.click_through = ReadBoolFromMap(*arguments, "clickThrough", false);
    config.font_size = ReadDoubleFromMap(*arguments, "fontSize", 38.0);
    config.opacity = ReadDoubleFromMap(*arguments, "opacity", 0.96);
    config.text_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "textColorArgb", 0xFFF6F7FF));
    config.shadow_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "shadowColorArgb", 0x00000000));
    config.stroke_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "strokeColorArgb", 0x00000000));
    config.stroke_width = ReadDoubleFromMap(*arguments, "strokeWidth", 0.0);
    config.background_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "backgroundColorArgb", 0x7A220A35));
    config.background_radius =
        ReadDoubleFromMap(*arguments, "backgroundRadius", 22.0);
    config.background_padding =
        ReadDoubleFromMap(*arguments, "backgroundPadding", 12.0);
    config.text_gradient_enabled =
        ReadBoolFromMap(*arguments, "textGradientEnabled", true);
    config.text_gradient_start_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "textGradientStartArgb", 0xFFFFD36E));
    config.text_gradient_end_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "textGradientEndArgb", 0xFFFF4D8D));
    config.text_gradient_angle =
        ReadDoubleFromMap(*arguments, "textGradientAngle", 0.0);
    config.overlay_width =
        ReadDoubleFromMap(*arguments, "overlayWidth", 980.0);
    config.overlay_height =
        ReadDoubleFromMap(*arguments, "overlayHeight", -1.0);
    config.font_family = Utf8ToWide(ReadStringFromMap(*arguments, "fontFamily"));
    config.text_align = static_cast<int>(
        ReadInt64FromMap(*arguments, "textAlign", 0));
    config.font_weight_value = static_cast<int>(
        ReadInt64FromMap(*arguments, "fontWeightValue", 400));
    overlay_->UpdateConfig(config);
    result->Success();
    return;
  }

  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
    return;
  }

  result->NotImplemented();
}

}  // namespace desktop_lyrics
