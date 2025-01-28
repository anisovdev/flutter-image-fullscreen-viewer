import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';

void main() {
  runApp(
    const ExampleApp(),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Builder(
          builder: (context) {
            final child = Hero(
              tag: 'hero',
              child: Image.network('https://placehold.co/600x400.png'),
            );

            return Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: GestureDetector(
                    onTap: () {
                      FullscreenImageViewer.open(
                        context: context,
                        child: child,
                      );
                    },
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      );
}
