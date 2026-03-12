#include "updater_shared.h"

namespace melo_trip_updater {
namespace {

std::optional<std::wstring> ReadFlagValue(
    const std::vector<std::wstring>& args,
    const std::wstring& flag) {
  for (size_t index = 0; index + 1 < args.size(); index += 1) {
    if (args[index] == flag) {
      return args[index + 1];
    }
  }
  return std::nullopt;
}

std::optional<UpdaterArguments> ParseArguments(
    const std::vector<std::wstring>& args) {
  const auto archive_path = ReadFlagValue(args, L"--archive");
  const auto install_dir = ReadFlagValue(args, L"--install-dir");
  const auto executable_path = ReadFlagValue(args, L"--executable");
  const auto process_id_value = ReadFlagValue(args, L"--pid");
  if (!archive_path.has_value() || !install_dir.has_value() ||
      !executable_path.has_value() || !process_id_value.has_value()) {
    return std::nullopt;
  }

  UpdaterArguments parsed;
  parsed.archive_path = *archive_path;
  parsed.install_dir = *install_dir;
  parsed.executable_path = *executable_path;
  parsed.process_id = static_cast<DWORD>(_wtoi(process_id_value->c_str()));
  return parsed;
}

}  // namespace

LocalizedStrings ParseLocalizedStrings(const std::vector<std::wstring>& args) {
  LocalizedStrings strings;

  const auto window_title = ReadFlagValue(args, L"--window-title");
  const auto preparing = ReadFlagValue(args, L"--preparing");
  const auto version_line = ReadFlagValue(args, L"--version-line");
  const auto waiting_for_app = ReadFlagValue(args, L"--waiting-for-app");
  const auto extracting_archive = ReadFlagValue(args, L"--extracting-archive");
  const auto copying_files = ReadFlagValue(args, L"--copying-files");
  const auto restarting_app = ReadFlagValue(args, L"--restarting-app");
  const auto failed = ReadFlagValue(args, L"--failed");
  const auto invalid_arguments = ReadFlagValue(args, L"--invalid-arguments");
  const auto init_failed = ReadFlagValue(args, L"--init-failed");
  const auto wait_failed = ReadFlagValue(args, L"--wait-failed");
  const auto temp_path_failed = ReadFlagValue(args, L"--temp-path-failed");
  const auto temp_dir_failed = ReadFlagValue(args, L"--temp-dir-failed");
  const auto extract_failed = ReadFlagValue(args, L"--extract-failed");
  const auto copy_failed = ReadFlagValue(args, L"--copy-failed");

  if (window_title.has_value()) strings.window_title = *window_title;
  if (preparing.has_value()) strings.preparing = *preparing;
  if (version_line.has_value()) strings.version_line = *version_line;
  if (waiting_for_app.has_value()) strings.waiting_for_app = *waiting_for_app;
  if (extracting_archive.has_value()) strings.extracting_archive = *extracting_archive;
  if (copying_files.has_value()) strings.copying_files = *copying_files;
  if (restarting_app.has_value()) strings.restarting_app = *restarting_app;
  if (failed.has_value()) strings.failed = *failed;
  if (invalid_arguments.has_value()) strings.invalid_arguments = *invalid_arguments;
  if (init_failed.has_value()) strings.init_failed = *init_failed;
  if (wait_failed.has_value()) strings.wait_failed = *wait_failed;
  if (temp_path_failed.has_value()) strings.temp_path_failed = *temp_path_failed;
  if (temp_dir_failed.has_value()) strings.temp_dir_failed = *temp_dir_failed;
  if (extract_failed.has_value()) strings.extract_failed = *extract_failed;
  if (copy_failed.has_value()) strings.copy_failed = *copy_failed;
  return strings;
}

}  // namespace melo_trip_updater

int WINAPI wWinMain(HINSTANCE instance, HINSTANCE, PWSTR, int show_command) {
  using namespace melo_trip_updater;

  SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
  int argc = 0;
  wchar_t** argv = CommandLineToArgvW(GetCommandLineW(), &argc);
  if (argv == nullptr) {
    MessageBoxW(
        nullptr,
        L"Updater arguments are invalid.",
        L"MeloTrip Updater",
        MB_OK | MB_ICONERROR);
    return 1;
  }
  std::vector<std::wstring> args(argv + 1, argv + argc);
  LocalFree(argv);

  const auto parsed_args = ParseArguments(args);
  const auto strings = ParseLocalizedStrings(args);
  if (!parsed_args.has_value()) {
    MessageBoxW(
        nullptr,
        strings.invalid_arguments.c_str(),
        strings.window_title.c_str(),
        MB_OK | MB_ICONERROR);
    return 1;
  }

  const HRESULT hr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
  if (FAILED(hr)) {
    MessageBoxW(
        nullptr,
        strings.init_failed.c_str(),
        strings.window_title.c_str(),
        MB_OK | MB_ICONERROR);
    return 3;
  }

  UpdateContext context;
  context.args = *parsed_args;
  context.strings = strings;
  if (!EnsureFactories(&context)) {
    MessageBoxW(
        nullptr,
        strings.init_failed.c_str(),
        strings.window_title.c_str(),
        MB_OK | MB_ICONERROR);
    CoUninitialize();
    return 2;
  }

  WNDCLASSW window_class = {};
  window_class.lpfnWndProc = WindowProc;
  window_class.hInstance = instance;
  window_class.lpszClassName = kWindowClassName;
  window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
  window_class.style = CS_HREDRAW | CS_VREDRAW | CS_DROPSHADOW;
  RegisterClassW(&window_class);

  const int window_width = ScaleDipToInt(&context, kWindowWidthDip);
  const int window_height = ScaleDipToInt(&context, kWindowHeightDip);
  HWND window = CreateWindowExW(
      WS_EX_TOOLWINDOW,
      kWindowClassName,
      context.strings.window_title.c_str(),
      WS_POPUP,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      window_width,
      window_height,
      nullptr,
      nullptr,
      instance,
      &context);
  if (window == nullptr) {
    CoUninitialize();
    return 4;
  }

  ShowWindow(window, show_command == 0 ? SW_SHOWNORMAL : show_command);
  UpdateWindow(window);

  HANDLE worker_thread = CreateThread(
      nullptr,
      0,
      [](LPVOID parameter) -> DWORD {
        RunUpdate(reinterpret_cast<UpdateContext*>(parameter));
        return 0;
      },
      &context,
      0,
      nullptr);

  MSG msg;
  while (GetMessage(&msg, nullptr, 0, 0)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }

  if (worker_thread != nullptr) {
    WaitForSingleObject(worker_thread, INFINITE);
    CloseHandle(worker_thread);
  }

  CoUninitialize();
  return 0;
}
