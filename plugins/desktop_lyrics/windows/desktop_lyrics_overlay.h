#ifndef FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
#define FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_

#include <windows.h>

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace Gdiplus {
class GraphicsPath;
}

namespace desktop_lyrics {

struct OverlayConfig {
  bool enabled = true;
  bool click_through = false;
  double font_size = 38.0;
  double opacity = 0.96;
  uint32_t text_argb = 0xFFF6F7FF;
  uint32_t shadow_argb = 0x00000000;
  uint32_t stroke_argb = 0x00000000;
  double stroke_width = 0.0;
  uint32_t background_argb = 0x7A220A35;
  double background_radius = 22.0;
  double background_padding = 12.0;
  bool text_gradient_enabled = true;
  uint32_t text_gradient_start_argb = 0xFFFFD36E;
  uint32_t text_gradient_end_argb = 0xFFFF4D8D;
  double text_gradient_angle = 0.0;
  double overlay_width = 980.0;
  double overlay_height = -1.0;
  std::wstring font_family = L"Segoe UI";
  int text_align = 0;
  int font_weight_value = 400;
};

class DesktopLyricsOverlay {
 public:
  DesktopLyricsOverlay();
  ~DesktopLyricsOverlay();

  bool Create();
  void Show();
  void Hide();
  void Dispose();

  void UpdateLyricFrame(const std::wstring& current_line, double line_progress);
  void UpdateConfig(const OverlayConfig& config);

 private:
  static LRESULT CALLBACK WndProc(HWND hwnd,
                                  UINT message,
                                  WPARAM wparam,
                                  LPARAM lparam);
  LRESULT HandleMessage(HWND hwnd,
                        UINT message,
                        WPARAM wparam,
                        LPARAM lparam);
  void PositionNearBottomCenter(bool force = false);
  void RequestRepaint();
  void ApplyWindowStyles();
  void RenderLayeredWindow();
  int ComputeAutoOverlayHeight(HDC reference_dc, int width) const;
  bool EnsureBackBuffer(HDC screen_dc, int width, int height);
  void ReleaseBackBuffer();

  HWND hwnd_ = nullptr;
  std::wstring current_line_;
  double frame_line_progress_ = 1.0;
  bool has_frame_ = false;
  bool enabled_ = true;
  bool click_through_ = false;
  double font_size_ = 38.0;
  double opacity_ = 0.96;
  bool has_custom_position_ = false;
  bool dragging_ = false;
  POINT drag_start_cursor_{};
  POINT drag_start_window_{};
  uint32_t text_argb_ = 0xFFF6F7FF;
  uint32_t shadow_argb_ = 0x00000000;
  uint32_t stroke_argb_ = 0x00000000;
  double stroke_width_ = 0.0;
  uint32_t background_argb_ = 0x7A220A35;
  double background_radius_ = 22.0;
  double background_padding_ = 12.0;
  bool text_gradient_enabled_ = true;
  uint32_t text_gradient_start_argb_ = 0xFFFFD36E;
  uint32_t text_gradient_end_argb_ = 0xFFFF4D8D;
  double text_gradient_angle_ = 0.0;
  std::wstring font_family_ = L"Segoe UI";
  int text_align_ = 0;
  int font_weight_value_ = 400;
  int overlay_width_ = 980;
  int overlay_height_ = 160;
  bool auto_overlay_height_ = true;

  HDC backbuffer_dc_ = nullptr;
  HBITMAP backbuffer_bitmap_ = nullptr;
  HGDIOBJ backbuffer_old_bitmap_ = nullptr;
  int backbuffer_width_ = 0;
  int backbuffer_height_ = 0;
  void* backbuffer_bits_ = nullptr;

  std::wstring cached_text_;
  std::wstring cached_font_family_;
  int cached_width_ = 0;
  int cached_height_ = 0;
  int cached_text_align_ = -1;
  int cached_font_weight_ = -1;
  float cached_font_size_ = 0.0f;
  float cached_stroke_width_ = 0.0f;
  std::unique_ptr<Gdiplus::GraphicsPath> cached_text_path_;
};

}  // namespace desktop_lyrics

#endif  // FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
