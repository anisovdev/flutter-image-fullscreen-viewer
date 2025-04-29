import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/src/fullscreen_viewer.dart';

class FullscreenImageViewer {
  FullscreenImageViewer._();

  /// [child] should be a Hero widget for transition animation
  /// [closeWidget] is content of button at top right corner that closes viewer
  static Future<void> open({
    required BuildContext context,
    required Widget child,
    Widget? closeWidget,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        pageBuilder: (context, animation, _) => FullscreenViewer(
          barrierDismissible: barrierDismissible,
          openAnimation: animation,
          closeWidget: closeWidget,
          child: child,
        ),
      ),
    );
  }
}
