#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>

#include <d2d1.h>
#include <dwrite.h>
#include <dwmapi.h>
#include <exdisp.h>
#include <shellapi.h>
#include <shlobj.h>
#include <wrl/client.h>

#include <algorithm>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

#pragma comment(lib, "d2d1.lib")
#pragma comment(lib, "dwrite.lib")
#pragma comment(lib, "dwmapi.lib")

namespace {

using Microsoft::WRL::ComPtr;

constexpr UINT kMessageStage = WM_APP + 1;
constexpr UINT kMessageProgress = WM_APP + 2;
constexpr UINT kMessageFinished = WM_APP + 3;

constexpr wchar_t kWindowClassName[] = L"MeloTripUpdaterWindow";
constexpr float kWindowWidthDip = 440.0f;
constexpr float kWindowHeightDip = 200.0f;
constexpr float kWindowCornerRadiusDip = 16.0f;
constexpr float kContentPaddingDip = 32.0f;
constexpr float kTitleTopDip = 48.0f;
constexpr float kTitleBottomGapDip = 12.0f;
constexpr float kVersionProgressGapDip = 20.0f;
constexpr float kProgressBottomInsetDip = 44.0f;
constexpr float kProgressHeightDip = 10.0f;
constexpr float kProgressMarqueeWidthFactor = 0.40f;
constexpr float kProgressWidthFactor = 0.80f;
constexpr DWORD kHostExitForceKillDelayMs = 2500;

constexpr D2D1_COLOR_F kWindowBackgroundColor = {0.11f, 0.11f, 0.12f, 1.0f};
constexpr D2D1_COLOR_F kSurfaceColor = {0.15f, 0.15f, 0.16f, 1.0f};
constexpr D2D1_COLOR_F kTrackColor = {0.25f, 0.25f, 0.27f, 1.0f};
constexpr D2D1_COLOR_F kProgressColor = {0.98f, 0.20f, 0.35f, 1.0f};
constexpr D2D1_COLOR_F kTitleColor = {0.96f, 0.96f, 0.96f, 1.0f};
constexpr D2D1_COLOR_F kMetaColor = {0.60f, 0.60f, 0.62f, 1.0f};

struct UpdaterArguments {
  std::wstring archive_path;
  std::wstring install_dir;
  std::wstring executable_path;
  DWORD process_id = 0;
};

enum class UpdateStage {
  waitingForApp = 0,
  extractingArchive = 1,
  copyingFiles = 2,
  restartingApp = 3,
  failed = 4,
};

struct LocalizedStrings {
  std::wstring window_title = L"MeloTrip Updater";
  std::wstring preparing = L"Preparing update...";
  std::wstring version_line = L"Version";
  std::wstring waiting_for_app = L"Waiting for MeloTrip to close...";
  std::wstring extracting_archive = L"Extracting update package...";
  std::wstring copying_files = L"Installing update...";
  std::wstring restarting_app = L"Restarting MeloTrip...";
  std::wstring failed = L"Update failed";
  std::wstring invalid_arguments = L"Updater arguments are invalid.";
  std::wstring init_failed =
      L"Failed to initialize Windows components for the updater.";
  std::wstring wait_failed = L"Failed to wait for MeloTrip to exit.";
  std::wstring temp_path_failed = L"Failed to resolve a temporary directory.";
  std::wstring temp_dir_failed = L"Failed to create the staging directory.";
  std::wstring extract_failed = L"Failed to extract the update package.";
  std::wstring copy_failed = L"Failed to install the update files.";
};

struct UpdateContext {
  HWND window = nullptr;
  HRGN clip_region = nullptr;
  UpdaterArguments args;
  std::wstring error_message;
  LocalizedStrings strings;
  UpdateStage stage = UpdateStage::waitingForApp;
  int progress_percent = 0;
  bool progress_marquee = true;
  int marquee_offset = 0;
  UINT dpi = USER_DEFAULT_SCREEN_DPI;

