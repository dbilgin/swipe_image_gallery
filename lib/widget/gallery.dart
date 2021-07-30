import 'package:flutter/material.dart';

import '../swipe_image_gallery.dart';
import 'interactive_image.dart';
import '../util/image_gallery_hero_parameters.dart';

/// The [Gallery] widget is responsible of showing the images and enabling
/// swiping through images using [PageView].
class Gallery extends StatefulWidget {
  const Gallery({
    required this.initialIndex,
    required this.dismissDragDistance,
    required this.backgroundColor,
    this.itemCount,
    this.itemBuilder,
    this.images,
    this.transitionDuration,
    this.controller,
    this.onSwipe,
    this.heroParameters,
  })  : assert(
          (images != null &&
                  images.length > 0 &&
                  itemCount == null &&
                  itemBuilder == null) ||
              (itemCount != null &&
                  itemCount > 0 &&
                  itemBuilder != null &&
                  images == null),
        ),
        assert(
          (heroParameters != null &&
                  heroParameters.length == (images?.length ?? itemCount)) ||
              heroParameters == null,
        );

  final int initialIndex;
  final int dismissDragDistance;
  final Color backgroundColor;
  final IndexedImageBuilder? itemBuilder;
  final int? itemCount;
  final List<Image>? images;
  final int? transitionDuration;
  final PageController? controller;
  final void Function(int)? onSwipe;
  final List<ImageGalleryHeroParameters>? heroParameters;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool _scrollEnabled = true;
  double _opacity = 1.0;

  late PageController controller;

  @override
  void initState() {
    controller =
        widget.controller ?? PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor.withOpacity(_opacity),
      child: SafeArea(
        child: PageView.builder(
          controller: controller,
          onPageChanged: widget.onSwipe,
          itemBuilder: (context, index) {
            return InteractiveImage(
              image:
                  widget.images?[index] ?? widget.itemBuilder!(context, index),
              setScrollEnabled: (bool enabled) =>
                  setState(() => _scrollEnabled = enabled),
              setBackgroundOpacity: (double opacity) =>
                  setState(() => _opacity = opacity),
              dismissDragDistance: widget.dismissDragDistance,
              heroParameters: widget.heroParameters?[index] ?? null,
            );
          },
          itemCount: widget.images?.length ?? widget.itemCount,
          physics: _scrollEnabled
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}