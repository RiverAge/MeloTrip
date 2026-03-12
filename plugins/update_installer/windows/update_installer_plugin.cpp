#include "update_installer_plugin.h"
#include "update_installer_plugin_internal.h"

#include <windows.h>

#include <flutter/standard_method_codec.h>

#include <filesystem>
#include <memory>
#include <string>
#include <vector>

void UpdateInstallerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(),
          "com.meme.melotrip/update",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<UpdateInstallerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

UpdateInstallerPlugin::UpdateInstallerPlugin() = default;

UpdateInstallerPlugin::~UpdateInstallerPlugin() = default;

void UpdateInstallerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  using update_installer_internal::BuildCommandLine;
  using update_installer_internal::CopyUpdaterToTemp;
  using update_installer_internal::ReadInt64;
  using update_installer_internal::ReadString;
  using update_installer_internal::ReadUpdaterStrings;
  using update_installer_internal::Utf8ToWide;

  if (method_call.method_name() != "launchBundledUpdater") {
    result->NotImplemented();
    return;
  }

  const auto* arguments =
      std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (arguments == nullptr) {
    result->Error("invalid_args", "Expected launch arguments");
    return;
  }

  const auto archive_path = ReadString(*arguments, "archivePath");
  const auto current_exe_path = ReadString(*arguments, "currentExePath");
  const auto current_process_id = ReadInt64(*arguments, "currentProcessId");
  const auto updater_strings = ReadUpdaterStrings(*arguments);
  if (!archive_path.has_value() || !current_exe_path.has_value() ||
      !current_process_id.has_value() || !updater_strings.has_value()) {
    result->Error("invalid_args", "Missing launch arguments");
    return;
  }

  std::string copy_error;
  const auto launcher_path =
      CopyUpdaterToTemp(Utf8ToWide(*current_exe_path), &copy_error);
  if (!launcher_path.has_value()) {
    result->Error("launch_failed", copy_error);
    return;
  }

  const std::filesystem::path install_dir =
      std::filesystem::path(Utf8ToWide(*current_exe_path)).parent_path();
  std::wstring command_line = BuildCommandLine(
      *launcher_path,
      Utf8ToWide(*archive_path),
      install_dir.wstring(),
      Utf8ToWide(*current_exe_path),
      *current_process_id,
      *updater_strings);

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::vector<wchar_t> buffer(command_line.begin(), command_line.end());
  buffer.push_back(L'\0');

  const BOOL launched = CreateProcessW(
      nullptr,
      buffer.data(),
      nullptr,
      nullptr,
      FALSE,
      DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP,
      nullptr,
      nullptr,
      &startup_info,
      &process_info);
  if (!launched) {
    result->Error("launch_failed", "Failed to start bundled updater");
    return;
  }

  CloseHandle(process_info.hThread);
  CloseHandle(process_info.hProcess);
  result->Success();
}
