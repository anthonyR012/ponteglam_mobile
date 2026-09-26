import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class GetBannerTitleLabel extends StatelessWidget {
  const GetBannerTitleLabel(
      {super.key, required this.title, this.icon});

  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColorTheme.withValues(alpha: 0.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: fontFamilyMontserrat,
                fontWeight: FontWeight.bold,
                color: secondaryColorTheme,
                fontSize: h4Size - 1),
          ),
          const Spacer(),
          if(icon != null) icon!,
        ],
      ),
    );
  }
}
