import 'dart:async';

import 'package:flutter/material.dart';

/// If the user passes a [overlayController] to the gallery, this is used
/// to display the overlay widget.
/// The overlay is updated through a [StreamBuilder] and can fade in and out
/// when the gallery is tapped.
/// [initialData] is required when an overlay needs to be displayed as
/// soon as the gallery is opened as this is how
/// [StreamBuilder.initialData] works.
class GalleryOverlay extends StatelessWidget {
  const GalleryOverlay({
    super.key,
    required this.overlayController,
    required this.showOverlay,
    required this.opacity,
    this.initialData,
  });
  final StreamController<Widget> overlayController;
  final bool showOverlay;
  final double opacity;
  final Widget? initialData;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !showOverlay,
      child: AnimatedOpacity(
        opacity: showOverlay ? opacity : 0.0,
        duration: const Duration(milliseconds: 200),
        child: StreamBuilder<Widget?>(
          initialData: initialData,
          stream: overlayController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!;
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
