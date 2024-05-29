import 'package:flutter/widgets.dart';

/// It's a replica of [PageController] and extends it as well.
/// Just a renamed version for clarity.
class ImageGalleryController extends PageController {
  ImageGalleryController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );
}
