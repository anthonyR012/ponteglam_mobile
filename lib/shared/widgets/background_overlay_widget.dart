
import 'package:flutter/material.dart';

class BackgroundOverlayWidget extends StatefulWidget {
  const BackgroundOverlayWidget({
    super.key,
    required this.buildContext,
    required this.child,
    this.heightContainer = 300,
    this.widthContainer = 450,
    required this.onDismiss,
  });

  final double heightContainer;
  final double widthContainer;
  final BuildContext buildContext;
  final Widget child;
  final VoidCallback onDismiss;

 @override
  State<BackgroundOverlayWidget> createState() => BackgroundOverlayWidgetState();

}

class BackgroundOverlayWidgetState extends State<BackgroundOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), 
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(widget.buildContext).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                width: width,
                height: height,
                color: Colors.black26,
              ),
            ),
          ),
          Positioned(
            top: (height / 2) - (widget.heightContainer / 2),
            left: (width / 2) - (widget.widthContainer / 2),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: widget.widthContainer,
                height: widget.heightContainer,
                color: Colors.transparent,
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}