  ComPtr<ID2D1Factory> d2d_factory;
  ComPtr<IDWriteFactory> dwrite_factory;
  ComPtr<ID2D1DCRenderTarget> render_target;
  ComPtr<IDWriteTextFormat> title_text_format;
  ComPtr<IDWriteTextFormat> meta_text_format;
  ComPtr<ID2D1SolidColorBrush> background_brush;
  ComPtr<ID2D1SolidColorBrush> surface_brush;
  ComPtr<ID2D1SolidColorBrush> track_brush;
  ComPtr<ID2D1SolidColorBrush> progress_brush;
  ComPtr<ID2D1SolidColorBrush> title_brush;
  ComPtr<ID2D1SolidColorBrush> meta_brush;
};

void PostStage(UpdateContext* context, UpdateStage stage);
void PostProgress(UpdateContext* context, int percent);

float ScaleDip(const UpdateContext* context, float dip) {
  const UINT dpi = context != nullptr ? context->dpi : USER_DEFAULT_SCREEN_DPI;
  return dip * static_cast<float>(dpi) / static_cast<float>(USER_DEFAULT_SCREEN_DPI);
}

int ScaleDipToInt(const UpdateContext* context, float dip) {
  return static_cast<int>(std::lround(ScaleDip(context, dip)));
}

D2D1_ROUNDED_RECT ToRoundedRect(const D2D1_RECT_F& rect, float radius) {
  return D2D1::RoundedRect(rect, radius, radius);
}

bool EnsureFactories(UpdateContext* context) {
  if (context->d2d_factory == nullptr) {
    if (FAILED(D2D1CreateFactory(
            D2D1_FACTORY_TYPE_SINGLE_THREADED,
            context->d2d_factory.ReleaseAndGetAddressOf()))) {
      return false;
    }
  }
  if (context->dwrite_factory == nullptr) {
    if (FAILED(DWriteCreateFactory(
            DWRITE_FACTORY_TYPE_SHARED,
            __uuidof(IDWriteFactory),
            reinterpret_cast<IUnknown**>(
                context->dwrite_factory.ReleaseAndGetAddressOf())))) {
      return false;
    }
  }
  return true;
}

bool EnsureTextFormats(UpdateContext* context) {
  if (!EnsureFactories(context)) {
    return false;
  }

  const FLOAT title_font_size = 16.0f;
  const FLOAT meta_font_size = 12.0f;

  if (context->title_text_format == nullptr) {
    if (FAILED(context->dwrite_factory->CreateTextFormat(
            L"Segoe UI",
            nullptr,
            DWRITE_FONT_WEIGHT_SEMI_BOLD,
            DWRITE_FONT_STYLE_NORMAL,
            DWRITE_FONT_STRETCH_NORMAL,
            title_font_size,
            L"",
            context->title_text_format.ReleaseAndGetAddressOf()))) {
      return false;
    }
    context->title_text_format->SetWordWrapping(DWRITE_WORD_WRAPPING_WRAP);
    context->title_text_format->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_CENTER);
    context->title_text_format->SetParagraphAlignment(
        DWRITE_PARAGRAPH_ALIGNMENT_NEAR);
  }

  if (context->meta_text_format == nullptr) {
    if (FAILED(context->dwrite_factory->CreateTextFormat(
            L"Segoe UI",
            nullptr,
            DWRITE_FONT_WEIGHT_NORMAL,
            DWRITE_FONT_STYLE_NORMAL,
            DWRITE_FONT_STRETCH_NORMAL,
            meta_font_size,
            L"",
            context->meta_text_format.ReleaseAndGetAddressOf()))) {
      return false;
    }
    context->meta_text_format->SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);
    context->meta_text_format->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_CENTER);
    context->meta_text_format->SetParagraphAlignment(
        DWRITE_PARAGRAPH_ALIGNMENT_NEAR);
  }

  return true;
}

void ResetTextFormats(UpdateContext* context) {
  context->title_text_format.Reset();
  context->meta_text_format.Reset();
}

