import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';

class CustomMainAppBar extends StatefulWidget {
  const CustomMainAppBar(
      {super.key,
      this.leftContent = 0.0,
      this.textAppBar,
      this.subtitleAppBar,
      this.controllerMenu,
      this.customWidget,
      this.iconMenu = false,
      this.top = 8,
      this.left = 8,
      this.trailingAppBar});
  final String? textAppBar;
  final String? subtitleAppBar;
  final Widget? trailingAppBar;
  final bool iconMenu;
  final FancyDrawerController? controllerMenu;
  final Widget? customWidget;
  final double leftContent;
  final double top;
  final double left;

  @override
  State<CustomMainAppBar> createState() => _CustomMainAppBarState();
}

class _CustomMainAppBarState extends State<CustomMainAppBar> {
  @override
  void initState() {
    if (widget.customWidget == null) {
      assert(widget.subtitleAppBar != null, "Must provide a subtitleAppBar");
      assert(widget.textAppBar != null, "Must provide a textAppBar");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: widget.top,
              left: widget.left,
              child: Opacity(
                opacity: widget.iconMenu ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !widget.iconMenu,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      if (widget.controllerMenu == null) {
                        context.pop();
                        return;
                      }
                      widget.controllerMenu!.toggle();
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
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: widget.controllerMenu != null
                            ? const Icon(
                                Icons.menu_rounded,
                                color: whiteColorTheme,
                                size: 22,
                              )
                            : SvgPicture.asset(
                                alignment: Alignment.center,
                                '$pathManagementIcons$iconBackArrow',
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                    whiteColorTheme, BlendMode.srcIn),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              left: widget.leftContent,
              child: Row(
                children: [
                  Expanded(
                    child: widget.customWidget ??
                        ListTile(
                            title: TextLabelWidget(
                                text: widget.textAppBar!,
                                styleTextItem: const StyleTextItem(
                                    customStyle: TextStyle(
                                      color: secondaryColorTheme,
                                      fontFamily: fontFamilyMontserrat,
                                      fontSize: h2Size,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start)),
                            subtitle: TextLabelWidget(
                                text: widget.subtitleAppBar!,
                                styleTextItem: const StyleTextItem(
                                    customStyle: TextStyle(
                                      color: grayTextColorTheme,
                                      fontSize: h4Size,
                                      fontFamily: fontFamilyMontserrat,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start)),
                            trailing: widget.trailingAppBar),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
