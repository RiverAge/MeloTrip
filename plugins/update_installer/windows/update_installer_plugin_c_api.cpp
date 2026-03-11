#include "include/update_installer/update_installer_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "update_installer_plugin.h"

void UpdateInstallerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  UpdateInstallerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}