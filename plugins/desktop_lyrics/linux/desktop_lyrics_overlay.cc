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

DesktopLyricsOverlay::DesktopLyricsOverlay() = default;

DesktopLyricsOverlay::~DesktopLyricsOverlay() { Dispose(); }

bool DesktopLyricsOverlay::Create() {
  if (window_ != nullptr) return true;

  window_ = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  if (window_ == nullptr) return false;
  drawing_area_ = gtk_drawing_area_new();
  if (drawing_area_ == nullptr) return false;

  gtk_widget_set_app_paintable(window_, TRUE);
  gtk_widget_set_app_paintable(drawing_area_, TRUE);
  gtk_window_set_decorated(GTK_WINDOW(window_), FALSE);
  gtk_window_set_skip_taskbar_hint(GTK_WINDOW(window_), TRUE);
  gtk_window_set_skip_pager_hint(GTK_WINDOW(window_), TRUE);
  gtk_window_set_type_hint(GTK_WINDOW(window_), GDK_WINDOW_TYPE_HINT_UTILITY);
  gtk_window_set_keep_above(GTK_WINDOW(window_), TRUE);
  gtk_window_set_accept_focus(GTK_WINDOW(window_), FALSE);
  gtk_window_set_resizable(GTK_WINDOW(window_), FALSE);
  gtk_window_set_default_size(GTK_WINDOW(window_), overlay_width_, overlay_height_);
  gtk_window_resize(GTK_WINDOW(window_), overlay_width_, overlay_height_);
  gtk_widget_set_size_request(drawing_area_, overlay_width_, overlay_height_);

  GdkScreen* screen = gtk_widget_get_screen(window_);
  if (screen != nullptr) {
    GdkVisual* visual = gdk_screen_get_rgba_visual(screen);
    if (visual != nullptr) {
      gtk_widget_set_visual(window_, visual);
    }
  }

  gtk_container_add(GTK_CONTAINER(window_), drawing_area_);
  gtk_widget_add_events(window_, GDK_BUTTON_PRESS_MASK | GDK_BUTTON_RELEASE_MASK |
                                     GDK_POINTER_MOTION_MASK);
  gtk_widget_add_events(drawing_area_, GDK_BUTTON_PRESS_MASK |
                                          GDK_BUTTON_RELEASE_MASK |
                                          GDK_POINTER_MOTION_MASK);

  g_signal_connect(window_, "button-press-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnButtonPress), this);
  g_signal_connect(window_, "button-release-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnButtonRelease), this);
  g_signal_connect(window_, "motion-notify-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnMotion), this);
  g_signal_connect(drawing_area_, "button-press-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnButtonPress), this);
  g_signal_connect(drawing_area_, "button-release-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnButtonRelease), this);
  g_signal_connect(drawing_area_, "motion-notify-event",
                   G_CALLBACK(DesktopLyricsOverlay::OnMotion), this);
  g_signal_connect(drawing_area_, "draw", G_CALLBACK(DesktopLyricsOverlay::OnDraw),
                   this);
  g_signal_connect(window_, "delete-event", G_CALLBACK(+[](GtkWidget*,
                                                           GdkEvent*,
                                                           gpointer) -> gboolean {
                     return TRUE;
                   }),
                   nullptr);

  gtk_widget_show_all(window_);
  gtk_widget_hide(window_);
  ApplyWindowBehavior();
  PositionNearBottomCenter(true);
  return true;
}

void DesktopLyricsOverlay::Show() {
  if (!enabled_) return;
  if (!Create()) return;
  gtk_widget_show(window_);
  PositionNearBottomCenter(false);
  g_idle_add_full(
      G_PRIORITY_DEFAULT_IDLE,
      +[](gpointer user_data) -> gboolean {
        auto* self = static_cast<DesktopLyricsOverlay*>(user_data);
        if (self != nullptr) self->PositionNearBottomCenter(false);
        return G_SOURCE_REMOVE;
      },
      this, nullptr);
  GdkWindow* gdk_window = gtk_widget_get_window(window_);
  if (gdk_window != nullptr) gdk_window_raise(gdk_window);
  ApplyWindowBehavior();
  RequestRepaint();
}

void DesktopLyricsOverlay::Hide() {
  dragging_ = false;
  if (window_ != nullptr) gtk_widget_hide(window_);
}

void DesktopLyricsOverlay::Dispose() {
  dragging_ = false;
  if (window_ != nullptr) {
    gtk_widget_destroy(window_);
    window_ = nullptr;
    drawing_area_ = nullptr;
  }
}

void DesktopLyricsOverlay::UpdateLyricFrame(const std::string& current_line,
                                            double line_progress) {
  has_frame_ = true;
  current_line_ = current_line;
  frame_line_progress_ = Clamp(line_progress, 0.0, 1.0);
  if (current_line_.empty()) {
    Hide();
    return;
  }
  if (enabled_) Show();
  RequestRepaint();
}

void DesktopLyricsOverlay::UpdateConfig(const OverlayConfig& config) {
  enabled_ = config.enabled;
  click_through_ = config.click_through;
  font_size_ = Clamp(config.font_size, 20.0, 72.0);
  opacity_ = Clamp(config.opacity, 0.25, 1.0);
  text_argb_ = config.text_argb;
  shadow_argb_ = config.shadow_argb;
  stroke_argb_ = config.stroke_argb;
  stroke_width_ = Clamp(config.stroke_width, 0.0, 6.0);
  background_argb_ = config.background_argb;
  background_radius_ = Clamp(config.background_radius, 0.0, 48.0);
  background_padding_ = Clamp(config.background_padding, 0.0, 36.0);
  text_gradient_enabled_ = config.text_gradient_enabled;
  text_gradient_start_argb_ = config.text_gradient_start_argb;
  text_gradient_end_argb_ = config.text_gradient_end_argb;
  text_gradient_angle_ = config.text_gradient_angle;
  overlay_width_ = static_cast<int>(std::round(Clamp(config.overlay_width, 480.0, 2600.0)));
  auto_overlay_height_ = config.overlay_height <= 0.0;
  if (!auto_overlay_height_) {
    overlay_height_ =
        static_cast<int>(std::round(Clamp(config.overlay_height, 90.0, 800.0)));
  } else {
    overlay_height_ = ComputeAutoOverlayHeight();
  }
  font_family_ = config.font_family.empty() ? "Sans" : config.font_family;
  text_align_ = std::max(0, std::min(2, config.text_align));
  font_weight_value_ = std::max(100, std::min(900, config.font_weight_value));

  if (!Create()) return;
  gtk_window_set_default_size(GTK_WINDOW(window_), overlay_width_, overlay_height_);
  gtk_window_resize(GTK_WINDOW(window_), overlay_width_, overlay_height_);
  gtk_widget_set_size_request(drawing_area_, overlay_width_, overlay_height_);
  ApplyWindowBehavior();
  if (!enabled_ || !has_frame_ || current_line_.empty()) {
    Hide();
    return;
  }
  Show();
}

gboolean DesktopLyricsOverlay::OnDraw(GtkWidget*,
                                      cairo_t* cr,
                                      gpointer user_data) {
  return static_cast<DesktopLyricsOverlay*>(user_data)->Draw(cr);
}

gboolean DesktopLyricsOverlay::OnButtonPress(GtkWidget*,
                                             GdkEventButton* event,
                                             gpointer user_data) {
  auto* self = static_cast<DesktopLyricsOverlay*>(user_data);
  if (self == nullptr || event == nullptr) return FALSE;
  if (self->click_through_) return FALSE;
  if (event->button != 1) return FALSE;

  if (event->type == GDK_2BUTTON_PRESS) {
    self->has_custom_position_ = false;
    self->PositionNearBottomCenter(true);
    return TRUE;
  }

  self->dragging_ = true;
  self->has_custom_position_ = true;
  gtk_window_begin_move_drag(GTK_WINDOW(self->window_), static_cast<int>(event->button),
                             static_cast<int>(std::round(event->x_root)),
                             static_cast<int>(std::round(event->y_root)),
                             event->time);
  return TRUE;
}

gboolean DesktopLyricsOverlay::OnButtonRelease(GtkWidget*,
                                               GdkEventButton* event,
                                               gpointer user_data) {
  auto* self = static_cast<DesktopLyricsOverlay*>(user_data);
  if (self == nullptr || event == nullptr) return FALSE;
  if (event->button == 1) self->dragging_ = false;
  return FALSE;
}

gboolean DesktopLyricsOverlay::OnMotion(GtkWidget*,
                                        GdkEventMotion* event,
                                        gpointer user_data) {
  auto* self = static_cast<DesktopLyricsOverlay*>(user_data);
  if (self == nullptr || event == nullptr) return FALSE;
  if (!self->dragging_ || self->click_through_) return FALSE;
  return TRUE;
}

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
    DrawTextLayer(cr, layout, text_x, text_y, area_width, static_cast<double>(text_height),
                  false, base_argb);

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
