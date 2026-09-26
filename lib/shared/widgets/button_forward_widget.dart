import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class ListButtonsForward extends StatelessWidget {
  const ListButtonsForward({
    super.key,
    required this.buttons,
  });
  final List<ParamsButtonForward> buttons;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: buttons.map((param) {
      return ButtonForwadIcon(param: param, key: param.key);
    }).toList());
  }
}

class ButtonForwadIcon extends StatefulWidget {
  const ButtonForwadIcon({
    super.key,
    required this.param,
  });

  final ParamsButtonForward param;

  @override
  State<ButtonForwadIcon> createState() => _ButtonForwadIconState();
}

class _ButtonForwadIconState extends State<ButtonForwadIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.param.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColorTheme,
            child: SvgPicture.asset(
              "$pathManagementIcons${widget.param.iconLending}",
              colorFilter:
                  const ColorFilter.mode(whiteColorTheme, BlendMode.srcIn),
              width: 20,
              height: 20,
            ),
          ),
          title: Text(
            widget.param.description,
            style:
                const TextStyle(fontSize: h4Size, fontFamily: fontFamilyHind),
          ),
          trailing: SvgPicture.asset(
            "$pathManagementIcons${widget.param.iconTrailing}",
            width: 13,
            height: 13,
          ),
        ),
      ),
    );
  }
}

class ParamsButtonForward {
  final String iconLending;
  final String description;
  final String iconTrailing;
  final VoidCallback onTap;
  final GlobalKey? key;

  ParamsButtonForward(
      {required this.iconLending,
      required this.description,
      required this.onTap,
      this.iconTrailing = iconForwardArrow,
      this.key});
}
