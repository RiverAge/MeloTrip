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

std::vector<LyricsLineEntry> ParseLyricsLines(const flutter::EncodableMap& map) {
  std::vector<LyricsLineEntry> result;
  const auto lines_it = map.find(flutter::EncodableValue("lines"));
  if (lines_it == map.end()) return result;

  const auto* lines_list = std::get_if<flutter::EncodableList>(&lines_it->second);
  if (!lines_list) return result;

  for (const auto& line_value : *lines_list) {
    const auto* line_map = std::get_if<flutter::EncodableMap>(&line_value);
    if (!line_map) continue;

    const int64_t start_ms = ReadInt64FromMap(*line_map, "start", 0);
    std::wstring text;

    const auto value_it = line_map->find(flutter::EncodableValue("value"));
    if (value_it != line_map->end()) {
      if (const auto* values =
              std::get_if<flutter::EncodableList>(&value_it->second)) {
        for (const auto& value : *values) {
          if (const auto* utf8 = std::get_if<std::string>(&value)) {
            if (!text.empty()) text += L"  ";
            text += Utf8ToWide(*utf8);
          }
        }
      }
    }

    if (!text.empty()) {
      result.push_back({start_ms, text});
    }
  }

  return result;
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
  overlay_->Create();
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
  if (method_call.method_name() == "updateTrack") {
    if (!arguments) {
      result->Success();
      return;
    }
    const auto title = Utf8ToWide(ReadStringFromMap(*arguments, "title"));
    const auto artist = Utf8ToWide(ReadStringFromMap(*arguments, "artist"));
    auto lines = ParseLyricsLines(*arguments);
    overlay_->UpdateTrack(title, artist, lines);
    result->Success();
    return;
  }
  if (method_call.method_name() == "updateProgress") {
    if (!arguments) {
      result->Success();
      return;
    }
    const int64_t position_ms = ReadInt64FromMap(*arguments, "positionMs", 0);
    const int64_t duration_ms = ReadInt64FromMap(*arguments, "durationMs", 0);
    overlay_->UpdateProgress(position_ms, duration_ms);
    result->Success();
    return;
  }
  if (method_call.method_name() == "updateConfig") {
    if (!arguments) {
      result->Success();
      return;
    }
    const bool enabled = ReadBoolFromMap(*arguments, "enabled", false);
    const bool click_through = ReadBoolFromMap(*arguments, "clickThrough", true);
    const double font_size = ReadDoubleFromMap(*arguments, "fontSize", 34.0);
    const double opacity = ReadDoubleFromMap(*arguments, "opacity", 0.93);
    const uint32_t text_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "textColorArgb", 0xFFF2F2F8));
    const uint32_t shadow_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "shadowColorArgb", 0xFF121214));
    const uint32_t stroke_argb = static_cast<uint32_t>(
        ReadInt64FromMap(*arguments, "strokeColorArgb", 0x00000000));
    const double stroke_width = ReadDoubleFromMap(*arguments, "strokeWidth", 0.0);
    overlay_->UpdateConfig(enabled, click_through, font_size, opacity, text_argb,
                           shadow_argb, stroke_argb, stroke_width);
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
