import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'dart:math' as math;

import 'package:ponte_glam/config/theme/theme.dart';

class BackgroundLogin extends StatelessWidget {
  const BackgroundLogin({
    super.key,
    required this.width,
    required this.height,
    required this.bottonPositionWorld,
    required this.contentForm,
  });

  final double width;
  final double height;
  final double bottonPositionWorld;
  final Widget contentForm;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("$pathManagementImages$imageBackground"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 36),
          duration: const Duration(minutes: animation2Minute),
          child: const Image(
              image: AssetImage("$pathManagementImages$imageWorld")),
          builder: (context, value, child) {
            return Positioned(
                width: width * 1.9,
                height: height / 2.2,
                bottom: bottonPositionWorld,
                child: Opacity(
                  opacity: value <= 1 ? value : 1,
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(value / math.pi)
                        ..setEntry(3, 2, 0.002),
                      child: child),
                ));
          },
        ),
        Positioned(
          bottom: 0,
          width: width,
          height: height / 1.42,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: animation1000Milliseconds),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child!);
            },
            child: Container(
                padding: const EdgeInsets.only(
                    top: paddingRow70,
                    left: paddingColumn40,
                    right: paddingColumn40),
                decoration: BoxDecoration(
                    color: appBarColorTheme.withValues(alpha: percetage70),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(rounded28),
                        topRight: Radius.circular(rounded28))),
                child: contentForm),
          ),
        ),
      ],
    );
  }
}
