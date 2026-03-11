#include "update_installer_plugin.h"

#include <windows.h>

#include <flutter/standard_method_codec.h>

#include <filesystem>
#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace {

struct WindowsUpdaterStrings {
  std::wstring window_title;
  std::wstring preparing;
  std::wstring version_line;
  std::wstring waiting_for_app;
  std::wstring extracting_archive;
  std::wstring copying_files;
  std::wstring restarting_app;
  std::wstring failed;
  std::wstring invalid_arguments;
  std::wstring init_failed;
  std::wstring wait_failed;
  std::wstring temp_path_failed;
  std::wstring temp_dir_failed;
  std::wstring extract_failed;
  std::wstring copy_failed;
};

std::optional<std::string> ReadString(
    const flutter::EncodableMap& map,
    const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  const auto value = std::get_if<std::string>(&it->second);
  if (value == nullptr || value->empty()) {
    return std::nullopt;
  }
  return *value;
}

std::optional<int64_t> ReadInt64(
    const flutter::EncodableMap& map,
    const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  if (const auto value = std::get_if<int64_t>(&it->second)) {
    return *value;
  }
  if (const auto value = std::get_if<int32_t>(&it->second)) {
    return static_cast<int64_t>(*value);
  }
  return std::nullopt;
}

std::wstring Utf8ToWide(const std::string& input) {
  if (input.empty()) {
    return L"";
  }
  const int size_needed = MultiByteToWideChar(
      CP_UTF8, 0, input.c_str(), -1, nullptr, 0);
  if (size_needed <= 0) {
    return L"";
  }
  std::wstring output(static_cast<size_t>(size_needed), L'\0');
  MultiByteToWideChar(
      CP_UTF8, 0, input.c_str(), -1, output.data(), size_needed);
  if (!output.empty() && output.back() == L'\0') {
    output.pop_back();
  }
  return output;
}

void AppendArg(
    std::wstring* command_line,
    const wchar_t* key,
    const std::wstring& value) {
  *command_line += L" ";
  *command_line += key;
  *command_line += L" \"";
  *command_line += value;
  *command_line += L"\"";
}

std::optional<WindowsUpdaterStrings> ReadUpdaterStrings(
    const flutter::EncodableMap& map) {
  const auto it = map.find(flutter::EncodableValue("updaterStrings"));
  if (it == map.end()) {
    return std::nullopt;
  }
  const auto value = std::get_if<flutter::EncodableMap>(&it->second);
  if (value == nullptr) {
    return std::nullopt;
  }

  const auto window_title = ReadString(*value, "windowTitle");
  const auto preparing = ReadString(*value, "preparing");
  const auto version_line = ReadString(*value, "versionLine");
  const auto waiting_for_app = ReadString(*value, "waitingForApp");
  const auto extracting_archive = ReadString(*value, "extractingArchive");
  const auto copying_files = ReadString(*value, "copyingFiles");
  const auto restarting_app = ReadString(*value, "restartingApp");
  const auto failed = ReadString(*value, "failed");
  const auto invalid_arguments = ReadString(*value, "invalidArguments");
  const auto init_failed = ReadString(*value, "initFailed");
  const auto wait_failed = ReadString(*value, "waitFailed");
  const auto temp_path_failed = ReadString(*value, "tempPathFailed");
  const auto temp_dir_failed = ReadString(*value, "tempDirFailed");
  const auto extract_failed = ReadString(*value, "extractFailed");
  const auto copy_failed = ReadString(*value, "copyFailed");
  if (!window_title.has_value() || !preparing.has_value() ||
      !version_line.has_value() || !waiting_for_app.has_value() ||
      !extracting_archive.has_value() || !copying_files.has_value() ||
      !restarting_app.has_value() || !failed.has_value() ||
      !invalid_arguments.has_value() || !init_failed.has_value() ||
      !wait_failed.has_value() || !temp_path_failed.has_value() ||
      !temp_dir_failed.has_value() || !extract_failed.has_value() ||
      !copy_failed.has_value()) {
    return std::nullopt;
  }

  return WindowsUpdaterStrings{
      Utf8ToWide(*window_title),
      Utf8ToWide(*preparing),
      Utf8ToWide(*version_line),
      Utf8ToWide(*waiting_for_app),
      Utf8ToWide(*extracting_archive),
      Utf8ToWide(*copying_files),
      Utf8ToWide(*restarting_app),
      Utf8ToWide(*failed),
      Utf8ToWide(*invalid_arguments),
      Utf8ToWide(*init_failed),
      Utf8ToWide(*wait_failed),
      Utf8ToWide(*temp_path_failed),
      Utf8ToWide(*temp_dir_failed),
      Utf8ToWide(*extract_failed),
      Utf8ToWide(*copy_failed),
  };
}

