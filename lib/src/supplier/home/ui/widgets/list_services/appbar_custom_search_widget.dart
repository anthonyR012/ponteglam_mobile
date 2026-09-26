import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';

class AnimatedAppBarCustomSearch extends StatefulWidget {
  const AnimatedAppBarCustomSearch(
      {super.key,
      required this.width,
      required this.height,
      required this.controllerMenu,
      required this.percentage,
      required this.companyName,
      required this.companyAddress,
      this.iconMenu = false,
      this.pathRigthIcon = ""});
  final double width;
  final double height;
  final double percentage;
  final bool iconMenu;
  final String pathRigthIcon;
  final String companyName;
  final String companyAddress;
  final FancyDrawerController controllerMenu;

  @override
  State<AnimatedAppBarCustomSearch> createState() =>
      _AnimatedAppBarCustomSearchState();
}

class _AnimatedAppBarCustomSearchState extends State<AnimatedAppBarCustomSearch> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildCompanyInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.companyName.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontFamily: fontFamilyMontserrat,
            fontWeight: FontWeight.bold,
            color: secondaryColorTheme,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: whiteColorTheme.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: whiteColorTheme.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                alignment: Alignment.center,
                "$pathManagementIcons$iconLocation",
                width: 14,
                semanticsLabel: iconLocation,
                colorFilter: const ColorFilter.mode(
                    secondaryColorTheme, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.companyAddress,
                  style: const TextStyle(
                    fontFamily: fontFamilyLora,
                    fontSize: bodySize - 3,
                    color: whiteColorTheme,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 90,
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: appBarColorTheme,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(rounded28),
              bottomRight: Radius.circular(rounded28))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: widget.iconMenu ? 1 : 0,
            child: IgnorePointer(
              ignoring: !widget.iconMenu,
              child: InkWell(
                onTap: () {
                  widget.controllerMenu.toggle();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: appBarColorTheme,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.menu_rounded,
                        color: whiteColorTheme,
                        size: 22,
                      )),
                ),
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCompanyInfo(),
            ],
          ),
          const Spacer(),
          Opacity(
            opacity: widget.pathRigthIcon.isNotEmpty ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: appBarColorTheme,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Visibility(
                  visible: widget.pathRigthIcon.isNotEmpty,
                  child: SvgPicture.asset(
                    widget.pathRigthIcon,
                    semanticsLabel: iconMenu,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                        whiteColorTheme, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