bool EnsureRenderTarget(UpdateContext* context) {
  if (context->render_target != nullptr) {
    return true;
  }
  if (!EnsureFactories(context)) {
    return false;
  }

  const D2D1_RENDER_TARGET_PROPERTIES properties = D2D1::RenderTargetProperties(
      D2D1_RENDER_TARGET_TYPE_DEFAULT,
      D2D1::PixelFormat(DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_IGNORE),
      static_cast<FLOAT>(context->dpi),
      static_cast<FLOAT>(context->dpi));
  if (FAILED(context->d2d_factory->CreateDCRenderTarget(
          &properties, context->render_target.ReleaseAndGetAddressOf()))) {
    return false;
  }
  context->render_target->SetAntialiasMode(D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
  context->render_target->SetTextAntialiasMode(D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE);

  if (FAILED(context->render_target->CreateSolidColorBrush(
          kWindowBackgroundColor, context->background_brush.ReleaseAndGetAddressOf())) ||
      FAILED(context->render_target->CreateSolidColorBrush(
          kSurfaceColor, context->surface_brush.ReleaseAndGetAddressOf())) ||
      FAILED(context->render_target->CreateSolidColorBrush(
          kTrackColor, context->track_brush.ReleaseAndGetAddressOf())) ||
      FAILED(context->render_target->CreateSolidColorBrush(
          kProgressColor, context->progress_brush.ReleaseAndGetAddressOf())) ||
      FAILED(context->render_target->CreateSolidColorBrush(
          kTitleColor, context->title_brush.ReleaseAndGetAddressOf())) ||
      FAILED(context->render_target->CreateSolidColorBrush(
          kMetaColor, context->meta_brush.ReleaseAndGetAddressOf()))) {
    return false;
  }

  return true;
}

void ReleaseRenderResources(UpdateContext* context) {
  context->render_target.Reset();
  context->background_brush.Reset();
  context->surface_brush.Reset();
  context->track_brush.Reset();
  context->progress_brush.Reset();
  context->title_brush.Reset();
  context->meta_brush.Reset();
}

void UpdateWindowRegion(UpdateContext* context) {}

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

void PumpWindowMessages() {
  MSG msg;
  while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
}

void SleepWithMessagePump(DWORD duration_ms) {
  const DWORD start_tick = GetTickCount();
  for (;;) {
    PumpWindowMessages();
    const DWORD elapsed = GetTickCount() - start_tick;
    if (elapsed >= duration_ms) {
      return;
    }
    const DWORD remaining = duration_ms - elapsed;
    Sleep(remaining > 50 ? 50 : remaining);
  }
}

const wchar_t* StageText(const UpdateContext* context, UpdateStage stage) {
  switch (stage) {
    case UpdateStage::waitingForApp:
      return context->strings.waiting_for_app.c_str();
    case UpdateStage::extractingArchive:
      return context->strings.extracting_archive.c_str();
    case UpdateStage::copyingFiles:
      return context->strings.copying_files.c_str();
    case UpdateStage::restartingApp:
      return context->strings.restarting_app.c_str();
    case UpdateStage::failed:
      return context->strings.failed.c_str();
  }
  return context->strings.copying_files.c_str();
}

void DrawProgressBar(UpdateContext* context, const D2D1_RECT_F& track_rect) {
  const float radius = track_rect.bottom - track_rect.top;
  const D2D1_ROUNDED_RECT rounded_track = ToRoundedRect(track_rect, radius / 2.0f);
  context->render_target->FillRoundedRectangle(&rounded_track, context->track_brush.Get());

  D2D1_RECT_F fill_rect = track_rect;
  if (context->progress_marquee) {
    const float chunk_width =
        (track_rect.right - track_rect.left) * kProgressMarqueeWidthFactor;
    const float track_width = track_rect.right - track_rect.left;
    const float travel = track_width + chunk_width;
    const float offset = static_cast<float>(context->marquee_offset) / 1000.0f * travel;
    fill_rect.left = track_rect.left + offset - chunk_width;
    fill_rect.right = fill_rect.left + chunk_width;
    if (fill_rect.left < track_rect.left) {
      fill_rect.left = track_rect.left;
    }
    if (fill_rect.right > track_rect.right) {
      fill_rect.right = track_rect.right;
    }
  } else {
    fill_rect.right = track_rect.left +
        (track_rect.right - track_rect.left) * static_cast<float>(context->progress_percent) /
            100.0f;
  }

  if (fill_rect.right <= fill_rect.left) {
    return;
  }

  const D2D1_ROUNDED_RECT rounded_fill = ToRoundedRect(fill_rect, radius / 2.0f);
  context->render_target->FillRoundedRectangle(&rounded_fill, context->progress_brush.Get());
}

float MeasureTextHeight(
    UpdateContext* context,
    const std::wstring& text,
    IDWriteTextFormat* text_format,
    float max_width) {
  if (text.empty() || text_format == nullptr || context->dwrite_factory == nullptr) {
    return 0.0f;
  }

  ComPtr<IDWriteTextLayout> text_layout;
  if (FAILED(context->dwrite_factory->CreateTextLayout(
          text.c_str(),
          static_cast<UINT32>(text.size()),
          text_format,
          max_width,
          200.0f,
          text_layout.ReleaseAndGetAddressOf()))) {
    return 0.0f;
  }

  DWRITE_TEXT_METRICS metrics = {};
  if (FAILED(text_layout->GetMetrics(&metrics))) {
    return 0.0f;
  }
  return metrics.height;
}

void DrawWindowContent(UpdateContext* context, HDC device_context) {
  if (context == nullptr || device_context == nullptr) {
    return;
  }
  RECT client_rect = {};
  GetClientRect(context->window, &client_rect);
  if (!EnsureTextFormats(context) || !EnsureRenderTarget(context)) {
    FillRect(device_context, &client_rect, reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1));
    return;
  }

  if (FAILED(context->render_target->BindDC(device_context, &client_rect))) {
    return;
  }

  context->render_target->BeginDraw();
  context->render_target->Clear(kSurfaceColor);

  const float scale = static_cast<float>(context->dpi) / 96.0f;
  const float width = static_cast<float>(client_rect.right - client_rect.left) / scale;
  const float height = static_cast<float>(client_rect.bottom - client_rect.top) / scale;
  
  const D2D1_RECT_F window_rect = D2D1::RectF(0.0f, 0.0f, width, height);
  
  // Optionally give the very edge a subtle darker border
  const D2D1_RECT_F border_rect = D2D1::RectF(0.5f, 0.5f, width - 0.5f, height - 0.5f);
  context->render_target->DrawRectangle(&border_rect, context->background_brush.Get(), 1.0f);

  const float padding = kContentPaddingDip;
  const float content_left = window_rect.left + padding;
  const float content_right = window_rect.right - padding;
  const float available_text_width = content_right - content_left;

  const float title_y = window_rect.top + kTitleTopDip;
  const float title_height = 48.0f;
  
  const float version_y = window_rect.top + 102.0f;
  const float version_height = 24.0f;

  const float progress_bottom_inset = kProgressBottomInsetDip;
  const float progress_height = kProgressHeightDip;
  const float progress_y = window_rect.bottom - progress_bottom_inset - progress_height;

  const float progress_width = available_text_width * kProgressWidthFactor;
  const float progress_left = content_left + (available_text_width - progress_width) / 2.0f;
  const float progress_right = progress_left + progress_width;

  const D2D1_RECT_F title_rect = D2D1::RectF(
      content_left,
      title_y,
      content_right,
      title_y + title_height);
  const D2D1_RECT_F version_rect = D2D1::RectF(
      content_left,
      version_y,
      content_right,
      version_y + version_height);
  const D2D1_RECT_F progress_rect = D2D1::RectF(
      progress_left,
      progress_y,
      progress_right,
      progress_y + progress_height);

  context->render_target->DrawTextW(
      StageText(context, context->stage),
      static_cast<UINT32>(wcslen(StageText(context, context->stage))),
      context->title_text_format.Get(),
      title_rect,
      context->title_brush.Get(),
      D2D1_DRAW_TEXT_OPTIONS_CLIP);

  context->render_target->DrawTextW(
      context->strings.version_line.c_str(),
      static_cast<UINT32>(context->strings.version_line.size()),
      context->meta_text_format.Get(),
      version_rect,
      context->meta_brush.Get(),
      D2D1_DRAW_TEXT_OPTIONS_CLIP);

  DrawProgressBar(context, progress_rect);

  const HRESULT end_draw = context->render_target->EndDraw();
  if (end_draw == D2DERR_RECREATE_TARGET) {
    ReleaseRenderResources(context);
  }
}

