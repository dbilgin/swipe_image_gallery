import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Adds the ability to swipe left and right using
/// touch, mouse and trackpad and generates a custom
/// [MaterialScrollBehavior] for the [PageView].
/// Enables scroll for linux
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
