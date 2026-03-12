#ifndef FLUTTER_PLUGIN_UPDATE_INSTALLER_INTERNAL_H_
#define FLUTTER_PLUGIN_UPDATE_INSTALLER_INTERNAL_H_

#include <flutter/standard_method_codec.h>

#include <optional>
#include <string>

namespace update_installer_internal {

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
    const char* key);
std::optional<int64_t> ReadInt64(
    const flutter::EncodableMap& map,
    const char* key);
std::wstring Utf8ToWide(const std::string& input);
std::optional<WindowsUpdaterStrings> ReadUpdaterStrings(
    const flutter::EncodableMap& map);
std::wstring BuildCommandLine(
    const std::wstring& executable_path,
    const std::wstring& archive_path,
    const std::wstring& install_dir,
    const std::wstring& current_exe_path,
    int64_t process_id,
    const WindowsUpdaterStrings& updater_strings);
std::optional<std::wstring> CopyUpdaterToTemp(
    const std::wstring& current_exe_path,
    std::string* error);

}  // namespace update_installer_internal

#endif  // FLUTTER_PLUGIN_UPDATE_INSTALLER_INTERNAL_H_
