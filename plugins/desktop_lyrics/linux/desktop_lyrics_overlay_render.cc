#include "desktop_lyrics_overlay.h"

#include <algorithm>
#include <cmath>

#include <pango/pangocairo.h>

namespace desktop_lyrics {

namespace {

constexpr double kTextHorizontalPadding = 24.0;
constexpr double kTextVerticalPadding = 10.0;
constexpr double kShadowOffset = 2.5;
constexpr double kPi = 3.14159265358979323846;

double Clamp(double value, double min, double max) {
  return std::max(min, std::min(max, value));
}

}  // namespace
gboolean DesktopLyricsOverlay::Draw(cairo_t* cr) {
  if (cr == nullptr || !enabled_) return FALSE;

  GtkAllocation allocation{};
  gtk_widget_get_allocation(drawing_area_, &allocation);
  double width = static_cast<double>(allocation.width);
  double height = static_cast<double>(allocation.height);
  if (width < overlay_width_ * 0.6 || height < overlay_height_ * 0.6) {
    // Some Wayland compositors can transiently report a very small allocation
    // for undecorated windows; keep sizing sticky to config.
    width = static_cast<double>(overlay_width_);
    height = static_cast<double>(overlay_height_);
    if (window_ != nullptr) {
      gtk_window_resize(GTK_WINDOW(window_), overlay_width_, overlay_height_);
    }
    if (drawing_area_ != nullptr) {
      gtk_widget_queue_draw(drawing_area_);
    }
    return FALSE;
  }
  if (width <= 0 || height <= 0) return FALSE;

  cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE);
  cairo_set_source_rgba(cr, 0.0, 0.0, 0.0, 0.0);
  cairo_paint(cr);
  cairo_set_operator(cr, CAIRO_OPERATOR_OVER);

  if (current_line_.empty()) return FALSE;

  const double pad = background_padding_;
  if (((background_argb_ >> 24) & 0xFFU) > 0U) {
    SetColor(cr, background_argb_);
    DrawRoundedRect(cr, pad, pad, width - pad * 2.0, height - pad * 2.0,
                    background_radius_);
    cairo_fill(cr);
  }

  const double area_x = kTextHorizontalPadding;
  const double area_y = kTextVerticalPadding;
  const double area_width = std::max(8.0, width - kTextHorizontalPadding * 2.0);
  const double area_height = std::max(8.0, height - kTextVerticalPadding * 2.0);

  PangoLayout* layout = pango_cairo_create_layout(cr);
  pango_layout_set_text(layout, current_line_.c_str(), -1);
  pango_layout_set_single_paragraph_mode(layout, TRUE);
  pango_layout_set_ellipsize(layout, PANGO_ELLIPSIZE_END);
  pango_layout_set_width(layout, static_cast<int>(std::round(area_width * PANGO_SCALE)));
  pango_layout_set_alignment(
      layout,
      text_align_ == 1 ? PANGO_ALIGN_CENTER
                       : (text_align_ == 2 ? PANGO_ALIGN_RIGHT : PANGO_ALIGN_LEFT));

  PangoFontDescription* desc = pango_font_description_new();
  pango_font_description_set_family(desc, font_family_.c_str());
  pango_font_description_set_size(
      desc, static_cast<int>(std::round(font_size_ * PANGO_SCALE)));
  pango_font_description_set_weight(
      desc, static_cast<PangoWeight>(font_weight_value_));
  pango_layout_set_font_description(layout, desc);
  pango_font_description_free(desc);

  int text_width = 0;
  int text_height = 0;
  pango_layout_get_pixel_size(layout, &text_width, &text_height);
  const double text_x = area_x;
  const double text_y = area_y + (area_height - static_cast<double>(text_height)) * 0.5;

  if (((shadow_argb_ >> 24) & 0xFFU) > 0U) {
    cairo_save(cr);
    SetColor(cr, shadow_argb_);
    cairo_translate(cr, text_x + kShadowOffset, text_y + kShadowOffset);
    pango_cairo_show_layout(cr, layout);
    cairo_restore(cr);
  }

