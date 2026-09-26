import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';

class IconCenterAnimationSplash extends StatelessWidget {
  const IconCenterAnimationSplash(
      {super.key,
      required this.size,
      this.alignmentIcon = Alignment.center,
      this.image = imagePonteGradient,
      this.tagHero});

  final double size;
  final Alignment alignmentIcon;
  final String image;
  final String? tagHero;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      '$pathManagementImages$image',
      width: size,
      height: size,
    ).withHeroTag(tagHero ?? '$pathManagementImages$image');
  }
}

extension HeroTag on Widget {
  Widget withHeroTag(String tag) => Hero(tag: Key(tag), child: this);
}
