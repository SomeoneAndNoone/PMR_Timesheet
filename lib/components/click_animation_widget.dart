import 'package:flutter/material.dart';

class InkWellOverlay extends StatelessWidget {
  const InkWellOverlay({
    this.openContainerCallback,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback openContainerCallback;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainerCallback,
        child: child,
      ),
    );
  }
}
