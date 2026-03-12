part of '../main.dart';

extension _DesktopLyricsDemoPagePrimarySections on _DesktopLyricsDemoPageState {
  Widget buildDemoPage({
    required BuildContext context,
    required bool enabled,
    required bool clickThrough,
    required bool gradientEnabled,
    required double fontSize,
    required double opacity,
    required double strokeWidth,
    required double overlayWidth,
    required TextAlign textAlign,
    required FontWeight fontWeight,
    required int textColor,
    required int shadowColor,
    required int strokeColor,
    required int backgroundBaseColor,
    required double backgroundOpacity,
    required int gradientStartColor,
    required int gradientEndColor,
  }) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Lyrics Full Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton(
                onPressed: _playingLineDemo ? null : _playLineDemo,
                child: const Text('Play Line Preview'),
              ),
              FilledButton(
                onPressed: _playingTokenDemo ? null : _playTokenDemo,
                child: const Text('Play Token Preview'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInteractionSection(
            enabled: enabled,
            clickThrough: clickThrough,
          ),
          _buildTextSection(
            fontSize: fontSize,
            opacity: opacity,
            strokeWidth: strokeWidth,
            textAlign: textAlign,
            fontWeight: fontWeight,
            textColor: textColor,
            shadowColor: shadowColor,
            strokeColor: strokeColor,
          ),
          _buildBackgroundSection(
            gradientEnabled: gradientEnabled,
            backgroundBaseColor: backgroundBaseColor,
            backgroundOpacity: backgroundOpacity,
            gradientStartColor: gradientStartColor,
            gradientEndColor: gradientEndColor,
          ),
          _buildLayoutSection(overlayWidth: overlayWidth),
        ],
      ),
    );
  }

  Widget _buildInteractionSection({
    required bool enabled,
    required bool clickThrough,
  }) {
    return _DemoSection(
      title: 'Interaction',
      child: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enabled'),
            value: enabled,
            onChanged: (v) async {
              await _commit(
                (config) => config.copyWith(
                  interaction: config.interaction.copyWith(enabled: v),
                ),
              );
              if (v) {
                await _lyrics.render(
                  const DesktopLyricsFrame.line(
                    currentLine: _DesktopLyricsDemoPageState._previewLine,
                    lineProgress: 1.0,
                  ),
                );
              }
            },
          ),
          SwitchListTile(
            title: const Text('Click Through'),
            value: clickThrough,
            onChanged: (v) => _commit(
              (config) => config.copyWith(
                interaction: config.interaction.copyWith(clickThrough: v),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection({
    required double fontSize,
    required double opacity,
    required double strokeWidth,
    required TextAlign textAlign,
    required FontWeight fontWeight,
    required int textColor,
    required int shadowColor,
    required int strokeColor,
  }) {
    return _DemoSection(
      title: 'Text',
      child: Column(
        children: <Widget>[
          _DemoSlider(
            label: 'Font Size',
            value: fontSize,
            min: 20,
            max: 72,
            onPreviewChanged: (v) => _preview(
              (config) =>
                  config.copyWith(text: config.text.copyWith(fontSize: v)),
            ),
            onSubmitted: (v) => _commit(
              (config) =>
                  config.copyWith(text: config.text.copyWith(fontSize: v)),
            ),
          ),
          _DemoSlider(
            label: 'Opacity',
            value: opacity,
            min: 0.25,
            max: 1,
            onPreviewChanged: (v) => _preview(
              (config) => config.copyWith(
                background: config.background.copyWith(opacity: v),
              ),
            ),
            onSubmitted: (v) => _commit(
              (config) => config.copyWith(
                background: config.background.copyWith(opacity: v),
              ),
            ),
          ),
          _DemoSlider(
            label: 'Stroke Width',
            value: strokeWidth,
            min: 0,
            max: 6,
            onPreviewChanged: (v) => _preview(
              (config) =>
                  config.copyWith(text: config.text.copyWith(strokeWidth: v)),
            ),
            onSubmitted: (v) => _commit(
              (config) =>
                  config.copyWith(text: config.text.copyWith(strokeWidth: v)),
            ),
          ),
          Row(
            children: <Widget>[
              const Expanded(child: Text('Text Align')),
              DropdownButton<TextAlign>(
                value: textAlign,
                items: const <DropdownMenuItem<TextAlign>>[
                  DropdownMenuItem(
                    value: TextAlign.start,
                    child: Text('Start'),
                  ),
                  DropdownMenuItem(
                    value: TextAlign.center,
                    child: Text('Center'),
                  ),
                  DropdownMenuItem(value: TextAlign.end, child: Text('End')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  unawaited(
                    _commit(
                      (config) => config.copyWith(
                        text: config.text.copyWith(textAlign: v),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              const Expanded(child: Text('Font Weight')),
              DropdownButton<FontWeight>(
                value: fontWeight,
                items: const <DropdownMenuItem<FontWeight>>[
                  DropdownMenuItem(value: FontWeight.w300, child: Text('w300')),
                  DropdownMenuItem(value: FontWeight.w400, child: Text('w400')),
                  DropdownMenuItem(value: FontWeight.w500, child: Text('w500')),
                  DropdownMenuItem(value: FontWeight.w600, child: Text('w600')),
                  DropdownMenuItem(value: FontWeight.w700, child: Text('w700')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  unawaited(
                    _commit(
                      (config) => config.copyWith(
                        text: config.text.copyWith(fontWeight: v),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          _DemoColorRow(
            label: 'Text Color',
            value: textColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _commit(
              (config) => config.copyWith(
                text: config.text.copyWith(textColor: Color(v)),
              ),
            ),
          ),
          _DemoColorRow(
            label: 'Shadow Color',
            value: shadowColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _commit(
              (config) => config.copyWith(
                text: config.text.copyWith(shadowColor: Color(v)),
              ),
            ),
          ),
          _DemoColorRow(
            label: 'Stroke Color',
            value: strokeColor,
            palette: _DesktopLyricsDemoPageState._palette,
            onChanged: (v) => _commit(
              (config) => config.copyWith(
                text: config.text.copyWith(strokeColor: Color(v)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
