import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/util/custom_keyboard_listener.dart';

import '../swipe_image_gallery.dart';
import '../util/custom_scroll_behavior.dart';
import 'interactive_page.dart';
import '../util/image_gallery_hero_properties.dart';

/// The [Gallery] widget is responsible of showing the images and enabling
/// swiping through images using [PageView].
class Gallery extends StatefulWidget {
  const Gallery({
    required this.initialIndex,
    required this.dismissDragDistance,
    required this.backgroundColor,
    required this.opacity,
    required this.setBackgroundOpacity,
    this.itemCount,
    this.itemBuilder,
    this.children,
    this.transitionDuration,
    this.controller,
    this.onSwipe,
    this.heroProperties,
  })  : assert(
          (children != null &&
                  children.length > 0 &&
                  itemCount == null &&
                  itemBuilder == null) ||
              (itemCount != null &&
                  itemCount > 0 &&
                  itemBuilder != null &&
                  children == null),
        ),
        assert(
          (heroProperties != null &&
                  heroProperties.length == (children?.length ?? itemCount)) ||
              heroProperties == null,
        );

  final int initialIndex;
  final int dismissDragDistance;
  final Color backgroundColor;
  final double opacity;
  final void Function(double) setBackgroundOpacity;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final List<Widget>? children;
  final int? transitionDuration;
  final PageController? controller;
  final void Function(int)? onSwipe;
  final List<ImageGalleryHeroProperties>? heroProperties;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool _scrollEnabled = true;

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
      color: widget.backgroundColor.withOpacity(widget.opacity),
      child: SafeArea(
        child: CustomKeyboardListener(
          controller: controller,
          child: PageView.builder(
            controller: controller,
            onPageChanged: widget.onSwipe,
            itemBuilder: (context, index) {
              return InteractivePage(
                child: widget.children?[index] ??
                    widget.itemBuilder!(context, index),
                setScrollEnabled: (bool enabled) =>
                    setState(() => _scrollEnabled = enabled),
                setBackgroundOpacity: widget.setBackgroundOpacity,
                dismissDragDistance: widget.dismissDragDistance,
                heroProperties: widget.heroProperties?[index] ?? null,
              );
            },
            itemCount: widget.children?.length ?? widget.itemCount,
            physics: _scrollEnabled
                ? BouncingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            scrollBehavior: CustomScrollBehavior(),
          ),
        ),
      ),
    );
  }
}
