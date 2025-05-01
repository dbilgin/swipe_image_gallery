import 'package:flutter/material.dart';

import '../util/image_gallery_hero_properties.dart';

/// With [InteractiveViewer] and [GestureDetector] this creates a
/// widget that can be zoomed and swiped away.
/// It also supports double tap for zooming in and out.
class InteractivePage extends StatefulWidget {
  const InteractivePage({
    Key? key,
    required this.child,
    required this.setScrollEnabled,
    required this.dismissDragDistance,
    required this.setBackgroundOpacity,
    required this.scrollDirection,
    required this.dragEnabled,
    required this.panEnabled,
    required this.zoomEnabled,
    this.heroProperties,
  }) : super(key: key);

  final Widget child;
  final void Function(bool) setScrollEnabled;
  final int dismissDragDistance;
  final void Function(double) setBackgroundOpacity;
  final Axis scrollDirection;
  final bool dragEnabled;
  final bool panEnabled;
  final bool zoomEnabled;
  final ImageGalleryHeroProperties? heroProperties;

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  final _transformationController = TransformationController();
  late AnimationController _zoomAnimationController;
  late AnimationController _translateToCenterController;
  late AnimationController _zoomOutAnimationController;

  bool _zoomed = false;
  Offset _dragPosition = const Offset(0.0, 0.0);

  void transformListener() {
    final scale = _transformationController.value.row0.r;

    if (scale > 1 && !_zoomed) {
      setState(() => _zoomed = true);
      widget.setScrollEnabled(false);
      _zoomOutAnimationController.reset();
    } else if (scale <= 1 && _zoomed) {
      setState(() => _zoomed = false);
      widget.setScrollEnabled(true);
      _zoomAnimationController.reset();
    }
  }

  @override
  void initState() {
    _transformationController.addListener(transformListener);
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _zoomOutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _translateToCenterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _zoomAnimationController.dispose();
    _zoomOutAnimationController.dispose();
    _translateToCenterController.dispose();
    super.dispose();
  }

  void animateDragPosition(double offsetY) {
    final offsetTween = Tween<double>(begin: offsetY, end: 0)
        .animate(_translateToCenterController);
    void animationListener() {
      setState(() {
        _dragPosition = widget.scrollDirection == Axis.horizontal
            ? Offset(0, offsetTween.value)
            : Offset(offsetTween.value, 0);
      });
      if (_translateToCenterController.isCompleted) {
        offsetTween.removeListener(animationListener);
      }
    }

    offsetTween.addListener(animationListener);
    _translateToCenterController.forward();
  }

  void animateZoom({
    required Matrix4 end,
    required AnimationController animationController,
  }) {
    final mapAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: end,
    ).animate(animationController);

    void animationListener() {
      _transformationController.value = mapAnimation.value;

      if (_transformationController.value == end) {
        mapAnimation.removeListener(animationListener);
      }
    }

    mapAnimation.addListener(animationListener);

    animationController.forward();
  }

  void doubleTapDownHandler(TapDownDetails details) {
    if (!widget.zoomEnabled) {
      return;
    }

    if (_zoomed) {
      final defaultMatrix = Matrix4.diagonal3Values(1, 1, 1);

      animateZoom(
        animationController: _zoomOutAnimationController,
        end: defaultMatrix,
      );
    } else {
      final x = -details.localPosition.dx;
      final y = -details.localPosition.dy;
      const scaleMultiplier = 2.0;

      final zoomedMatrix = Matrix4(
        scaleMultiplier, 0.0, 0.0, 0, //
        0.0, scaleMultiplier, 0.0, 0, //
        0.0, 0.0, 1.0, 0.0, //
        x, y, 0.0, 1.0, //
      );

      animateZoom(
        animationController: _zoomAnimationController,
        end: zoomedMatrix,
      );
    }
  }

  /// Required for `onDoubleTapDown` to work
  void onDoubleTap() {}

  void onDragEndHandler(DragEndDetails details) {
    final dragPositionDirection = widget.scrollDirection == Axis.horizontal
        ? _dragPosition.dy
        : _dragPosition.dx;
    double pixelsPerSecond = dragPositionDirection.abs();
    if (pixelsPerSecond > (widget.dismissDragDistance)) {
      Navigator.pop(context);
    } else {
      widget.setBackgroundOpacity(1.0);
      animateDragPosition(dragPositionDirection);
    }
  }

  void onDragUpdateHandler(DragUpdateDetails details) {
    setState(
      () => _dragPosition = widget.scrollDirection == Axis.horizontal
          ? Offset(0.0, _dragPosition.dy + details.delta.dy)
          : Offset(_dragPosition.dx + details.delta.dx, 0.0),
    );

    final dragPositionDirection = widget.scrollDirection == Axis.horizontal
        ? _dragPosition.dy
        : _dragPosition.dx;
    final ratio =
        1 - (dragPositionDirection.abs() / widget.dismissDragDistance);
    widget.setBackgroundOpacity(ratio > 0 ? ratio : 0);
  }

  @override
  Widget build(BuildContext context) {
    final heroProps = widget.heroProperties;

    return Center(
      child: Stack(
        children: [
          Positioned(
            left: _dragPosition.dx,
            top: _dragPosition.dy,
            bottom: -_dragPosition.dy,
            right: -_dragPosition.dx,
            child: GestureDetector(
              onVerticalDragStart: _zoomed ||
                      widget.scrollDirection == Axis.vertical ||
                      !widget.dragEnabled
                  ? null
                  : (_) {
                      _translateToCenterController.reset();
                    },
              onVerticalDragUpdate: _zoomed ||
                      widget.scrollDirection == Axis.vertical ||
                      !widget.dragEnabled
                  ? null
                  : onDragUpdateHandler,
              onVerticalDragEnd: _zoomed ||
                      widget.scrollDirection == Axis.vertical ||
                      !widget.dragEnabled
                  ? null
                  : onDragEndHandler,
              onHorizontalDragStart: _zoomed ||
                      widget.scrollDirection == Axis.horizontal ||
                      !widget.dragEnabled
                  ? null
                  : (_) {
                      _translateToCenterController.reset();
                    },
              onHorizontalDragUpdate: _zoomed ||
                      widget.scrollDirection == Axis.horizontal ||
                      !widget.dragEnabled
                  ? null
                  : onDragUpdateHandler,
              onHorizontalDragEnd: _zoomed ||
                      widget.scrollDirection == Axis.horizontal ||
                      !widget.dragEnabled
                  ? null
                  : onDragEndHandler,
              onDoubleTapDown: doubleTapDownHandler,
              onDoubleTap: onDoubleTap,
              child: InteractiveViewer(
                maxScale: 8.0,
                transformationController: _transformationController,
                panEnabled: widget.panEnabled,
                scaleEnabled: widget.zoomEnabled,
                child: heroProps != null
                    ? Hero(
                        tag: heroProps.tag,
                        createRectTween: heroProps.createRectTween,
                        flightShuttleBuilder: heroProps.flightShuttleBuilder,
                        placeholderBuilder: heroProps.placeholderBuilder,
                        transitionOnUserGestures:
                            heroProps.transitionOnUserGestures,
                        child: widget.child,
                      )
                    : widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
