import 'dart:async';

import 'package:example/overlay_example.dart';
import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:swipe_image_gallery/widget/gallery_item.dart';

void main() {
  runApp(ImageGalleryExampleApp());
}

class ImageGalleryExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageGalleryExamplesPage(title: 'Image Gallery Demo Home Page'),
    );
  }
}

final urls = [
  'https://via.placeholder.com/400',
  'https://via.placeholder.com/800',
  'https://via.placeholder.com/900x350',
  'https://via.placeholder.com/1000',
  'https://via.placeholder.com/100',
];

final remoteImages = [
  Image.network('https://via.placeholder.com/400'),
  Image.network('https://via.placeholder.com/800'),
  Image.network('https://via.placeholder.com/900x350'),
  Image.network('https://via.placeholder.com/1000'),
  Image.network('https://via.placeholder.com/100'),
].map((i) => GalleryItem(child: i)).toList();

final assets = [
  GalleryItem(
      child: Image(image: AssetImage('assets/1.jpeg')), isInteractive: false),
  GalleryItem(
      child: Image(image: AssetImage('assets/2.jpeg')), isInteractive: true),
  GalleryItem(child: Image(image: AssetImage('assets/3.jpeg'))),
];

class ImageGalleryExamplesPage extends StatefulWidget {
  ImageGalleryExamplesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ImageGalleryExamplesPageState createState() =>
      _ImageGalleryExamplesPageState();
}

class _ImageGalleryExamplesPageState extends State<ImageGalleryExamplesPage> {
  final heroProperties = [
    ImageGalleryHeroProperties(tag: 'imageId1'),
    ImageGalleryHeroProperties(tag: 'imageId2'),
  ];
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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                SwipeImageGallery(
                  context: context,
                  images: remoteImages,
                  onSwipe: (index) {
                    overlayController.add(OverlayExample(
                      title: '${index + 1}/${remoteImages.length}',
                    ));
                  },
                  overlayController: overlayController,
                  initialOverlay: OverlayExample(
                    title: '1/${remoteImages.length}',
                  ),
                ).show();
              },
              child: Text('Open Gallery With Overlay'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                images: remoteImages,
                initialIndex: 2,
              ).show(),
              child: Text('Open Gallery With URLs'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                images: assets,
              ).show(),
              child: Text('Open Gallery With Assets'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                images: assets,
                controller: galleryController,
              ).show(),
              child: Text('Open Gallery With Controller'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                itemBuilder: (context, index) =>
                    GalleryItem(child: Image.network(urls[index])),
                itemCount: urls.length,
                onSwipe: (index) => print(index),
              ).show(),
              child: Text('Open Gallery With Builder'),
            ),
            Text('Hero Animation Example'),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => SwipeImageGallery(
                      context: context,
                      images: [assets[0], assets[1]],
                      heroProperties: heroProperties,
                    ).show(),
                    child: Hero(
                      tag: 'imageId1',
                      child: Image(
                        image: AssetImage('assets/1.jpeg'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => SwipeImageGallery(
                      context: context,
                      images: [assets[0], assets[1]],
                      initialIndex: 1,
                      heroProperties: heroProperties,
                    ).show(),
                    child: Hero(
                      tag: 'imageId2',
                      child: Image(
                        image: AssetImage('assets/2.jpeg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
