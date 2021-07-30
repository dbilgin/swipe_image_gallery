import 'package:flutter/widgets.dart';

/// Replicates the properties inside the [Hero] widget and is used for
/// passing them to the images inside the gallery.
class ImageGalleryHeroParameters {
  const ImageGalleryHeroParameters({
    Key? key,
    required this.tag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,
  });
  final Object tag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool transitionOnUserGestures;
}