void ConfigureWindowAppearance(HWND window) {
#ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#define DWMWA_WINDOW_CORNER_PREFERENCE 33
#endif
#ifndef DWMWCP_ROUND
#define DWMWCP_ROUND 2
#endif
  const DWORD corner_preference = DWMWCP_ROUND;
  DwmSetWindowAttribute(
      window,
      DWMWA_WINDOW_CORNER_PREFERENCE,
      &corner_preference,
      sizeof(corner_preference));
}

void PostStage(UpdateContext* context, UpdateStage stage) {
  PostMessage(context->window, kMessageStage, static_cast<WPARAM>(stage), 0);
}

void PostProgress(UpdateContext* context, int percent) {
  PostMessage(context->window, kMessageProgress, static_cast<WPARAM>(percent), 0);
}

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

  DWORD waited_ms = 0;
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
    waited_ms += 150;
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

LRESULT CALLBACK WindowProc(HWND window, UINT message, WPARAM w_param, LPARAM l_param) {
  auto* context = reinterpret_cast<UpdateContext*>(GetWindowLongPtr(window, GWLP_USERDATA));

  switch (message) {
    case WM_NCCREATE: {
      const auto* create_struct = reinterpret_cast<CREATESTRUCT*>(l_param);
      SetWindowLongPtr(
          window,
          GWLP_USERDATA,
          reinterpret_cast<LONG_PTR>(create_struct->lpCreateParams));
      return TRUE;
    }
    case WM_CREATE: {
      context = reinterpret_cast<UpdateContext*>(
          reinterpret_cast<CREATESTRUCT*>(l_param)->lpCreateParams);
      context->window = window;
      context->dpi = GetDpiForWindow(window);

      SetWindowPos(
          window,
          nullptr,
          0,
          0,
          ScaleDipToInt(context, kWindowWidthDip),
          ScaleDipToInt(context, kWindowHeightDip),
          SWP_NOMOVE | SWP_NOACTIVATE | SWP_NOZORDER);

      ConfigureWindowAppearance(window);
      UpdateWindowRegion(context);
      SetTimer(window, 1, 16, nullptr);
      return 0;
    }
    case WM_ERASEBKGND:
      return TRUE;
    case WM_TIMER:
      if (context != nullptr && context->progress_marquee) {
        context->marquee_offset = (context->marquee_offset + 18) % 1000;
        InvalidateRect(window, nullptr, FALSE);
      }
      return 0;
    case WM_PAINT: {
      PAINTSTRUCT paint_struct = {};
      HDC device_context = BeginPaint(window, &paint_struct);
      DrawWindowContent(context, device_context);
      EndPaint(window, &paint_struct);
      return 0;
    }
    case WM_DPICHANGED: {
      if (context != nullptr) {
        context->dpi = HIWORD(w_param);
        ReleaseRenderResources(context);
        ResetTextFormats(context);
      }
      const RECT* suggested_rect = reinterpret_cast<RECT*>(l_param);
      if (suggested_rect != nullptr) {
        SetWindowPos(
            window,
            nullptr,
            suggested_rect->left,
            suggested_rect->top,
            suggested_rect->right - suggested_rect->left,
            suggested_rect->bottom - suggested_rect->top,
            SWP_NOACTIVATE | SWP_NOZORDER);
      }
      UpdateWindowRegion(context);
      InvalidateRect(window, nullptr, FALSE);
      return 0;
    }
    case WM_SHOWWINDOW: {
      if (w_param != FALSE) {
        RECT window_rect = {};
        GetWindowRect(window, &window_rect);
        const int width = window_rect.right - window_rect.left;
        const int height = window_rect.bottom - window_rect.top;
        const int screen_width = GetSystemMetrics(SM_CXSCREEN);
        const int screen_height = GetSystemMetrics(SM_CYSCREEN);
        SetWindowPos(
            window,
            HWND_TOPMOST,
            (screen_width - width) / 2,
            (screen_height - height) / 2,
            0,
            0,
            SWP_NOSIZE | SWP_SHOWWINDOW);
      }
      return 0;
    }
    case kMessageStage: {
      if (context == nullptr) {
        return 0;
      }
      context->stage = static_cast<UpdateStage>(w_param);
      context->progress_marquee =
          context->stage == UpdateStage::waitingForApp ||
          context->stage == UpdateStage::extractingArchive ||
          context->stage == UpdateStage::restartingApp;
      if (!context->progress_marquee) {
        context->progress_percent = 0;
      }
      InvalidateRect(window, nullptr, FALSE);
      return 0;
    }
    case kMessageProgress: {
      if (context != nullptr) {
        context->progress_percent = static_cast<int>(w_param);
        context->progress_marquee = false;
        InvalidateRect(window, nullptr, FALSE);
      }
      return 0;
    }
    case kMessageFinished: {
      if (w_param != 0 && context != nullptr) {
        MessageBoxW(
            window,
            context->error_message.c_str(),
            context->strings.window_title.c_str(),
            MB_OK | MB_ICONERROR);
      }
      DestroyWindow(window);
      return 0;
    }
    case WM_NCHITTEST:
      return HTCAPTION;
    case WM_CLOSE:
      return 0;
    case WM_DESTROY:
      if (context != nullptr) {
        KillTimer(window, 1);
        if (context->clip_region != nullptr) {
          DeleteObject(context->clip_region);
          context->clip_region = nullptr;
        }
        ResetTextFormats(context);
        ReleaseRenderResources(context);
      }
      PostQuitMessage(0);
      return 0;
  }

  return DefWindowProc(window, message, w_param, l_param);
}

