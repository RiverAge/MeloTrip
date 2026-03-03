#ifndef FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_
#define FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

#include "desktop_lyrics_overlay.h"

namespace desktop_lyrics {

class DesktopLyricsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DesktopLyricsPlugin();

  virtual ~DesktopLyricsPlugin();

  // Disallow copy and assign.
  DesktopLyricsPlugin(const DesktopLyricsPlugin&) = delete;
  DesktopLyricsPlugin& operator=(const DesktopLyricsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  std::unique_ptr<DesktopLyricsOverlay> overlay_;
};

}  // namespace desktop_lyrics

#endif  // FLUTTER_PLUGIN_DESKTOP_LYRICS_PLUGIN_H_
