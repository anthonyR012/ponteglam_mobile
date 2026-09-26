import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/text_option_widget.dart';

class LineInformation extends StatefulWidget {
  const LineInformation(
      {super.key,
      this.inRow = true,
      required this.leftText,
      required this.rightText,
      this.isButtonDisabled = false,
      this.onTapTextOption});
  final bool inRow;
  final String leftText;
  final String rightText;
  final bool isButtonDisabled;
  final dynamic onTapTextOption;

  @override
  State<LineInformation> createState() => _LineInformationState();
}

class _LineInformationState extends State<LineInformation> {
  bool _isButtonDisabled = false;

  @override
  void initState() {
    _isButtonDisabled = widget.isButtonDisabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [
      Text(
        widget.leftText,
        style: const TextStyle(
            fontFamily: fontFamilyLora,
            color: grayTextColorTheme,
            fontSize: bodySize),
      ),
      const SizedBox(width: 5),
      InkWell(
          onTap: _isButtonDisabled ? null : _handleButtonPress,
          child: TextOptionField(
            text: widget.rightText,
            colorText: _isButtonDisabled
                ? secondaryColorTheme.withValues(alpha: 0.4)
                : secondaryColorTheme,
          ))
    ];
    return widget.inRow
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: childs,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: childs,
          );
  }

  void _handleButtonPress() async {
    setState(() {
      _isButtonDisabled = true;
    });
    try {
      await widget.onTapTextOption!();
    } catch (error) {
      // Handle any errors that occur during the action
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }
}
