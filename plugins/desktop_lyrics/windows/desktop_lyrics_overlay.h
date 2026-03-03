#ifndef FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
#define FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_

#include <windows.h>

#include <cstdint>
#include <string>
#include <vector>

namespace desktop_lyrics {

struct LyricsLineEntry {
  int64_t start_ms;
  std::wstring text;
};

class DesktopLyricsOverlay {
 public:
  DesktopLyricsOverlay();
  ~DesktopLyricsOverlay();

  bool Create();
  void Show();
  void Hide();
  void Dispose();

  void UpdateTrack(const std::wstring& title,
                   const std::wstring& artist,
                   const std::vector<LyricsLineEntry>& lines);
  void UpdateProgress(int64_t position_ms, int64_t duration_ms);
  void UpdateConfig(bool enabled,
                    bool click_through,
                    double font_size,
                    double opacity,
                    uint32_t text_argb,
                    uint32_t shadow_argb,
                    uint32_t stroke_argb,
                    double stroke_width);

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
  bool UpdateCurrentLineByPosition();
  void RequestRepaint();
  void ApplyWindowStyles();
  void ApplyLayeredOpacity();

  HWND hwnd_ = nullptr;
  std::wstring title_;
  std::wstring artist_;
  std::wstring current_line_;
  std::vector<LyricsLineEntry> lines_;
  int64_t position_ms_ = 0;
  int64_t duration_ms_ = 0;
  bool enabled_ = false;
  bool click_through_ = true;
  double font_size_ = 34.0;
  double opacity_ = 0.93;
  bool has_custom_position_ = false;
  bool dragging_ = false;
  POINT drag_start_cursor_{};
  POINT drag_start_window_{};
  uint32_t text_argb_ = 0xFFF2F2F8;
  uint32_t shadow_argb_ = 0xFF121214;
  uint32_t stroke_argb_ = 0x00000000;
  double stroke_width_ = 0.0;
};

}  // namespace desktop_lyrics

#endif  // FLUTTER_PLUGIN_DESKTOP_LYRICS_OVERLAY_H_
