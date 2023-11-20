library fullscreen_image_viewer;

import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_viewer.dart';

class FullscreenImageViewer {
  FullscreenImageViewer._();

  /// Child should be a Hero widget for transition animation
  static Future<void> open({
    required BuildContext context,
    required Widget child,
    Widget? closeWidget,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        pageBuilder: (context, animation, _) => FullscreenViewer(
          openAnimation: animation,
          closeWidget: closeWidget,
          child: child,
        ),
      ),
    );
  }
}
