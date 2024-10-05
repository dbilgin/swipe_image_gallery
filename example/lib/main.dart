import 'dart:async';

import 'package:example/multi_hero_animation_screen.dart';
import 'package:example/overlay_example.dart';
import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

void main() {
  runApp(const ImageGalleryExampleApp());
}

class ImageGalleryExampleApp extends StatelessWidget {
  const ImageGalleryExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageGalleryExamplesPage(
        title: 'Image Gallery Demo Home Page',
      ),
    );
  }
}

final urls = [
  'https://picsum.photos/400?image=9',
  'https://picsum.photos/800?image=1',
  'https://picsum.photos/900/350?image=2',
  'https://picsum.photos/1000?image=7',
  'https://picsum.photos/100?image=4',
];

final remoteImages = [
  Image.network('https://picsum.photos/400?image=9'),
  Image.network('https://picsum.photos/800?image=1'),
  Image.network('https://picsum.photos/900/350?image=2'),
  Image.network('https://picsum.photos/1000?image=7'),
  Image.network('https://picsum.photos/100?image=4'),
];

const assets = [
  Image(image: AssetImage('assets/1.jpeg')),
  Image(image: AssetImage('assets/2.jpeg')),
  Image(image: AssetImage('assets/3.jpeg')),
  Image(image: AssetImage('assets/4.jpeg')),
];

final widgets = [
  Container(
    color: Colors.white,
    child: const Center(
      child: Text('First Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
  Container(
    color: Colors.grey,
    child: const Center(
      child: Text('Second Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
];

class ImageGalleryExamplesPage extends StatefulWidget {
  const ImageGalleryExamplesPage({super.key, required this.title});
  final String title;

  @override
  State<ImageGalleryExamplesPage> createState() =>
      _ImageGalleryExamplesPageState();
}

class _ImageGalleryExamplesPageState extends State<ImageGalleryExamplesPage> {
  ImageGalleryController galleryController =
      ImageGalleryController(initialPage: 2);
  StreamController<Widget> overlayController =
      StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                await SwipeImageGallery(
                  context: context,
                  children: remoteImages,
                  onSwipe: (index) {
                    overlayController.add(OverlayExample(
                      title: '${index + 1}/${remoteImages.length}',
                    ));
                  },
                  overlayController: overlayController,
                  initialOverlay: OverlayExample(
                    title: '1/${remoteImages.length}',
                  ),
                  backgroundOpacity: 0.5,
                ).show();

                debugPrint('DONE');
              },
              child: const Text('Open Gallery With Overlay'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: remoteImages,
                initialIndex: 2,
              ).show(),
              child: const Text('Open Gallery With URLs'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: widgets,
              ).show(),
              child: const Text('Open Gallery With Widgets'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: assets,
              ).show(),
              child: const Text('Open Gallery With Assets'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: assets,
                controller: galleryController,
              ).show(),
              child: const Text('Open Gallery With Controller'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                itemBuilder: (context, index) {
                  return Image.network(urls[index]);
                },
                itemCount: urls.length,
                // ignore: avoid_print
                onSwipe: (index) => print(index),
              ).show(),
              child: const Text('Open Gallery With Builder'),
            ),
            const Text('Hero Animation Example'),
            InkWell(
              onTap: () => SwipeImageGallery(
                context: context,
                children: [assets[0]],
                heroProperties: [
                  const ImageGalleryHeroProperties(tag: 'imageId1')
                ],
              ).show(),
              child: const Hero(
                tag: 'imageId1',
                child: Image(
                  image: AssetImage('assets/1.jpeg'),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MultiHeroAnimationScreen(),
                ),
              ),
              child: const Text('Multiple Images Hero Animation Example'),
            ),
          ],
        ),
      ),
    );
  }
}
