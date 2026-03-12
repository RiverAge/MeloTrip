#ifndef MELOTRIP_UPDATER_SHARED_H_
#define MELOTRIP_UPDATER_SHARED_H_

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

#include <filesystem>
#include <optional>
#include <string>
#include <vector>

#pragma comment(lib, "d2d1.lib")
#pragma comment(lib, "dwrite.lib")
#pragma comment(lib, "dwmapi.lib")

namespace melo_trip_updater {

using Microsoft::WRL::ComPtr;

inline constexpr UINT kMessageStage = WM_APP + 1;
inline constexpr UINT kMessageProgress = WM_APP + 2;
inline constexpr UINT kMessageFinished = WM_APP + 3;

inline constexpr wchar_t kWindowClassName[] = L"MeloTripUpdaterWindow";
inline constexpr float kWindowWidthDip = 440.0f;
inline constexpr float kWindowHeightDip = 200.0f;
inline constexpr float kWindowCornerRadiusDip = 16.0f;
inline constexpr float kContentPaddingDip = 32.0f;
inline constexpr float kTitleTopDip = 48.0f;
inline constexpr float kTitleBottomGapDip = 12.0f;
inline constexpr float kVersionProgressGapDip = 20.0f;
inline constexpr float kProgressBottomInsetDip = 44.0f;
inline constexpr float kProgressHeightDip = 10.0f;
inline constexpr float kProgressMarqueeWidthFactor = 0.40f;
inline constexpr float kProgressWidthFactor = 0.80f;
inline constexpr DWORD kHostExitForceKillDelayMs = 2500;

inline constexpr D2D1_COLOR_F kWindowBackgroundColor = {0.11f, 0.11f, 0.12f, 1.0f};
inline constexpr D2D1_COLOR_F kSurfaceColor = {0.15f, 0.15f, 0.16f, 1.0f};
inline constexpr D2D1_COLOR_F kTrackColor = {0.25f, 0.25f, 0.27f, 1.0f};
inline constexpr D2D1_COLOR_F kProgressColor = {0.98f, 0.20f, 0.35f, 1.0f};
inline constexpr D2D1_COLOR_F kTitleColor = {0.96f, 0.96f, 0.96f, 1.0f};
inline constexpr D2D1_COLOR_F kMetaColor = {0.60f, 0.60f, 0.62f, 1.0f};

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

float ScaleDip(const UpdateContext* context, float dip);
int ScaleDipToInt(const UpdateContext* context, float dip);
bool EnsureFactories(UpdateContext* context);
bool EnsureTextFormats(UpdateContext* context);
void ResetTextFormats(UpdateContext* context);
bool EnsureRenderTarget(UpdateContext* context);
void ReleaseRenderResources(UpdateContext* context);
void UpdateWindowRegion(UpdateContext* context);
void PumpWindowMessages();
void SleepWithMessagePump(DWORD duration_ms);
const wchar_t* StageText(const UpdateContext* context, UpdateStage stage);
void DrawProgressBar(UpdateContext* context, const D2D1_RECT_F& track_rect);
float MeasureTextHeight(
    UpdateContext* context,
    const std::wstring& text,
    IDWriteTextFormat* text_format,
    float max_width);
void DrawWindowContent(UpdateContext* context, HDC device_context);
void ConfigureWindowAppearance(HWND window);
void PostStage(UpdateContext* context, UpdateStage stage);
void PostProgress(UpdateContext* context, int percent);
void Fail(UpdateContext* context, const std::wstring& message);
bool WaitForHostExit(DWORD process_id);
bool ExtractArchive(const std::wstring& archive_path, const std::wstring& destination_path);
int CountFiles(const std::filesystem::path& source_dir);
bool CopyBundle(
    const std::wstring& source_dir,
    const std::wstring& destination_dir,
    UpdateContext* context);
void Relaunch(const std::wstring& executable_path);
LRESULT CALLBACK WindowProc(HWND window, UINT message, WPARAM w_param, LPARAM l_param);
void RunUpdate(UpdateContext* context);

}  // namespace melo_trip_updater

#endif  // MELOTRIP_UPDATER_SHARED_H_
