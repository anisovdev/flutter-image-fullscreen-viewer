import 'package:flutter_test/flutter_test.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:material_ui/material_ui.dart';

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

  testWidgets(
    'tap on content keeps viewer open, tap on background closes it',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const ZoomTestApp(contentSize: Size(100, 100)),
      );
      await openViewer(widgetTester);

      await widgetTester.tap(find.byKey(ZoomTestApp.contentKey));
      await widgetTester.pumpAndSettle();
      expect(find.byKey(ZoomTestApp.contentKey), findsOneWidget);

      await widgetTester.tapAt(const Offset(20, 20));
      await widgetTester.pumpAndSettle();
      expect(find.byKey(ZoomTestApp.contentKey), findsNothing);
    },
  );

  testWidgets(
    'zoom out works with fingers outside of the initial content bounds',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const ZoomTestApp(contentSize: Size(100, 100)),
      );
      await openViewer(widgetTester);
      final center = widgetTester.getCenter(find.byType(InteractiveViewer));

      await pinch(widgetTester, center, from: 20, to: 120);
      expect(viewerScale(widgetTester), greaterThan(2));

      await pinch(widgetTester, center, from: 300, to: 60);
      expect(viewerScale(widgetTester), closeTo(1, 0.01));
    },
  );

  testWidgets(
    'zoomed content smaller than the screen stays centered',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const ZoomTestApp(contentSize: Size(100, 100)),
      );
      await openViewer(widgetTester);
      final center = widgetTester.getCenter(find.byType(InteractiveViewer));

      await pinch(widgetTester, center, from: 20, to: 120);
      await widgetTester.dragFrom(center, const Offset(300, 200));
      await widgetTester.pumpAndSettle();

      final content = widgetTester.getRect(find.byKey(ZoomTestApp.contentKey));
      expect(content.center.dx, closeTo(center.dx, 0.5));
      expect(content.center.dy, closeTo(center.dy, 0.5));
    },
  );

  testWidgets(
    'zoomed content larger than the screen does not leave empty space',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const ZoomTestApp(contentSize: Size(400, 300)),
      );
      await openViewer(widgetTester);
      final center = widgetTester.getCenter(find.byType(InteractiveViewer));

      await pinch(widgetTester, center, from: 20, to: 120);
      await widgetTester.dragFrom(center, const Offset(500, 400));
      await widgetTester.pumpAndSettle();

      final content = widgetTester.getRect(find.byKey(ZoomTestApp.contentKey));
      expect(content.left, closeTo(0, 0.5));
      expect(content.top, closeTo(0, 0.5));
    },
  );
}

Future<void> openViewer(WidgetTester tester) async {
  await tester.tap(find.byKey(ZoomTestApp.openKey));
  await tester.pumpAndSettle();
}

double viewerScale(WidgetTester tester) => tester
    .widget<InteractiveViewer>(find.byType(InteractiveViewer))
    .transformationController!
    .value
    .getMaxScaleOnAxis();

/// Moves two fingers placed symmetrically around [center] on the horizontal
/// axis from [from] to [to] pixels away from it.
Future<void> pinch(
  WidgetTester tester,
  Offset center, {
  required double from,
  required double to,
}) async {
  final first = await tester.startGesture(center - Offset(from, 0));
  final second = await tester.startGesture(center + Offset(from, 0));
  const steps = 10;
  for (var i = 1; i <= steps; i++) {
    final distance = from + (to - from) * i / steps;
    await first.moveTo(center - Offset(distance, 0));
    await second.moveTo(center + Offset(distance, 0));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await first.up();
  await second.up();
  await tester.pumpAndSettle();
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

class ZoomTestApp extends StatelessWidget {
  static const openKey = Key('open');
  static const contentKey = Key('content');

  final Size contentSize;

  const ZoomTestApp({super.key, required this.contentSize});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => GestureDetector(
              key: openKey,
              onTap: () => FullscreenImageViewer.open(
                context: context,
                child: SizedBox.fromSize(
                  key: contentKey,
                  size: contentSize,
                  child: const ColoredBox(color: Colors.blue),
                ),
              ),
              child: const SizedBox.square(
                dimension: 50,
                child: ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