  const bool has_frame_progress = has_frame_ && frame_line_progress_ < 0.999;
  if (has_frame_progress) {
    uint32_t base_argb = text_gradient_enabled_ ? text_gradient_start_argb_ : text_argb_;
    const uint32_t base_alpha = (base_argb >> 24) & 0xFFU;
    const uint32_t softened_alpha = std::max(base_alpha / 2, static_cast<uint32_t>(0x88));
    base_argb = (base_argb & 0x00FFFFFFU) | (softened_alpha << 24);
    // Avoid overdrawing antialiased edges by drawing base only in the
    // unplayed segment.
    cairo_save(cr);
    cairo_rectangle(cr, text_x + area_width * frame_line_progress_, text_y,
                    area_width * (1.0 - frame_line_progress_),
                    static_cast<double>(text_height));
    cairo_clip(cr);
    DrawTextLayer(cr, layout, text_x, text_y, area_width, static_cast<double>(text_height),
                  false, base_argb);
    cairo_restore(cr);

    cairo_save(cr);
    cairo_rectangle(cr, text_x, text_y, area_width * frame_line_progress_,
                    static_cast<double>(text_height));
    cairo_clip(cr);
    DrawTextLayer(cr, layout, text_x, text_y, area_width,
                  static_cast<double>(text_height), text_gradient_enabled_,
                  text_argb_);
    cairo_restore(cr);
  } else {
    DrawTextLayer(cr, layout, text_x, text_y, area_width,
                  static_cast<double>(text_height), text_gradient_enabled_,
                  text_argb_);
  }

  if (stroke_width_ > 0.01 && ((stroke_argb_ >> 24) & 0xFFU) > 0U) {
    cairo_save(cr);
    cairo_translate(cr, text_x, text_y);
    pango_cairo_layout_path(cr, layout);
    const double visible_width = std::max(stroke_width_, 1.1);
    const uint32_t glow_argb =
        (stroke_argb_ & 0x00FFFFFFU) | (static_cast<uint32_t>(0x66) << 24);
    SetColor(cr, glow_argb);
    cairo_set_line_join(cr, CAIRO_LINE_JOIN_ROUND);
    cairo_set_line_width(cr, visible_width + 1.0);
    cairo_stroke_preserve(cr);
    SetColor(cr, stroke_argb_);
    cairo_set_line_width(cr, visible_width);
    cairo_stroke(cr);
    cairo_restore(cr);
  }

  g_object_unref(layout);
  return FALSE;
}

void DesktopLyricsOverlay::PositionNearBottomCenter(bool force) {
  if (window_ == nullptr) return;
  if (has_custom_position_ && !force) return;

  GdkDisplay* display = gtk_widget_get_display(window_);
  if (display == nullptr) return;

  GdkMonitor* monitor = nullptr;
  GdkWindow* gdk_window = gtk_widget_get_window(window_);
  if (gdk_window != nullptr) {
    monitor = gdk_display_get_monitor_at_window(display, gdk_window);
  }
  if (monitor == nullptr) monitor = gdk_display_get_primary_monitor(display);
  if (monitor == nullptr && gdk_display_get_n_monitors(display) > 0) {
    monitor = gdk_display_get_monitor(display, 0);
  }
  if (monitor == nullptr) return;

  GdkRectangle workarea{};
  gdk_monitor_get_workarea(monitor, &workarea);
  const int left = workarea.x + (workarea.width - overlay_width_) / 2;
  const int top = workarea.y + workarea.height - overlay_height_ - kBottomMargin;
  gtk_window_move(GTK_WINDOW(window_), left, top);
}

void DesktopLyricsOverlay::ApplyWindowBehavior() {
  if (window_ == nullptr) return;

  gtk_widget_set_opacity(window_, opacity_);
  gtk_window_set_keep_above(GTK_WINDOW(window_), TRUE);
  gtk_window_set_accept_focus(GTK_WINDOW(window_), FALSE);

  GdkWindow* gdk_window = gtk_widget_get_window(window_);
  if (gdk_window != nullptr) {
    gdk_window_set_pass_through(gdk_window, click_through_);
  }
  if (click_through_) {
    cairo_region_t* empty_region = cairo_region_create();
    gtk_widget_input_shape_combine_region(window_, empty_region);
    if (drawing_area_ != nullptr) {
      gtk_widget_input_shape_combine_region(drawing_area_, empty_region);
    }
    cairo_region_destroy(empty_region);
  } else {
    gtk_widget_input_shape_combine_region(window_, nullptr);
    if (drawing_area_ != nullptr) {
      gtk_widget_input_shape_combine_region(drawing_area_, nullptr);
    }
  }
}

