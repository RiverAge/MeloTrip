#include "updater_shared.h"

#include <cmath>

namespace melo_trip_updater {
namespace {

D2D1_ROUNDED_RECT ToRoundedRect(const D2D1_RECT_F& rect, float radius) {
  return D2D1::RoundedRect(rect, radius, radius);
}

}  // namespace

float ScaleDip(const UpdateContext* context, float dip) {
  const UINT dpi = context != nullptr ? context->dpi : USER_DEFAULT_SCREEN_DPI;
  return dip * static_cast<float>(dpi) /
      static_cast<float>(USER_DEFAULT_SCREEN_DPI);
}

int ScaleDipToInt(const UpdateContext* context, float dip) {
  return static_cast<int>(std::lround(ScaleDip(context, dip)));
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
  context->render_target->SetAntialiasMode(
      D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
  context->render_target->SetTextAntialiasMode(
      D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE);

  if (FAILED(context->render_target->CreateSolidColorBrush(
          kWindowBackgroundColor,
          context->background_brush.ReleaseAndGetAddressOf())) ||
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

void PostStage(UpdateContext* context, UpdateStage stage) {
  PostMessage(context->window, kMessageStage, static_cast<WPARAM>(stage), 0);
}

void PostProgress(UpdateContext* context, int percent) {
  PostMessage(context->window, kMessageProgress, static_cast<WPARAM>(percent), 0);
}

}  // namespace melo_trip_updater
