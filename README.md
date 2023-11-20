# Flutter Fullscreen Image Viewer

A Flutter package that provides a customizable fullscreen image viewer with zoom and drag-to-dismiss features.

## Features

- **Zoom:** Pinch to zoom in and out of images for a closer look.
- **Drag to Dismiss:** Swipe down to dismiss the fullscreen image view.

## Getting Started

To use this package, add `fullscreen_image_viewer` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  fullscreen_image_viewer: ^0.0.1
```

Then run:

```bash
$ flutter pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
```

To open the fullscreen image viewer, simply call the `open` method and pass the list of image URLs:

```dart
FullscreenImageViewer.open(
  context: context,
  child: Hero(
    tag: 'hero', 
    child: Image.network('url.png'),
  ),
);
```

## Issues and Feedback

Please report any issues or provide feedback on the [GitHub repository](https://github.com/anisovdev/flutter-image-fullscreen-viewer).

## Acknowledgments

- Inspired by other Flutter image viewer packages.
- Special thanks to the Flutter community.

Feel free to contribute to the project and make it even better!
