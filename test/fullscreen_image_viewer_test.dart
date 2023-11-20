import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';

void main() {
  testWidgets(
    'drag to close success',
    (widgetTester) async {
      const firstWidgetText = "123";
      const secondWidgetText = "321";

      await widgetTester.pumpWidget(const TestApp(
        firstWidgetText: firstWidgetText,
        secondWidgetText: secondWidgetText,
      ));

      final firstFinder = find.text(firstWidgetText);
      final secondFinder = find.text(secondWidgetText);

      expect(firstFinder, findsOneWidget);
      expect(secondFinder, findsNothing);

      await widgetTester.tap(firstFinder);
      await widgetTester.pumpAndSettle();

      expect(secondFinder, findsOneWidget);
      await widgetTester.drag(
        secondFinder,
        const Offset(0, 100),
      );

      await widgetTester.pumpAndSettle();
      expect(secondFinder, findsNothing);
    },
  );

  testWidgets(
    'drag to close not enough',
    (widgetTester) async {
      const firstWidgetText = "123";
      const secondWidgetText = "321";

      await widgetTester.pumpWidget(const TestApp(
        firstWidgetText: firstWidgetText,
        secondWidgetText: secondWidgetText,
      ));

      final firstFinder = find.text(firstWidgetText);
      final secondFinder = find.text(secondWidgetText);

      expect(firstFinder, findsOneWidget);
      expect(secondFinder, findsNothing);

      await widgetTester.tap(firstFinder);
      await widgetTester.pumpAndSettle();

      expect(secondFinder, findsOneWidget);
      await widgetTester.drag(
        secondFinder,
        const Offset(0, 30),
      );

      await widgetTester.pumpAndSettle();
      expect(secondFinder, findsOneWidget);
    },
  );

  testWidgets(
    'test close widget',
    (widgetTester) async {
      const firstWidgetText = "123";
      const secondWidgetText = "321";

      await widgetTester.pumpWidget(const TestApp(
        firstWidgetText: firstWidgetText,
        secondWidgetText: secondWidgetText,
      ));

      final firstFinder = find.text(firstWidgetText);
      final secondFinder = find.text(secondWidgetText);

      expect(firstFinder, findsOneWidget);
      expect(secondFinder, findsNothing);

      await widgetTester.tap(firstFinder);
      await widgetTester.pumpAndSettle();

      final buttonFinder = find.byIcon(Icons.close);
      expect(buttonFinder, findsOneWidget);
      await widgetTester.tap(buttonFinder);
      await widgetTester.pumpAndSettle();

      expect(secondFinder, findsNothing);
    },
  );
}

class TestApp extends StatelessWidget {
  final String firstWidgetText;
  final String secondWidgetText;

  const TestApp({
    super.key,
    required this.firstWidgetText,
    required this.secondWidgetText,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                FullscreenImageViewer.open(
                  context: context,
                  child: Hero(
                    tag: 'hero',
                    child: Text(secondWidgetText),
                  ),
                  closeWidget: const Icon(Icons.close),
                );
              },
              child: Hero(
                tag: 'hero',
                child: Text(firstWidgetText),
              ),
            );
          }),
        ),
      ),
    );
  }
}
