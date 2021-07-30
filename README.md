# Swipe Image Gallery

A scrollable, dismissable by swiping, zoomable, rotatable image gallery on which you can add a dynamic overlay.
While it is intended for an image gallery different types of widgets can also be used.

## Installation

First, add `swipe_image_gallery` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```
dependencies:
  swipe_image_gallery: ^0.0.1
```

<h1>Usage</h1>

### With a List of Image Widgets

![first](https://user-images.githubusercontent.com/15243788/127715435-ee01e5fa-cdcc-4b86-9201-463d353b500a.gif)

```dart
final assets = const [
  Image(image: AssetImage('assets/1.jpeg')),
  Image(image: AssetImage('assets/2.jpeg')),
  Image(image: AssetImage('assets/3.jpeg')),
  Image(image: AssetImage('assets/4.jpeg')),
];

...

SwipeImageGallery(
  context: context,
  images: assets,
).show();
```

### Using Builder

```dart
final urls = [
  'https://via.placeholder.com/400',
  'https://via.placeholder.com/800',
  'https://via.placeholder.com/900x350',
  'https://via.placeholder.com/1000',
  'https://via.placeholder.com/100',
];

...

SwipeImageGallery(
  context: context,
  itemBuilder: (context, index) {
    return Image.network(urls[index]);
  },
  itemCount: urls.length,
).show();

```

### Add an Overlay

You can find the `OverlayExample` widget [here](https://github.com/dbilgin/swipe_image_gallery/blob/master/example/lib/overlay_example.dart).

```dart
  StreamController<Widget> overlayController =
      StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  ...

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
```

### Hero Animation

```dart
final heroProperties = [
  ImageGalleryHeroProperties(tag: 'imageId1'),
  ImageGalleryHeroProperties(tag: 'imageId2'),
];

final assets = const [
  Image(image: AssetImage('assets/1.jpeg')),
  Image(image: AssetImage('assets/2.jpeg')),
];

...

Row(
  children: [
    Expanded(
      child: InkWell(
        onTap: () => SwipeImageGallery(
          context: context,
          images: assets,
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
          images: assets,
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
```

For more detailed examples you can check out the [example project](https://github.com/dbilgin/swipe_image_gallery/tree/master/example).
