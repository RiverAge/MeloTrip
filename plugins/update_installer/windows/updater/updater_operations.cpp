#include "updater_shared.h"

namespace melo_trip_updater {

void Fail(UpdateContext* context, const std::wstring& message) {
  context->error_message = message;
  PostStage(context, UpdateStage::failed);
  PostMessage(context->window, kMessageFinished, 1, 0);
}

bool WaitForHostExit(DWORD process_id) {
  if (process_id == 0) {
    return true;
  }
  const DWORD access = SYNCHRONIZE;
  HANDLE process = OpenProcess(access, FALSE, process_id);
  if (process == nullptr) {
    return true;
  }

  for (;;) {
    const DWORD wait_result = WaitForSingleObject(process, 150);
    if (wait_result == WAIT_OBJECT_0) {
      CloseHandle(process);
      return true;
    }
    if (wait_result == WAIT_FAILED) {
      CloseHandle(process);
      return false;
    }
    PumpWindowMessages();
  }
}

bool ExtractArchive(const std::wstring& archive_path, const std::wstring& destination_path) {
  IShellDispatch* shell = nullptr;
  HRESULT hr = CoCreateInstance(
      CLSID_Shell,
      nullptr,
      CLSCTX_INPROC_SERVER,
      IID_PPV_ARGS(&shell));
  if (FAILED(hr) || shell == nullptr) {
    return false;
  }

  VARIANT source_variant;
  VariantInit(&source_variant);
  source_variant.vt = VT_BSTR;
  source_variant.bstrVal = SysAllocString(archive_path.c_str());

  Folder* source_folder = nullptr;
  hr = shell->NameSpace(source_variant, &source_folder);
  VariantClear(&source_variant);
  if (FAILED(hr) || source_folder == nullptr) {
    shell->Release();
    return false;
  }

  VARIANT destination_variant;
  VariantInit(&destination_variant);
  destination_variant.vt = VT_BSTR;
  destination_variant.bstrVal = SysAllocString(destination_path.c_str());

  Folder* destination_folder = nullptr;
  hr = shell->NameSpace(destination_variant, &destination_folder);
  VariantClear(&destination_variant);
  if (FAILED(hr) || destination_folder == nullptr) {
    source_folder->Release();
    shell->Release();
    return false;
  }

  FolderItems* items = nullptr;
  hr = source_folder->Items(&items);
  if (FAILED(hr) || items == nullptr) {
    destination_folder->Release();
    source_folder->Release();
    shell->Release();
    return false;
  }

  VARIANT items_variant;
  VariantInit(&items_variant);
  items_variant.vt = VT_DISPATCH;
  items_variant.pdispVal = items;

  VARIANT options_variant;
  VariantInit(&options_variant);
  options_variant.vt = VT_I4;
  options_variant.lVal = 16 + 1024;

  hr = destination_folder->CopyHere(items_variant, options_variant);
  VariantClear(&items_variant);

  items->Release();
  destination_folder->Release();
  source_folder->Release();
  shell->Release();
  if (FAILED(hr)) {
    return false;
  }

  for (int attempt = 0; attempt < 120; attempt += 1) {
    PumpWindowMessages();
    std::error_code error;
    const bool has_entries = std::filesystem::exists(destination_path, error) &&
        std::filesystem::directory_iterator(destination_path, error) !=
            std::filesystem::directory_iterator();
    if (!error && has_entries) {
      return true;
    }
    Sleep(250);
  }
  return false;
}

int CountFiles(const std::filesystem::path& source_dir) {
  int total = 0;
  for (const auto& entry : std::filesystem::recursive_directory_iterator(source_dir)) {
    if (entry.is_regular_file()) {
      total += 1;
    }
  }
  return total;
}

bool CopyBundle(
    const std::wstring& source_dir,
    const std::wstring& destination_dir,
    UpdateContext* context) {
  const auto total_files = CountFiles(source_dir);
  int copied_files = 0;

  for (const auto& entry : std::filesystem::recursive_directory_iterator(source_dir)) {
    PumpWindowMessages();
    const auto relative = std::filesystem::relative(entry.path(), source_dir);
    const auto target = std::filesystem::path(destination_dir) / relative;

    if (entry.is_directory()) {
      std::filesystem::create_directories(target);
      continue;
    }

    std::filesystem::create_directories(target.parent_path());
    std::filesystem::copy_file(
        entry.path(),
        target,
        std::filesystem::copy_options::overwrite_existing);

    copied_files += 1;
    if (total_files > 0) {
      const int percent = static_cast<int>((copied_files * 100.0) / total_files);
      PostProgress(context, percent);
    }
  }
  return true;
}

void Relaunch(const std::wstring& executable_path) {
  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::wstring command_line = L"\"" + executable_path + L"\"";
  std::vector<wchar_t> buffer(command_line.begin(), command_line.end());
  buffer.push_back(L'\0');

  if (CreateProcessW(
          nullptr,
          buffer.data(),
          nullptr,
          nullptr,
          FALSE,
          0,
          nullptr,
          nullptr,
          &startup_info,
          &process_info)) {
    CloseHandle(process_info.hThread);
    CloseHandle(process_info.hProcess);
  }
}

}  // namespace melo_trip_updater
