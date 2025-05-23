import 'dart:math';

import 'package:flutter/material.dart';

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

  bool get scaled => (scale - 1).abs() > 0.01;
  bool canPop = true;

  @override
  void dispose() {
    deltaController.dispose();
    transformController.dispose();
    super.dispose();
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
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.7 * widget.openAnimation.value * dragCoef,
                ),
                child: Transform.translate(
                  offset: Offset(0, deltaController.value),
                  child: child,
                ),
              ),
            ),
          ),
          child: Center(
            child: GestureDetector(
              // To prevent dismiss when onTap on content
              onTap: () {},
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
