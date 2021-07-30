import 'package:flutter/material.dart';

import '../util/image_gallery_hero_parameters.dart';

/// With [InteractiveViewer] and [GestureDetector] this creates a
/// widget that can be zoomed and swiped away.
/// It also supports double tap for zooming in and out.
class InteractivePage extends StatefulWidget {
  const InteractivePage({
    required this.child,
    required this.setScrollEnabled,
    required this.dismissDragDistance,
    required this.setBackgroundOpacity,
    this.heroParameters,
  });

  final Widget child;
  final void Function(bool) setScrollEnabled;
  final int dismissDragDistance;
  final void Function(double) setBackgroundOpacity;
  final ImageGalleryHeroParameters? heroParameters;

  @override
  _InteractivePageState createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  final transformationController = TransformationController();
  late AnimationController _zoomAnimationController;
  late AnimationController _zoomOutAnimationController;

  bool _zoomed = false;
  Offset _dragPosition = Offset(0.0, 0.0);

  void transformListener() {
    final scale = transformationController.value.row0.r;

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
    transformationController.addListener(transformListener);
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _zoomOutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    transformationController.removeListener(transformListener);
    super.dispose();
  }

  void animateZoom({
    required Matrix4 end,
    required AnimationController animationController,
  }) {
    final _mapAnimation = Matrix4Tween(
      begin: transformationController.value,
      end: end,
    ).animate(animationController);

    void animationListener() {
      transformationController.value = _mapAnimation.value;

      if (transformationController.value == end) {
        _mapAnimation.removeListener(animationListener);
      }
    }

    _mapAnimation.addListener(animationListener);

    animationController.forward();
  }

  void doubleTapDownHandler(TapDownDetails details) {
    if (_zoomed) {
      final defaultMatrix = Matrix4.diagonal3Values(1, 1, 1);

      animateZoom(
        animationController: _zoomOutAnimationController,
        end: defaultMatrix,
      );
    } else {
      final x = -details.localPosition.dx;
      final y = -details.localPosition.dy;
      final scaleMultiplier = 2.0;

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

  void onVerticalDragEndHandler(DragEndDetails details) {
    double pixelsPerSecond = _dragPosition.dy.abs();
    if (pixelsPerSecond > (widget.dismissDragDistance)) {
      Navigator.pop(context);
    } else {
      setState(() => _dragPosition = Offset(0.0, 0.0));
      widget.setBackgroundOpacity(1.0);
    }
  }

  void onVerticalDragUpdateHandler(DragUpdateDetails details) {
    setState(
        () => _dragPosition = Offset(0.0, _dragPosition.dy + details.delta.dy));

    final ratio = 1 - (_dragPosition.dy.abs() / widget.dismissDragDistance);
    widget.setBackgroundOpacity(ratio > 0 ? ratio : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            left: _dragPosition.dx,
            top: _dragPosition.dy,
            bottom: -_dragPosition.dy,
            right: -_dragPosition.dx,
            child: GestureDetector(
              onVerticalDragUpdate:
                  !_zoomed ? onVerticalDragUpdateHandler : null,
              onVerticalDragEnd: !_zoomed ? onVerticalDragEndHandler : null,
              onDoubleTapDown: doubleTapDownHandler,
              onDoubleTap: onDoubleTap,
              child: InteractiveViewer(
                maxScale: 8.0,
                transformationController: transformationController,
                child: widget.heroParameters != null
                    ? Hero(
                        tag: widget.heroParameters!.tag,
                        createRectTween: widget.heroParameters!.createRectTween,
                        flightShuttleBuilder:
                            widget.heroParameters!.flightShuttleBuilder,
                        placeholderBuilder:
                            widget.heroParameters!.placeholderBuilder,
                        transitionOnUserGestures:
                            widget.heroParameters!.transitionOnUserGestures,
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
