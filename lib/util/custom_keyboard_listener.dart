import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Simply separates the implementation of [KeyboardListener ]
/// required for the left and right keys on the keyboard to be
/// listened to for swiping.
class CustomKeyboardListener extends StatelessWidget {
  CustomKeyboardListener({
    super.key,
    required this.controller,
    required this.child,
  });
  final PageController controller;
  final Widget child;

  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: child,
    );
  }
}
