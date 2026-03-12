#include "updater_shared.h"

namespace melo_trip_updater {
namespace {

D2D1_ROUNDED_RECT ToRoundedRect(const D2D1_RECT_F& rect, float radius) {
  return D2D1::RoundedRect(rect, radius, radius);
}

}  // namespace

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
  context->render_target->FillRoundedRectangle(
      &rounded_track, context->track_brush.Get());

  D2D1_RECT_F fill_rect = track_rect;
  if (context->progress_marquee) {
    const float chunk_width =
        (track_rect.right - track_rect.left) * kProgressMarqueeWidthFactor;
    const float track_width = track_rect.right - track_rect.left;
    const float travel = track_width + chunk_width;
    const float offset =
        static_cast<float>(context->marquee_offset) / 1000.0f * travel;
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
        (track_rect.right - track_rect.left) *
            static_cast<float>(context->progress_percent) / 100.0f;
  }

  if (fill_rect.right <= fill_rect.left) {
    return;
  }

  const D2D1_ROUNDED_RECT rounded_fill = ToRoundedRect(fill_rect, radius / 2.0f);
  context->render_target->FillRoundedRectangle(
      &rounded_fill, context->progress_brush.Get());
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

  const D2D1_RECT_F border_rect = D2D1::RectF(0.5f, 0.5f, width - 0.5f, height - 0.5f);
  context->render_target->DrawRectangle(
      &border_rect, context->background_brush.Get(), 1.0f);

  const float padding = kContentPaddingDip;
  const float content_left = padding;
  const float content_right = width - padding;
  const float available_text_width = content_right - content_left;

  const float title_y = kTitleTopDip;
  const float title_height = 48.0f;
  const float version_y = 102.0f;
  const float version_height = 24.0f;
  const float progress_y = height - kProgressBottomInsetDip - kProgressHeightDip;
  const float progress_width = available_text_width * kProgressWidthFactor;
  const float progress_left =
      content_left + (available_text_width - progress_width) / 2.0f;
  const float progress_right = progress_left + progress_width;

  const D2D1_RECT_F title_rect = D2D1::RectF(
      content_left, title_y, content_right, title_y + title_height);
  const D2D1_RECT_F version_rect = D2D1::RectF(
      content_left, version_y, content_right, version_y + version_height);
  const D2D1_RECT_F progress_rect = D2D1::RectF(
      progress_left, progress_y, progress_right, progress_y + kProgressHeightDip);

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

}  // namespace melo_trip_updater
