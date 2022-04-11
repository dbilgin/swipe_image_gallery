# Swipe Image Gallery
[![Pub Version](https://img.shields.io/pub/v/swipe_image_gallery?color=blueviolet)](https://pub.dev/packages/swipe_image_gallery)

A scrollable, dismissable by swiping, zoomable, rotatable image gallery on which you can add a dynamic overlay.
While it is intended for an image gallery different types of widgets can also be used.

## Installation

Add `swipe_image_gallery` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

<h1>Usage</h1>

### With a List of Image Widgets

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
  children: assets,
).show();
```

![Image Widgets](https://user-images.githubusercontent.com/15243788/127715435-ee01e5fa-cdcc-4b86-9201-463d353b500a.gif)

### With a List of Widgets

```dart
final widgets = [
  Container(
    color: Colors.white,
    child: Center(
      child: Text('First Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
  Container(
    color: Colors.grey,
    child: Center(
      child: Text('Second Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
];

...

SwipeImageGallery(
  context: context,
  children: widgets,
).show();
```

![widgets](https://user-images.githubusercontent.com/15243788/162843736-0be8621b-63f1-4144-8aa8-a804f89f24a0.gif)

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
  ).show();
```

![overlay](https://user-images.githubusercontent.com/15243788/127715756-6d28ad81-d310-4267-9460-9aa1850a9c6f.gif)

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
          children: assets,
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
          children: assets,
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

![hero](https://user-images.githubusercontent.com/15243788/127715901-007e5df4-376b-4a15-b521-f880475296aa.gif)

For more detailed examples you can check out the [example project](https://github.com/dbilgin/swipe_image_gallery/tree/master/example).