int DesktopLyricsOverlay::ComputeAutoOverlayHeight() const {
  // Keep this tied to typography so smaller fonts shrink overlay height.
  const double text_block = font_size_ * 1.35;
  const double stroke_extra = std::max(0.0, stroke_width_) * 2.0;
  const double vertical_padding =
      kTextVerticalPadding * 2.0 + background_padding_ * 2.0 + 20.0;
  const double raw = text_block + stroke_extra + vertical_padding;
  return static_cast<int>(std::round(Clamp(raw, 72.0, 800.0)));
}

void DesktopLyricsOverlay::RequestRepaint() {
  if (drawing_area_ != nullptr && gtk_widget_get_visible(window_)) {
    gtk_widget_queue_draw(drawing_area_);
  }
}

DesktopLyricsOverlay::Rgba DesktopLyricsOverlay::ColorFromArgb(uint32_t argb) const {
  Rgba color;
  color.a = static_cast<double>((argb >> 24) & 0xFFU) / 255.0;
  color.r = static_cast<double>((argb >> 16) & 0xFFU) / 255.0;
  color.g = static_cast<double>((argb >> 8) & 0xFFU) / 255.0;
  color.b = static_cast<double>(argb & 0xFFU) / 255.0;
  return color;
}

void DesktopLyricsOverlay::SetColor(cairo_t* cr, uint32_t argb) const {
  const Rgba color = ColorFromArgb(argb);
  cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a);
}

void DesktopLyricsOverlay::DrawRoundedRect(cairo_t* cr,
                                           double x,
                                           double y,
                                           double width,
                                           double height,
                                           double radius) const {
  if (cr == nullptr) return;
  const double safe_radius = Clamp(radius, 0.0, std::min(width, height) * 0.5);
  if (safe_radius <= 0.1) {
    cairo_rectangle(cr, x, y, width, height);
    return;
  }
  const double right = x + width;
  const double bottom = y + height;
  cairo_new_sub_path(cr);
  cairo_arc(cr, right - safe_radius, y + safe_radius, safe_radius, -kPi / 2.0, 0.0);
  cairo_arc(cr, right - safe_radius, bottom - safe_radius, safe_radius, 0.0,
            kPi / 2.0);
  cairo_arc(cr, x + safe_radius, bottom - safe_radius, safe_radius, kPi / 2.0,
            kPi);
  cairo_arc(cr, x + safe_radius, y + safe_radius, safe_radius, kPi,
            3.0 * kPi / 2.0);
  cairo_close_path(cr);
}

void DesktopLyricsOverlay::DrawTextLayer(cairo_t* cr,
                                         PangoLayout* layout,
                                         double x,
                                         double y,
                                         double width,
                                         double height,
                                         bool use_gradient,
                                         uint32_t fallback_argb) const {
  if (cr == nullptr || layout == nullptr) return;

  cairo_save(cr);
  cairo_translate(cr, x, y);
  pango_cairo_layout_path(cr, layout);

  if (use_gradient) {
    const double cx = width * 0.5;
    const double cy = height * 0.5;
    const double radians = text_gradient_angle_ * kPi / 180.0;
    const double half = std::max(width, height) * 0.5;
    const double dx = std::cos(radians) * half;
    const double dy = std::sin(radians) * half;
    cairo_pattern_t* gradient =
        cairo_pattern_create_linear(cx - dx, cy - dy, cx + dx, cy + dy);
    const Rgba start = ColorFromArgb(text_gradient_start_argb_);
    const Rgba end = ColorFromArgb(text_gradient_end_argb_);
    cairo_pattern_add_color_stop_rgba(gradient, 0.0, start.r, start.g, start.b,
                                      start.a);
    cairo_pattern_add_color_stop_rgba(gradient, 1.0, end.r, end.g, end.b, end.a);
    cairo_set_source(cr, gradient);
    cairo_fill(cr);
    cairo_pattern_destroy(gradient);
  } else {
    SetColor(cr, fallback_argb);
    cairo_fill(cr);
  }

  cairo_restore(cr);
}

}  // namespace desktop_lyrics
