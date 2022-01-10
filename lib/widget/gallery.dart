import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/widget/gallery_item.dart';

import '../swipe_image_gallery.dart';
import '../util/image_gallery_hero_properties.dart';
import 'interactive_page.dart';

/// The [Gallery] widget is responsible of showing the images and enabling
/// swiping through images using [PageView].
class Gallery extends StatefulWidget {
  const Gallery({
    required this.initialIndex,
    required this.dismissDragDistance,
    required this.backgroundColor,
    this.itemCount,
    this.itemBuilder,
    this.galleryItems,
    this.transitionDuration,
    this.controller,
    this.onSwipe,
    this.heroProperties,
  })  : assert(
          (galleryItems != null &&
                  galleryItems.length > 0 &&
                  itemCount == null &&
                  itemBuilder == null) ||
              (itemCount != null &&
                  itemCount > 0 &&
                  itemBuilder != null &&
                  galleryItems == null),
        ),
        assert(
          (heroProperties != null &&
                  heroProperties.length ==
                      (galleryItems?.length ?? itemCount)) ||
              heroProperties == null,
        );

  final int initialIndex;
  final int dismissDragDistance;
  final Color backgroundColor;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final List<GalleryItem>? galleryItems;
  final int? transitionDuration;
  final PageController? controller;
  final void Function(int)? onSwipe;
  final List<ImageGalleryHeroProperties>? heroProperties;

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
            return InteractivePage(
              child: widget.galleryItems?[index] ??
                  GalleryItem(child: widget.itemBuilder!(context, index)),
              setScrollEnabled: (bool enabled) =>
                  setState(() => _scrollEnabled = enabled),
              setBackgroundOpacity: (double opacity) =>
                  setState(() => _opacity = opacity),
              dismissDragDistance: widget.dismissDragDistance,
              heroProperties: widget.heroProperties?[index] ?? null,
            );
          },
          itemCount: widget.galleryItems?.length ?? widget.itemCount,
          physics: _scrollEnabled
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
