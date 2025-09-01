import 'package:flutter/widgets.dart';

/// It's a replica of [PageController] and extends it as well.
/// Just a renamed version for clarity.
class ImageGalleryController extends PageController {
  ImageGalleryController({
    super.initialPage,
    super.keepPage,
    super.viewportFraction,
  });
}
