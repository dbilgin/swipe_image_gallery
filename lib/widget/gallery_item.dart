import 'package:flutter/material.dart';

class GalleryItem {
  Widget child;
  bool isInteractive;

  GalleryItem({required this.child, this.isInteractive = true});
}
