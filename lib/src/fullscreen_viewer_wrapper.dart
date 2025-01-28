import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/src/fullscreen_image_viewer.dart';

/// Simple widget wrapper to use [FullscreenImageViewer]
class FullscreenViewerWrapper extends StatelessWidget {
  /// Tag that will be provided to [Hero] widget
  final String heroTag;

  /// [Widget] that you would to fullscreen view
  final Widget child;

  /// Icon that can hide fullscreen widget
  final Widget? closeIcon;

  const FullscreenViewerWrapper({
    super.key,
    required this.heroTag,
    required this.child,
    this.closeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final child = Hero(
      tag: heroTag,
      child: this.child,
    );

    return GestureDetector(
      onTap: () => FullscreenImageViewer.open(
        context: context,
        child: child,
        closeWidget: closeIcon,
      ),
      child: child,
    );
  }
}
