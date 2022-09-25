import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomKeyboardListener extends StatelessWidget {
  CustomKeyboardListener({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);
  final PageController controller;
  final Widget child;

  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      controller.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      autofocus: true,
      child: child,
    );
  }
}
