import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class SnackBarContentBotton extends StatelessWidget {
  const SnackBarContentBotton(
      {super.key,
      required this.buildContext,
      required this.titleSnack,
      this.pathIcon = ""});

  final String pathIcon;
  final String titleSnack;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(buildContext).size;
    final width = size.width;
    return Column(
      children: [
        Container(
          width: width,
          height: 40,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("$pathManagementImages$imageBackground"),
                fit: BoxFit.fill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  titleSnack,
                  style: const TextStyle(
                      fontFamily: fontFamilyMontserrat,
                      fontSize: h3Size,
                      fontWeight: FontWeight.bold,
                      color: whiteColorTheme),
                ),
              ),
              Visibility(
                visible: pathIcon.isNotEmpty,
                child: SvgPicture.asset(
                  pathIcon,
                  semanticsLabel: iconPonteSecondary,
                  fit: BoxFit.contain,
                  colorFilter:
                      const ColorFilter.mode(whiteColorTheme, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
