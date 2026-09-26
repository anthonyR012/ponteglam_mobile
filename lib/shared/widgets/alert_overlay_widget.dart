import 'package:flutter/material.dart';

class AlertOverlayCenter extends StatelessWidget {
  const AlertOverlayCenter({
    super.key,
    required this.buildContext,
    this.heightContainer = 300,
    this.widthContainer = 450,
  });

  final double heightContainer;
  final double widthContainer;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(buildContext).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      body: TweenAnimationBuilder<double>(
        duration: Durations.extralong2,
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: (height / 2) - (heightContainer / 2),
              left: (width / 2) - (widthContainer / 2),
              child: Container(
                width: widthContainer,
                height: heightContainer,
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                width: width,
                height: height,
                color: Colors.black26,
              ),
            )
          ],
        ),
      ),
    );
  }
}
