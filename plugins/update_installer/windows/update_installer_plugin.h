#ifndef FLUTTER_PLUGIN_UPDATE_INSTALLER_PLUGIN_H_
#define FLUTTER_PLUGIN_UPDATE_INSTALLER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

class UpdateInstallerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  UpdateInstallerPlugin();
  ~UpdateInstallerPlugin() override;

  UpdateInstallerPlugin(const UpdateInstallerPlugin&) = delete;
  UpdateInstallerPlugin& operator=(const UpdateInstallerPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

#endif  // FLUTTER_PLUGIN_UPDATE_INSTALLER_PLUGIN_H_