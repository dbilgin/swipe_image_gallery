import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

const assets = [
  Image(image: AssetImage('assets/1.jpeg')),
  Image(image: AssetImage('assets/2.jpeg')),
];

class HeroAnimationExampleScreen extends StatefulWidget {
  const HeroAnimationExampleScreen({super.key});

  @override
  State<HeroAnimationExampleScreen> createState() =>
      _HeroAnimationExampleScreenState();
}

class _HeroAnimationExampleScreenState
    extends State<HeroAnimationExampleScreen> {
  int? currentIndex;
  final heroProperties = [
    const ImageGalleryHeroProperties(tag: 'imageId1'),
    const ImageGalleryHeroProperties(tag: 'imageId2'),
  ];
  final imageWidgets = [
    SizedBox(
      height: 125,
      width: 250,
      child: assets[0],
    ),
    SizedBox(
      height: 125,
      width: 250,
      child: assets[1],
    )
  ];

  void openGallery(int initialIndex) async {
    setState(() => currentIndex = initialIndex);
    await SwipeImageGallery(
      context: context,
      initialIndex: initialIndex,
      children: [assets[0], assets[1]],
      heroProperties: heroProperties,
      onSwipe: (index) => setState(() => currentIndex = index),
    ).show();
  }

  Widget getPlaceholder(context, heroSize, child, index) =>
      currentIndex == index ? const SizedBox(height: 125, width: 250) : child;

  Widget getFlightShuttleBuilder(animation, heroFlightDirection, index) {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed &&
          heroFlightDirection == HeroFlightDirection.pop) {
        setState(() => currentIndex = null);
      }
    });
    return imageWidgets[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Hero Animation'),
      ),
      body: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => openGallery(0),
              child: Hero(
                tag: 'imageId1',
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) =>
                    getFlightShuttleBuilder(animation, flightDirection, 0),
                placeholderBuilder: (context, heroSize, child) =>
                    getPlaceholder(context, heroSize, child, 0),
                child: currentIndex == 0
                    ? const SizedBox(
                        height: 125,
                        width: 250,
                      )
                    : imageWidgets[0],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => openGallery(1),
              child: Hero(
                tag: 'imageId2',
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) =>
                    getFlightShuttleBuilder(animation, flightDirection, 1),
                placeholderBuilder: (context, heroSize, child) =>
                    getPlaceholder(context, heroSize, child, 1),
                child: currentIndex == 1
                    ? const SizedBox(
                        height: 125,
                        width: 250,
                      )
                    : imageWidgets[1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
