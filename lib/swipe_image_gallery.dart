library swipe_image_gallery;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'util/image_gallery_controller.dart';
import 'util/image_gallery_hero_properties.dart';
import 'widget/gallery.dart';
import 'widget/gallery_overlay.dart';

export 'util/image_gallery_hero_properties.dart';
export 'util/image_gallery_controller.dart';

class SwipeImageGallery<T> {
  /// A scrollable, dismissable by swiping, zoomable, rotatable image gallery
  /// on which you can add a dynamic overlay.
  ///
  /// [SwipeImageGallery] utilizes [PageView] and [InteractiveViewer] for its
  /// main functionality.
  ///
  /// When showing a new gallery you can either use [images] or the
  /// [itemBuilder] and [itemCount] combination to add the images.
  ///
  /// Here's an example using the images:
  ///
  /// ```dart
  /// final assets = const [
  ///   Image(image: AssetImage('assets/1.jpeg')),
  ///   Image(image: AssetImage('assets/2.jpeg')),
  ///   Image(image: AssetImage('assets/3.jpeg')),
  ///   Image(image: AssetImage('assets/4.jpeg')),
  /// ];
  ///
  /// ...
  ///
  /// ElevatedButton(
  ///   onPressed: () => SwipeImageGallery(
  ///     context: context,
  ///     children: assets,
  ///   ).show(),
  ///   child: Text('Open Gallery With Assets'),
  /// ),
  /// ```
  ///
  /// And another example with [itemBuilder] and [itemCount].
  ///
  /// ```dart
  /// final urls = [
  ///   'https://via.placeholder.com/400',
  ///   'https://via.placeholder.com/800',
  ///   'https://via.placeholder.com/900x350',
  ///   'https://via.placeholder.com/1000',
  ///   'https://via.placeholder.com/100',
  /// ];
  ///
  /// ...
  ///
  /// ElevatedButton(
  ///   onPressed: () => SwipeImageGallery(
  ///     context: context,
  ///     itemBuilder: (context, index) {
  ///       return Image.network(urls[index]);
  ///     },
  ///     itemCount: urls.length,
  ///   ).show(),
  ///   child: Text('Open Gallery With Builder'),
  /// ),
  /// ```
  SwipeImageGallery({
    required this.context,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.hideStatusBar = true,
    this.initialIndex = 0,
    this.backgroundColor = Colors.black,
    this.dismissDragDistance = 160,
    this.scrollDirection = Axis.horizontal,
    this.transitionDuration = 400,
    this.hideOverlayOnTap = true,
    this.zoom = 8.0,
    this.backgroundOpacity = 1.0,
    this.overlayBackgroundOpacity,
    this.controller,
    this.useRootNavigator = true,
    this.onSwipe,
    this.overlayController,
    this.initialOverlay,
    this.heroProperties,
    this.reverseDirection,
    this.dragEnabled = true,
    this.useSafeArea = true,
    this.panEnabled = true,
    this.zoomEnabled = true,
  });

  /// [BuildContext] required for triggering the dialogs for the gallery.
  final BuildContext context;

  /// A list of widgets to display in the gallery if [itemBuilder]
  /// is not used.
  final List<Widget>? children;

  /// Works together with [itemCount] for building items in one method.
  /// A simple usage with a list of urls would be as below:
  /// ```dart
  /// SwipeImageGallery(
  ///   context: context,
  ///   itemBuilder: (context, index) {
  ///     return Image.network(urls[index]);
  ///   },
  ///   itemCount: urls.length,
  /// ).show()
  /// ```
  final IndexedWidgetBuilder? itemBuilder;

  /// Count of items to build with the [itemBuilder].
  final int? itemCount;

  /// Hides the status bar when the gallery opens and shows it again when
  /// it's dismissed if set to true using
  /// [SystemChrome.setEnabledSystemUIMode].
  final bool hideStatusBar;

  /// Sets the initial index of the gallery when it's first opening.
  /// Only works unless it is specifically set in the [ImageGalleryController].
  final int initialIndex;

  /// The color to show behind the displayed images.
  final Color backgroundColor;

  /// The drag distance needed before the gallery can be dismissed.
  final int dismissDragDistance;

  /// Sets the scroll direction for the gallery.
  final Axis scrollDirection;

  /// The transition duration for the animation of opening and closing
  /// the gallery.
  final int transitionDuration;

  /// Whether the overlay should be hidden when the user taps on the gallery.
  /// Works with [overlayController].
  final bool hideOverlayOnTap;

  /// Amount of zoom allowed.
  final double zoom;

  /// Background opacity between 0-1 and defaults to 1.
  final double backgroundOpacity;

  /// Overlay background opacity between 0-1 and defaults to [backgroundOpacity].
  final double? overlayBackgroundOpacity;

  /// The controller for the image gallery, extends [PageController].
  final ImageGalleryController? controller;

  /// Whether to show use the root navigator or not.
  final bool useRootNavigator;

  /// Called whenever the current image index changes.
  final void Function(int index)? onSwipe;