void RunUpdate(UpdateContext* context) {
  PostStage(context, UpdateStage::waitingForApp);
  if (!WaitForHostExit(context->args.process_id)) {
    Fail(context, context->strings.wait_failed);
    return;
  }

  wchar_t temp_path[MAX_PATH];
  if (GetTempPathW(MAX_PATH, temp_path) == 0) {
    Fail(context, context->strings.temp_path_failed);
    return;
  }

  wchar_t temp_name[MAX_PATH];
  if (GetTempFileNameW(temp_path, L"mlu", 0, temp_name) == 0) {
    Fail(context, context->strings.temp_dir_failed);
    return;
  }

  DeleteFileW(temp_name);
  if (!CreateDirectoryW(temp_name, nullptr)) {
    Fail(context, context->strings.temp_dir_failed);
    return;
  }

  const std::wstring staging_dir = temp_name;
  PostStage(context, UpdateStage::extractingArchive);
  if (!ExtractArchive(context->args.archive_path, staging_dir)) {
    Fail(context, context->strings.extract_failed);
    return;
  }

  try {
    PostStage(context, UpdateStage::copyingFiles);
    if (!CopyBundle(staging_dir, context->args.install_dir, context)) {
      Fail(context, context->strings.copy_failed);
      return;
    }
  } catch (...) {
    Fail(context, context->strings.copy_failed);
    return;
  }
  PostStage(context, UpdateStage::restartingApp);
  Relaunch(context->args.executable_path);
  PostMessage(context->window, kMessageFinished, 0, 0);
}

}  // namespace

int WINAPI wWinMain(HINSTANCE instance, HINSTANCE, PWSTR, int show_command) {
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