#include <flutter/method_call.h>
#include <flutter/method_result_functions.h>
#include <flutter/standard_method_codec.h>
#include <gtest/gtest.h>
#include <windows.h>

#include <memory>
#include <string>
#include <variant>

#include "desktop_lyrics_plugin.h"

namespace desktop_lyrics {
namespace test {

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;
using flutter::MethodCall;
using flutter::MethodResultFunctions;

}  // namespace

TEST(DesktopLyricsPlugin, GetPlatformVersion) {
  DesktopLyricsPlugin plugin;
  // Save the reply value from the success callback.
  std::string result_string;
  plugin.HandleMethodCall(
      MethodCall("getPlatformVersion", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&result_string](const EncodableValue* result) {
            result_string = std::get<std::string>(*result);
          },
          nullptr, nullptr));

  // Since the exact string varies by host, just ensure that it's a string
  // with the expected format.
  EXPECT_TRUE(result_string.rfind("Windows ", 0) == 0);
}

TEST(DesktopLyricsPlugin, ShowWithoutLyricFrameReturnsSuccess) {
  DesktopLyricsPlugin plugin;
  bool succeeded = false;
  plugin.HandleMethodCall(
      MethodCall("show", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&succeeded](const EncodableValue* result) {
            succeeded = result == nullptr;
          },
          nullptr, nullptr));
  EXPECT_TRUE(succeeded);
}

TEST(DesktopLyricsPlugin, EnableWithoutLyricFrameReturnsSuccess) {
  DesktopLyricsPlugin plugin;
  bool succeeded = false;
  EncodableMap config;
  config[EncodableValue("enabled")] = EncodableValue(true);
  config[EncodableValue("clickThrough")] = EncodableValue(false);
  config[EncodableValue("fontSize")] = EncodableValue(32.0);
  plugin.HandleMethodCall(
      MethodCall("updateConfig", std::make_unique<EncodableValue>(config)),
      std::make_unique<MethodResultFunctions<>>(
          [&succeeded](const EncodableValue* result) {
            succeeded = result == nullptr;
          },
          nullptr, nullptr));
  EXPECT_TRUE(succeeded);
}

}  // namespace test
}  // namespace desktop_lyrics