  /// The `overlayController` is used for adding and managing the overlay
  /// widget changes. It uses a [StreamController] so that the changes made
  /// outside of the gallery can be pushed into it and shown in the UI.
  ///
  /// See also: [initialOverlay]
  ///
  /// The widgets sent through `overlayController` will be wrapped inside a
  /// [StreamBuilder] in the [GalleryOverlay].
  ///
  /// ```dart
  /// class _ExampleState extends State<Example> {
  ///   StreamController<Widget> overlayController =
  ///         StreamController<Widget>.broadcast();
  ///
  ///   @override
  ///   void dispose() {
  ///     overlayController.close();
  ///     super.dispose();
  ///   }
  ///
  /// ...
  ///
  /// ElevatedButton(
  ///   onPressed: () {
  ///     SwipeImageGallery(
  ///       context: context,
  ///       children: remoteImages,
  ///       onSwipe: (index) {
  ///         overlayController.add(OverlayExample(
  ///           title: '${index + 1}/${remoteImages.length}',
  ///         ));
  ///       },
  ///       overlayController: overlayController,
  ///       initialOverlay: OverlayExample(
  ///         title: '1/${remoteImages.length}',
  ///       ),
  ///     ).show();
  ///   },
  ///   child: Text('Open Gallery With Overlay'),
  /// ),
  /// ```
  final StreamController<Widget>? overlayController;

  /// Used for displaying an overlay as soon as the gallery is opened.
  /// Uses the [StreamBuilder.initialData] to display the widget.
  final Widget? initialOverlay;

  /// The parameters required to initialise the hero animations.
  /// Can be sent as a list for a gallery view ui that displays more
  /// than one image before opening the fullscreen gallery.
  ///
  /// ```dart
  /// final assets = const [
  ///   Image(image: AssetImage('assets/1.jpeg')),
  ///   Image(image: AssetImage('assets/2.jpeg')),
  ///   Image(image: AssetImage('assets/3.jpeg')),
  ///   Image(image: AssetImage('assets/4.jpeg')),
  /// ];

  /// class ImageGalleryExamplesPage extends StatefulWidget {
  ///   ImageGalleryExamplesPage({Key? key, required this.title}) : super(key: key);
  ///   final String title;

  ///   @override
  ///   _ImageGalleryExamplesPageState createState() =>
  ///       _ImageGalleryExamplesPageState();
  /// }

  /// class _ImageGalleryExamplesPageState extends State<ImageGalleryExamplesPage> {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: Container(
  ///         padding: const EdgeInsets.all(16.0),
  ///         child: ListView(
  ///           children: [
  ///             const Text('Hero Animation Example'),
  ///             InkWell(
  ///              onTap: () => SwipeImageGallery(
  ///                context: context,
  ///                children: [assets[0]],
  ///                heroProperties: [
  ///                  const ImageGalleryHeroProperties(tag: 'imageId1')
  ///                ],
  ///              ).show(),
  ///              child: const Hero(
  ///                tag: 'imageId1',
  ///                child: Image(
  ///                  image: AssetImage('assets/1.jpeg'),
  ///                ),
  ///              ),
  ///            ),
  ///           ],
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  final List<ImageGalleryHeroProperties>? heroProperties;

  /// Direction the library should take when swiping.
  /// ```
  /// await SwipeImageGallery(
  ///   context: context,
  ///   children: images,
  ///   reverseDirection: true,
  /// ).show();
  /// ```
  final bool? reverseDirection;

  /// Enables drag to dismiss functionality.
  final bool dragEnabled;

  /// Enables panning around a zoomed in image.
  final bool panEnabled;

  /// Enables zooming in and out.
  final bool zoomEnabled;

  /// use SafeArea widget as image container or not.
  final bool useSafeArea;

  /// Shows the image gallery after initialisation.
  Future<T?> show() async {
    if (hideStatusBar) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    var showOverlay = true;
    double opacity = backgroundOpacity;
    double overlayOpacity = overlayBackgroundOpacity ?? backgroundOpacity;

    final content = StatefulBuilder(
      builder: (context, setState) {
        void setOpacity(double newOpacity) {
          setState(() {
            opacity = newOpacity * backgroundOpacity;
            overlayOpacity =
                newOpacity * (overlayBackgroundOpacity ?? backgroundOpacity);
          });
        }

        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (overlayController != null && hideOverlayOnTap) {
                    setState(() => showOverlay = !showOverlay);
                  }
                },
                child: Gallery(
                  itemBuilder: itemBuilder,
                  itemCount: itemCount,
                  initialIndex: initialIndex,
                  dismissDragDistance: dismissDragDistance,
                  scrollDirection: scrollDirection,
                  backgroundColor: backgroundColor,
                  transitionDuration: transitionDuration,
                  controller: controller,
                  onSwipe: onSwipe,
                  heroProperties: heroProperties,
                  opacity: opacity,
                  reverseDirection: reverseDirection,
                  setBackgroundOpacity: setOpacity,
                  dragEnabled: dragEnabled,
                  panEnabled: panEnabled,
                  zoomEnabled: zoomEnabled,
                  useSafeArea: useSafeArea,
                  children: children,
                ),
              ),
              if (overlayController != null)
                GalleryOverlay(
                  overlayController: overlayController!,
                  showOverlay: showOverlay,
                  opacity: overlayOpacity,
                  initialData: initialOverlay,
                ),
            ],
          ),
        );
      },
    );

    T? navigatorResult;

    if (heroProperties != null) {
      navigatorResult = await Navigator.of(context).push<T>(
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: true,
          fullscreenDialog: true,
          transitionDuration: Duration(milliseconds: transitionDuration),
          pageBuilder: (_, __, ___) => content,
        ),
      );
    } else {
      navigatorResult = await showGeneralDialog<T>(
        useRootNavigator: useRootNavigator,
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: transitionDuration),
        pageBuilder: (_, __, ___) => content,
      );
    }

    if (hideStatusBar) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    return navigatorResult;
  }
}
