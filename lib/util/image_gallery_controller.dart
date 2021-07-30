import 'package:flutter/widgets.dart';

/// It's a replica of [PageController] and extends it as well.
/// Just a renamed version for clarity.
class ImageGalleryController extends PageController {
  ImageGalleryController({
    this.initialPage = 0,
    this.keepPage = true,
    this.viewportFraction = 1.0,
  });
  final int initialPage;
  final bool keepPage;
  final double viewportFraction;
}
