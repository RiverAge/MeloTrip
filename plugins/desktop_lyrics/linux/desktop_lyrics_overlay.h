#ifndef FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
#define FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_

#include <gtk/gtk.h>

#include <cstdint>
#include <string>

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
  std::string font_family = "Sans";
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
  void UpdateLyricFrame(const std::string& current_line, double line_progress);
  void UpdateConfig(const OverlayConfig& config);

 private:
  struct Rgba {
    double r = 0.0;
    double g = 0.0;
    double b = 0.0;
    double a = 0.0;
  };

  static constexpr int kBottomMargin = 120;
  static constexpr int kDefaultOverlayHeight = 160;

  static gboolean OnDraw(GtkWidget* widget, cairo_t* cr, gpointer user_data);
  static gboolean OnButtonPress(GtkWidget* widget,
                                GdkEventButton* event,
                                gpointer user_data);
  static gboolean OnButtonRelease(GtkWidget* widget,
                                  GdkEventButton* event,
                                  gpointer user_data);
  static gboolean OnMotion(GtkWidget* widget,
                           GdkEventMotion* event,
                           gpointer user_data);

  gboolean Draw(cairo_t* cr);
  void PositionNearBottomCenter(bool force = false);
  void ApplyWindowBehavior();
  void RequestRepaint();
  Rgba ColorFromArgb(uint32_t argb) const;
  void SetColor(cairo_t* cr, uint32_t argb) const;
  void DrawRoundedRect(cairo_t* cr,
                       double x,
                       double y,
                       double width,
                       double height,
                       double radius) const;
  void DrawTextLayer(cairo_t* cr,
                     PangoLayout* layout,
                     double x,
                     double y,
                     double width,
                     double height,
                     bool use_gradient,
                     uint32_t fallback_argb) const;
  int ComputeAutoOverlayHeight() const;

  GtkWidget* window_ = nullptr;
  GtkWidget* drawing_area_ = nullptr;

  std::string current_line_;
  double frame_line_progress_ = 1.0;
  bool has_frame_ = false;

  bool enabled_ = true;
  bool click_through_ = false;
  double font_size_ = 38.0;
  double opacity_ = 0.96;
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
  std::string font_family_ = "Sans";
  int text_align_ = 0;
  int font_weight_value_ = 400;
  int overlay_width_ = 980;
  int overlay_height_ = kDefaultOverlayHeight;
  bool auto_overlay_height_ = true;

  bool has_custom_position_ = false;
  bool dragging_ = false;
};

}  // namespace desktop_lyrics

#endif  // FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