std::wstring BuildCommandLine(
    const std::wstring& executable_path,
    const std::wstring& archive_path,
    const std::wstring& install_dir,
    const std::wstring& current_exe_path,
    int64_t process_id,
    const WindowsUpdaterStrings& updater_strings) {
  std::wstring command_line = L"\"" + executable_path + L"\"";
  AppendArg(&command_line, L"--archive", archive_path);
  AppendArg(&command_line, L"--install-dir", install_dir);
  AppendArg(&command_line, L"--executable", current_exe_path);
  command_line += L" --pid ";
  command_line += std::to_wstring(process_id);
  AppendArg(&command_line, L"--window-title", updater_strings.window_title);
  AppendArg(&command_line, L"--preparing", updater_strings.preparing);
  AppendArg(&command_line, L"--version-line", updater_strings.version_line);
  AppendArg(&command_line, L"--waiting-for-app", updater_strings.waiting_for_app);
  AppendArg(&command_line, L"--extracting-archive", updater_strings.extracting_archive);
  AppendArg(&command_line, L"--copying-files", updater_strings.copying_files);
  AppendArg(&command_line, L"--restarting-app", updater_strings.restarting_app);
  AppendArg(&command_line, L"--failed", updater_strings.failed);
  AppendArg(&command_line, L"--invalid-arguments", updater_strings.invalid_arguments);
  AppendArg(&command_line, L"--init-failed", updater_strings.init_failed);
  AppendArg(&command_line, L"--wait-failed", updater_strings.wait_failed);
  AppendArg(&command_line, L"--temp-path-failed", updater_strings.temp_path_failed);
  AppendArg(&command_line, L"--temp-dir-failed", updater_strings.temp_dir_failed);
  AppendArg(&command_line, L"--extract-failed", updater_strings.extract_failed);
  AppendArg(&command_line, L"--copy-failed", updater_strings.copy_failed);
  return command_line;
}

std::optional<std::wstring> CopyUpdaterToTemp(
    const std::wstring& current_exe_path,
    std::string* error) {
  const std::filesystem::path source =
      std::filesystem::path(current_exe_path).parent_path() / L"MeloTripUpdater.exe";
  if (!std::filesystem::exists(source)) {
    *error = "Bundled updater executable is missing";
    return std::nullopt;
  }

  wchar_t temp_path[MAX_PATH];
  if (GetTempPathW(MAX_PATH, temp_path) == 0) {
    *error = "Failed to resolve temp path";
    return std::nullopt;
  }

  wchar_t temp_name[MAX_PATH];
  if (GetTempFileNameW(temp_path, L"mlu", 0, temp_name) == 0) {
    *error = "Failed to allocate temp directory";
    return std::nullopt;
  }

  DeleteFileW(temp_name);
  if (!CreateDirectoryW(temp_name, nullptr)) {
    *error = "Failed to create temp directory";
    return std::nullopt;
  }

  const std::filesystem::path destination =
      std::filesystem::path(temp_name) / L"MeloTripUpdater.exe";
  try {
    std::filesystem::copy_file(
        source,
        destination,
        std::filesystem::copy_options::overwrite_existing);
  } catch (...) {
    *error = "Failed to copy updater executable";
    return std::nullopt;
  }
  return destination.wstring();
}

}  // namespace

void UpdateInstallerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "com.meme.melotrip/update",
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
  if (method_call.method_name() != "launchBundledUpdater") {
    result->NotImplemented();
    return;
  }

  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
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
