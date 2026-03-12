part of '../main.dart';

extension _DesktopLyricsDemoPageSecondarySections
    on _DesktopLyricsDemoPageState {
  Widget _buildBackgroundSection({
    required bool gradientEnabled,
    required int backgroundBaseColor,
    required double backgroundOpacity,
    required int gradientStartColor,
    required int gradientEndColor,
  }) {
    return _DemoSection(
      title: 'Background & Gradient',
      child: Column(
        children: <Widget>[
          _DemoColorRow(
            label: 'Background Base',
            value: backgroundBaseColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _apply((config) {
              final a =
                  ((config.background.backgroundColor?.toARGB32() ??
                          0x7A220A35) >>
                      24) &
                  0xFF;
              final bg = (a << 24) | (v & 0x00FFFFFF);
              return config.copyWith(
                background: config.background.copyWith(
                  backgroundColor: Color(bg),
                ),
              );
            }),
          ),
          _DemoSlider(
            label: 'Background Opacity',
            value: backgroundOpacity,
            min: 0,
            max: 1,
            onChanged: (v) => _apply((config) {
              final rgb =
                  (config.background.backgroundColor?.toARGB32() ??
                      0x7A220A35) &
                  0x00FFFFFF;
              final bg = ((255 * v).round() << 24) | rgb;
              return config.copyWith(
                background: config.background.copyWith(
                  backgroundColor: Color(bg),
                ),
              );
            }),
          ),
          SwitchListTile(
            title: const Text('Text Gradient'),
            value: gradientEnabled,
            onChanged: (v) => _apply(
              (config) => config.copyWith(
                gradient: config.gradient.copyWith(textGradientEnabled: v),
              ),
            ),
          ),
          _DemoColorRow(
            label: 'Gradient Start',
            value: gradientStartColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _apply(
              (config) => config.copyWith(
                gradient: config.gradient.copyWith(
                  textGradientStartColor: Color(v),
                ),
              ),
            ),
          ),
          _DemoColorRow(
            label: 'Gradient End',
            value: gradientEndColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _apply(
              (config) => config.copyWith(
                gradient: config.gradient.copyWith(
                  textGradientEndColor: Color(v),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSection({required double overlayWidth}) {
    return _DemoSection(
      title: 'Layout',
      child: Column(
        children: <Widget>[
          _DemoSlider(
            label: 'Overlay Width',
            value: overlayWidth,
            min: 480,
            max: 1800,
            onChanged: (v) => _apply(
              (config) => config.copyWith(
                layout: config.layout.copyWith(overlayWidth: v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
