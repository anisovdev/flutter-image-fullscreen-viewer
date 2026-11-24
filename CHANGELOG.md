# Changelog

All notable changes to this project will be documented in this file.
## [1.3.0] - 2026-11-24
- Fixed zooming out with two fingers placed outside of the initial image bounds: the viewer now handles gestures over the whole screen ([#3](https://github.com/anisovdev/flutter-image-fullscreen-viewer/issues/3)).
- Zoomed image is kept inside the screen while panning: it covers the screen or stays centered when it is smaller.
- The package no longer imports `package:flutter/material.dart` and works with both `material_ui` and the legacy Material library.
- Example migrated to `material_ui`.

## [1.2.0] - 2025-01-28
- Fixed issue where tapping on the image content unintentionally popped the page.
- Fixed bug preventing zoom-out after maximum zoom-in with two fingers.

## [1.1.0] - 2025-01-28
- Added FullscreenViewerWrapper to make using package more simple
- Remove deprecated members

## [1.0.2] - 2025-01-28
- Show preview as gif in README.md

## [1.0.0] - 2025-01-28
- Add Preview video to README.md
- Create example project

## [0.0.6] - 2023-11-22
- Format code

## [0.0.5] - 2023-11-21
- Correct shadow color

## [0.0.4] - 2023-11-20
- Format code
- Update comments

## [0.0.3] - 2023-11-20
- Update README.md

## [0.0.2] - 2023-11-20
- Add supported platforms

## [0.0.1] - 2023-11-20
- Initial release of the Flutter Fullscreen Image Viewer package.
- Features:
    - Zoom in and out of images.
    - Swipe to dismiss.
- Usage documented in the README.md file.
- Example directory with a sample implementation.
- Issues and feedback can be reported on the [GitHub repository](https://github.com/anisovdev/flutter-image-fullscreen-viewer).

This changelog follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.