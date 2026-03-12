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
void DesktopLyricsOverlay::RenderLayeredWindow() {
  if (!hwnd_ || !enabled_ || !IsWindowVisible(hwnd_)) return;

  RECT window_rect{};
  if (!GetWindowRect(hwnd_, &window_rect)) return;
  int width = window_rect.right - window_rect.left;
  int height = window_rect.bottom - window_rect.top;
  if (width <= 0 || height <= 0) return;

  HDC screen_dc = GetDC(nullptr);
  if (!screen_dc) return;
  if (auto_overlay_height_) {
    const int desired_height = ComputeAutoOverlayHeight(width);
    if (desired_height != height) {
      overlay_height_ = desired_height;
      if (!has_custom_position_) {
        PositionNearBottomCenter(true);
      } else {
        SetWindowPos(hwnd_, HWND_TOPMOST, 0, 0, overlay_width_, overlay_height_,
                     SWP_NOMOVE | SWP_NOACTIVATE);
      }
      GetWindowRect(hwnd_, &window_rect);
      width = window_rect.right - window_rect.left;
      height = window_rect.bottom - window_rect.top;
    }
  }
  if (!EnsureBackBuffer(screen_dc, width, height) || !EnsureRenderTarget() ||
      !EnsureTextFormats()) {
    ReleaseDC(nullptr, screen_dc);
    return;
  }

  RECT update_rect{0, 0, width, height};
  if (FAILED(render_target_->BindDC(backbuffer_dc_, &update_rect))) {
    ReleaseDC(nullptr, screen_dc);
    return;
  }

  render_target_->BeginDraw();
  render_target_->Clear(D2D1::ColorF(0, 0.0f));

  const float pad = static_cast<float>(background_padding_);
  const D2D1_ROUNDED_RECT bg_rect = D2D1::RoundedRect(
      D2D1::RectF(pad, pad, static_cast<float>(width) - pad,
                  static_cast<float>(height) - pad),
      static_cast<float>(background_radius_),
      static_cast<float>(background_radius_));

  Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> background_brush;
  const bool has_background = ((background_argb_ >> 24) & 0xFF) > 0;
  if (has_background &&
      SUCCEEDED(render_target_->CreateSolidColorBrush(
          ToColorF(background_argb_), &background_brush))) {
    render_target_->FillRoundedRectangle(&bg_rect, background_brush.Get());
  }

  const D2D1_RECT_F text_rect = D2D1::RectF(
      24.0f + static_cast<float>(stroke_width_),
      8.0f + static_cast<float>(stroke_width_),
      static_cast<float>(width) - 24.0f - static_cast<float>(stroke_width_),
      static_cast<float>(height) - 8.0f - static_cast<float>(stroke_width_));

  if (!current_line_.empty()) {
    if (((shadow_argb_ >> 24) & 0xFF) > 0) {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> shadow_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(shadow_argb_), &shadow_brush))) {
        const D2D1_RECT_F shadow_rect = D2D1::RectF(
            text_rect.left + 2.5f, text_rect.top + 2.5f, text_rect.right + 2.5f,
            text_rect.bottom + 2.5f);
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), shadow_rect, shadow_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    }

    if (stroke_width_ > 0.01 && ((stroke_argb_ >> 24) & 0xFF) > 0) {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> stroke_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(stroke_argb_), &stroke_brush))) {
        const float offsets[] = {-1.4f, 0.0f, 1.4f};
        for (float dx : offsets) {
          for (float dy : offsets) {
            if (std::abs(dx) < 0.01f && std::abs(dy) < 0.01f) continue;
            const D2D1_RECT_F stroke_rect = D2D1::RectF(
                text_rect.left + dx, text_rect.top + dy, text_rect.right + dx,
                text_rect.bottom + dy);
            render_target_->DrawTextW(
                current_line_.c_str(),
                static_cast<UINT32>(current_line_.size()), text_format_.Get(),
                stroke_rect, stroke_brush.Get(), D2D1_DRAW_TEXT_OPTIONS_CLIP);
          }
        }
      }
    }

    const bool has_progress = has_frame_ && frame_line_progress_ < 0.999;
    if (has_progress) {
      uint32_t base_argb =
          text_gradient_enabled_ ? text_gradient_start_argb_ : text_argb_;
      const uint32_t base_alpha = (base_argb >> 24) & 0xFF;
      const uint32_t softened_alpha =
          (std::max)(base_alpha / 2, static_cast<uint32_t>(0x88));
      base_argb = (base_argb & 0x00FFFFFF) | (softened_alpha << 24);
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> base_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(
              ToColorF(base_argb), &base_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, base_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
      const D2D1_RECT_F progress_clip = D2D1::RectF(
          text_rect.left, text_rect.top,
          text_rect.left +
              (text_rect.right - text_rect.left) *
                  static_cast<float>(frame_line_progress_),
          text_rect.bottom);
      render_target_->PushAxisAlignedClip(progress_clip,
                                          D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
    }

    if (text_gradient_enabled_) {
      const float angle =
          static_cast<float>(text_gradient_angle_ * 3.141592653589793 / 180.0);
      const float center_x = (text_rect.left + text_rect.right) * 0.5f;
      const float center_y = (text_rect.top + text_rect.bottom) * 0.5f;
      const float half_extent =
          (std::max)(text_rect.right - text_rect.left,
                     text_rect.bottom - text_rect.top) *
          0.5f;
      const float dx = std::cos(angle) * half_extent;
      const float dy = std::sin(angle) * half_extent;
      D2D1_GRADIENT_STOP stops[2] = {
          {0.0f, ToColorF(text_gradient_start_argb_)},
          {1.0f, ToColorF(text_gradient_end_argb_)},
      };
      Microsoft::WRL::ComPtr<ID2D1GradientStopCollection> stop_collection;
      Microsoft::WRL::ComPtr<ID2D1LinearGradientBrush> gradient_brush;
      if (SUCCEEDED(render_target_->CreateGradientStopCollection(
              stops, 2, D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_CLAMP,
              &stop_collection)) &&
          SUCCEEDED(render_target_->CreateLinearGradientBrush(
              D2D1::LinearGradientBrushProperties(
                  D2D1::Point2F(center_x - dx, center_y - dy),
                  D2D1::Point2F(center_x + dx, center_y + dy)),
              stop_collection.Get(), &gradient_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, gradient_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    } else {
      Microsoft::WRL::ComPtr<ID2D1SolidColorBrush> text_brush;
      if (SUCCEEDED(render_target_->CreateSolidColorBrush(ToColorF(text_argb_),
                                                          &text_brush))) {
        render_target_->DrawTextW(
            current_line_.c_str(), static_cast<UINT32>(current_line_.size()),
            text_format_.Get(), text_rect, text_brush.Get(),
            D2D1_DRAW_TEXT_OPTIONS_CLIP);
      }
    }

    if (has_progress) {
      render_target_->PopAxisAlignedClip();
    }
  }

  const HRESULT end_draw = render_target_->EndDraw();
  if (end_draw == D2DERR_RECREATE_TARGET) {
    ReleaseRenderTarget();
  }

  POINT src_pt{0, 0};
  SIZE size{width, height};
  POINT dst_pt{window_rect.left, window_rect.top};
  BLENDFUNCTION blend{};
  blend.BlendOp = AC_SRC_OVER;
  blend.SourceConstantAlpha =
      static_cast<BYTE>(std::round(ClampValue(opacity_, 0.0, 1.0) * 255.0));
  blend.AlphaFormat = AC_SRC_ALPHA;
  UpdateLayeredWindow(hwnd_, screen_dc, &dst_pt, &size, backbuffer_dc_, &src_pt,
                      0, &blend, ULW_ALPHA);
  ReleaseDC(nullptr, screen_dc);
}

}  // namespace desktop_lyrics
