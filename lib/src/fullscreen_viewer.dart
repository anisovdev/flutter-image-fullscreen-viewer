import 'dart:math';

import 'package:flutter/widgets.dart';

class FullscreenViewer extends StatefulWidget {
  final Animation<double> openAnimation;
  final Widget? closeWidget;
  final Widget child;
  final bool barrierDismissible;

  const FullscreenViewer({
    super.key,
    required this.openAnimation,
    required this.child,
    this.closeWidget,
    required this.barrierDismissible,
  });

  @override
  State<FullscreenViewer> createState() => _FullscreenViewerState();
}

class _FullscreenViewerState extends State<FullscreenViewer>
    with TickerProviderStateMixin {
  double get dragCoef =>
      min(1, (min(deltaController.value.abs(), 50) - 50).abs() / 50);

  double get scale => transformController.value.getMaxScaleOnAxis();
  late final deltaController = AnimationController(
    vsync: this,
    upperBound: 300,
    lowerBound: -300,
    value: 0,
    duration: const Duration(milliseconds: 300),
  );

  final transformController = TransformationController();
  final _sceneKey = GlobalKey();
  final _contentKey = GlobalKey();

  bool get scaled => (scale - 1).abs() > 0.01;
  bool canPop = true;

  @override
  void initState() {
    super.initState();
    transformController.addListener(_keepContentInView);
  }

  @override
  void dispose() {
    deltaController.dispose();
    transformController.dispose();
    super.dispose();
  }

  /// [InteractiveViewer] spans the whole screen so that gestures are caught
  /// outside of the content too, but then it only limits panning to the screen.
  /// This keeps the content covering the screen, or centered when it is smaller.
  void _keepContentInView() {
    final scene = _sceneKey.currentContext?.findRenderObject() as RenderBox?;
    final content =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (scene == null ||
        content == null ||
        !scene.hasSize ||
        !content.hasSize) {
      return;
    }

    final rect =
        content.localToGlobal(Offset.zero, ancestor: scene) & content.size;
    final matrix = transformController.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    double clampAxis(
      double value,
      double start,
      double extent,
      double viewport,
    ) {
      final scaledExtent = extent * scale;
      if (scaledExtent <= viewport) {
        return (viewport - scaledExtent) / 2 - start * scale;
      }
      return value.clamp(viewport - (start + extent) * scale, -start * scale);
    }

    final x =
        clampAxis(translation.x, rect.left, rect.width, scene.size.width);
    final y =
        clampAxis(translation.y, rect.top, rect.height, scene.size.height);
    if (x == translation.x && y == translation.y) return;

    transformController.value = matrix.clone()
      ..setTranslationRaw(x, y, translation.z);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: deltaController,
          builder: (context, child) => AnimatedBuilder(
            animation: widget.openAnimation,
            builder: (context, _) => GestureDetector(
              onTap: widget.barrierDismissible
                  ? () => Navigator.pop(context)
                  : null,
              child: ColoredBox(
                color: Color.fromRGBO(
                  0,
                  0,
                  0,
                  0.7 * widget.openAnimation.value * dragCoef,
                ),
                child: Transform.translate(
                  offset: Offset(0, deltaController.value),
                  child: child,
                ),
              ),
            ),
          ),
          child: InteractiveViewer(
            minScale: 1,
            transformationController: transformController,
            onInteractionEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy.abs() +
                          deltaController.value.abs() >
                      50 &&
                  !scaled &&
                  canPop) {
                Navigator.pop(context);
              } else {
                deltaController.animateTo(0.0);
              }

              if (details.pointerCount == 0) {
                canPop = true;
              }
            },
            onInteractionUpdate: (details) {
              if (details.pointerCount > 1) {
                canPop = false;
              }
              if (!scaled && canPop) {
                deltaController.value += details.focalPointDelta.dy;
              }
            },
            clipBehavior: Clip.none,
            child: Center(
              key: _sceneKey,
              child: GestureDetector(
                key: _contentKey,
                // To prevent dismiss when onTap on content
                onTap: () {},
                child: widget.child,
              ),
            ),
          ),
        ),
        if (widget.closeWidget != null)
          Positioned(
            top: 8,
            right: 8,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: widget.closeWidget,
              ),
            ),
          ),
      ],
    );
  }
}
