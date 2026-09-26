import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/shared/core/log/domain/use_case/create_mobile_log.dart';

class ButtonMain extends StatefulWidget {
  const ButtonMain(
      {super.key,
      required this.width,
      required this.textButton,
      required this.onPressed,
      this.backgroundColor,
      this.actionButton,
      this.actionDescription,
      this.iconCustom});

  final double width;
  final String textButton;
  final ActionButtonLog? actionButton;
  final String? actionDescription;
  final Widget? iconCustom;
  final dynamic onPressed;
  final Color? backgroundColor;

  @override
  State<ButtonMain> createState() => _ButtonMainState();
}

class _ButtonMainState extends State<ButtonMain> {
  bool _isButtonDisabled = false;

  @override
  void initState() {
    if (widget.actionButton != null) {
      assert(widget.actionDescription != null,
          "Must provide an action description");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = widget.iconCustom ?? const SizedBox();
    final double space = widget.iconCustom == null ? 0 : spaceBetween10;
    return Opacity(
      opacity: _isButtonDisabled ? 0.5 : 1,
      child: Container(
        height: heightButtonSize,
        width: widget.width,
        constraints: const BoxConstraints(
            minHeight: heightButtonSize,
            maxHeight: heightButtonSize * 1.3,
            minWidth: widthButtonSize),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          gradient: widget.backgroundColor != null ? null : glamGradientTheme,
          borderRadius: BorderRadius.circular(rounded28),
        ),
        child: ElevatedButton(
          onPressed: _isButtonDisabled ? null : _handleButtonPress,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.textButton,
                style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  fontSize: h3Size,
                ),
              ),
              SizedBox(width: space),
              icon
            ],
          ),
        ),
      ),
    );
  }

  void _handleButtonPress() async {
    setState(() {
      _isButtonDisabled = true;
    });
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      if (widget.actionButton != null) {
        final today = getIt<DateFormatUtil>().getToday();
        await getIt<CreateMobileLog>().call(
          description:
              "Button Press: ${widget.actionButton!.name} | Desc: ${widget.actionDescription} | Time: $today",
          source: "ButtonMain",
        );
      }
      await widget.onPressed();
    } catch (e, stackTrace) {
      catchError(e.toString(), stackTrace.toString());
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }
}
