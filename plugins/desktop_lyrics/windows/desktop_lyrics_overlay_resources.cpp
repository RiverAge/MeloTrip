#ifndef NOMINMAX
#define NOMINMAX
#endif
#include "desktop_lyrics_overlay.h"

#include <algorithm>
#include <cmath>

namespace desktop_lyrics {
namespace {

template <typename T>
T ClampValue(T value, T min, T max) {
  return (std::max)(min, (std::min)(value, max));
}

}  // namespace
bool DesktopLyricsOverlay::EnsureBackBuffer(HDC screen_dc, int width, int height) {
  if (!screen_dc || width <= 0 || height <= 0) return false;
  if (backbuffer_dc_ && backbuffer_bitmap_ && backbuffer_width_ == width &&
      backbuffer_height_ == height) {
    return true;
  }

  ReleaseBackBuffer();
  backbuffer_dc_ = CreateCompatibleDC(screen_dc);
  if (!backbuffer_dc_) return false;

  BITMAPINFO bmi{};
  bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth = width;
  bmi.bmiHeader.biHeight = -height;
  bmi.bmiHeader.biPlanes = 1;
  bmi.bmiHeader.biBitCount = 32;
  bmi.bmiHeader.biCompression = BI_RGB;

  backbuffer_bitmap_ = CreateDIBSection(backbuffer_dc_, &bmi, DIB_RGB_COLORS,
                                        &backbuffer_bits_, nullptr, 0);
  if (!backbuffer_bitmap_) {
    ReleaseBackBuffer();
    return false;
  }

  backbuffer_old_bitmap_ = SelectObject(backbuffer_dc_, backbuffer_bitmap_);
  backbuffer_width_ = width;
  backbuffer_height_ = height;
  ReleaseRenderTarget();
  return true;
}

void DesktopLyricsOverlay::ReleaseBackBuffer() {
  if (backbuffer_dc_ && backbuffer_old_bitmap_) {
    SelectObject(backbuffer_dc_, backbuffer_old_bitmap_);
  }
  if (backbuffer_bitmap_) DeleteObject(backbuffer_bitmap_);
  if (backbuffer_dc_) DeleteDC(backbuffer_dc_);
  backbuffer_dc_ = nullptr;
  backbuffer_bitmap_ = nullptr;
  backbuffer_old_bitmap_ = nullptr;
  backbuffer_bits_ = nullptr;
  backbuffer_width_ = 0;
  backbuffer_height_ = 0;
}

bool DesktopLyricsOverlay::EnsureFactories() {
  if (!d2d_factory_) {
    if (FAILED(D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED,
                                 d2d_factory_.ReleaseAndGetAddressOf()))) {
      return false;
    }
  }
  if (!dwrite_factory_) {
    if (FAILED(DWriteCreateFactory(
            DWRITE_FACTORY_TYPE_SHARED, __uuidof(IDWriteFactory),
            reinterpret_cast<IUnknown**>(
                dwrite_factory_.ReleaseAndGetAddressOf())))) {
      return false;
    }
  }
  return true;
}

bool DesktopLyricsOverlay::EnsureRenderTarget() {
  if (render_target_) return true;
  if (!EnsureFactories() || !backbuffer_dc_) return false;

  const D2D1_RENDER_TARGET_PROPERTIES props = D2D1::RenderTargetProperties(
      D2D1_RENDER_TARGET_TYPE_DEFAULT,
      D2D1::PixelFormat(DXGI_FORMAT_B8G8R8A8_UNORM,
                        D2D1_ALPHA_MODE_PREMULTIPLIED));
  if (FAILED(d2d_factory_->CreateDCRenderTarget(
          &props, render_target_.ReleaseAndGetAddressOf()))) {
    return false;
  }
  return true;
}

void DesktopLyricsOverlay::ReleaseRenderTarget() { render_target_.Reset(); }

bool DesktopLyricsOverlay::EnsureTextFormats() {
  if (!EnsureFactories()) return false;
  if (text_format_ && measure_text_format_) return true;

  Microsoft::WRL::ComPtr<IDWriteTextFormat> text_format;
  if (FAILED(dwrite_factory_->CreateTextFormat(
          font_family_.c_str(), nullptr, ToFontWeight(),
          DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
          static_cast<FLOAT>(font_size_), L"", &text_format))) {
    return false;
  }
  text_format->SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);
  text_format->SetTextAlignment(ToTextAlignment());
  text_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_CENTER);

  Microsoft::WRL::ComPtr<IDWriteTextFormat> measure_format;
  if (FAILED(dwrite_factory_->CreateTextFormat(
          font_family_.c_str(), nullptr, ToFontWeight(),
          DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
          static_cast<FLOAT>(font_size_), L"", &measure_format))) {
    return false;
  }
  measure_format->SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);
  measure_format->SetTextAlignment(ToTextAlignment());
  measure_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_NEAR);

  text_format_ = text_format;
  measure_text_format_ = measure_format;
  return true;
}

void DesktopLyricsOverlay::ResetTextFormats() {
  text_format_.Reset();
  measure_text_format_.Reset();
}

D2D1_COLOR_F DesktopLyricsOverlay::ToColorF(uint32_t argb) const {
  const float a = static_cast<float>((argb >> 24) & 0xFF) / 255.0f;
  const float r = static_cast<float>((argb >> 16) & 0xFF) / 255.0f;
  const float g = static_cast<float>((argb >> 8) & 0xFF) / 255.0f;
  const float b = static_cast<float>(argb & 0xFF) / 255.0f;
  return D2D1::ColorF(r, g, b, a);
}

DWRITE_TEXT_ALIGNMENT DesktopLyricsOverlay::ToTextAlignment() const {
  switch (text_align_) {
    case 1:
      return DWRITE_TEXT_ALIGNMENT_CENTER;
    case 2:
      return DWRITE_TEXT_ALIGNMENT_TRAILING;
    default:
      return DWRITE_TEXT_ALIGNMENT_LEADING;
  }
}

DWRITE_FONT_WEIGHT DesktopLyricsOverlay::ToFontWeight() const {
  if (font_weight_value_ >= 700) return DWRITE_FONT_WEIGHT_BOLD;
  if (font_weight_value_ >= 600) return DWRITE_FONT_WEIGHT_SEMI_BOLD;
  if (font_weight_value_ >= 500) return DWRITE_FONT_WEIGHT_MEDIUM;
  return DWRITE_FONT_WEIGHT_NORMAL;
}

}  // namespace desktop_lyrics
