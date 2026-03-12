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
  if (pending_show_idle_source_id_ != 0) {
    g_source_remove(pending_show_idle_source_id_);
    pending_show_idle_source_id_ = 0;
  }
  pending_show_idle_source_id_ = g_idle_add_full(
      G_PRIORITY_DEFAULT_IDLE,
      +[](gpointer user_data) -> gboolean {
        auto* self = static_cast<DesktopLyricsOverlay*>(user_data);
        if (self == nullptr) return G_SOURCE_REMOVE;
        self->pending_show_idle_source_id_ = 0;
        if (self->window_ != nullptr) self->PositionNearBottomCenter(false);
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
  if (pending_show_idle_source_id_ != 0) {
    g_source_remove(pending_show_idle_source_id_);
    pending_show_idle_source_id_ = 0;
  }
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
  opacity_ = Clamp(config.opacity, 0.0, 1.0);
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

}  // namespace desktop_lyrics
