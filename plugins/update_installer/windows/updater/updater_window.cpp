#include "updater_shared.h"

namespace melo_trip_updater {
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

}  // namespace melo_trip_updater
