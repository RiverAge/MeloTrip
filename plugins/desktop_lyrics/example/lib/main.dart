import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Desktop Lyrics Example')),
        body: Center(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: () => DesktopLyrics.instance.show(),
                child: const Text('Show'),
              ),
              FilledButton(
                onPressed: () => DesktopLyrics.instance.hide(),
                child: const Text('Hide'),
              ),
              FilledButton(
                onPressed: () => DesktopLyrics.instance.render(
                  const DesktopLyricsFrame.line(currentLine: 'Hello Desktop Lyrics'),
                ),
                child: const Text('Render'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
