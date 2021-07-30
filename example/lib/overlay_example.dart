import 'package:flutter/material.dart';

class OverlayExample extends StatelessWidget {
  const OverlayExample({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black.withAlpha(50),
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18.0,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            tooltip: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
