import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class InputTextField extends StatefulWidget {
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onFocusListener;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextEditingController? compareWith;
  final int? minLines;
  final int? maxLines;
  final StyleInputField styleInputField;

  const InputTextField(
      {super.key,
      this.controller,
      this.compareWith,
      this.onSubmitted,
      this.onChanged,
      this.focusNode,
      this.minLines,
      this.maxLines,
      this.onFocusListener,
      this.styleInputField = const StyleInputField(
        textLabel: '',
      )});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  final _borderNoSelected = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rounded28),
      borderSide: const BorderSide(
        color: borderColorTheme,
        width: 1,
        style: BorderStyle.solid,
      ));

  final _borderSelected = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rounded28),
      borderSide: const BorderSide(
        color: borderColorActiveTheme,
        width: 1,
        style: BorderStyle.solid,
      ));
  final IsObscureNotifier _isObscureNotifier = IsObscureNotifier();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  FocusNode _focusNode = FocusNode();
  late StyleInputField _styleInputField;

  @override
  void initState() {
    _styleInputField = widget.styleInputField;
    _isObscureNotifier.showObscure = _styleInputField.isObscure;
    _focusNode = widget.focusNode ?? _focusNode;
    super.initState();
    _initConditions();
  }

  @override
  void didUpdateWidget(covariant InputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.styleInputField != widget.styleInputField) {
      _styleInputField = widget.styleInputField;
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode != null && widget.onFocusListener != null) {
        oldWidget.focusNode!.removeListener(widget.onFocusListener!);
      }
      _focusNode = widget.focusNode ?? _focusNode;
      if (widget.focusNode != null && widget.onFocusListener != null) {
        widget.focusNode!.addListener(widget.onFocusListener!);
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode != null) {
      if (widget.onFocusListener != null) {
        widget.focusNode!.removeListener(widget.onFocusListener!);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _styleInputField.enable ? 1 : 0.5,
      child: Container(
          width: _styleInputField.width,
          height: _styleInputField.height,
          constraints: const BoxConstraints(
              minHeight: 43,
              maxHeight: heightTextFieldSize * 4,
              minWidth: widthTextFieldSize,
              maxWidth: widthTextFieldSize * 20),
          child: _isObscureNotifier.showObscure
              ? TextFieldObscure(
                  controller: widget.controller,
                  initialValue: _styleInputField.initialValue,
                  focusNode: _focusNode,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  maxLength: _styleInputField.maxLength,
                  minLines: widget.minLines,
                  textInputType: _styleInputField.textInputType,
                  colorText: _styleInputField.colorText,
                  validator: validator,
                  fontSize: _styleInputField.fontSize,
                  decoration: _styleInputField.decoration ??
                      _getDecorationInput(isObscure: true),
                  isObscureNotifier: _isObscureNotifier)
              : TextFieldNoObscure(
                  validator: validator,
                  initialValue: _styleInputField.initialValue,
                  controller: widget.controller,
                  fontSize: _styleInputField.fontSize,
                  focusNode: _focusNode,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  colorText: _styleInputField.colorText,
                  decoration: _styleInputField.decoration ??
                      _getDecorationInput(isObscure: false),
                  maxLength: _styleInputField.maxLength,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  textInputType: _styleInputField.textInputType,
                )),
    );
  }

  InputDecoration _getDecorationInput({required bool isObscure}) {
    return InputDecoration(
      filled: true,
      enabled: _styleInputField.enable,
      errorStyle: const TextStyle(
          fontFamily: fontFamilyMontserrat,
          fontWeight: FontWeight.bold,
          fontSize: h5Size),
      enabledBorder: _styleInputField.borderEnable ?? _borderNoSelected,
      focusedBorder: _styleInputField.borderFocus ?? _borderSelected,
      border: _styleInputField.border ??
          OutlineInputBorder(borderRadius: BorderRadius.circular(rounded28)),
      fillColor: _styleInputField.fillColor,
      labelText: _styleInputField.textLabel,
      contentPadding: _styleInputField.contentPadding,
      suffixIconConstraints: const BoxConstraints(
        minWidth: iconInputSize,
        minHeight: iconInputSize,
      ),
      suffixIcon: _getIcon(_styleInputField.iconSuffixCustom),
      prefixIconConstraints: const BoxConstraints(
        minWidth: iconInputSize,
        minHeight: iconInputSize,
      ),
      prefixIcon:
          isObscure ? null : _getIcon(_styleInputField.iconPrefixCustom),
      labelStyle: TextStyle(
          fontFamily: fontFamilyLora,
          color: _styleInputField.labelColor,
          fontSize: bodySize,
          fontStyle: FontStyle.italic),
    );
  }

  Widget? _getIcon(Widget? childIcon) {
    if (!_styleInputField.isObscure &&
        _styleInputField.icon == null &&
        childIcon == null) {
      return null;
    }
    return IconTextFieldWidget(
        sizeIcon: _styleInputField.sizeIcon,
        additionalPaddingIcon: _styleInputField.additionalPaddingIcon,
        icon: _styleInputField.icon,
        textLabel: _styleInputField.textLabel,
        focusNode: _focusNode,
        customIcon: childIcon,
        onTapIcon: _styleInputField.iconTap,
        colorIconUnfocused: _styleInputField.colorIconUnfocus,
        colorIconFocused: _styleInputField.colorIconFocused,
        isObscureNotifier: _isObscureNotifier);
  }

  String? validator(String? value) {
    String? error;
    if (_styleInputField.validators.isEmpty) return null;
    if (value == null) return value;
    for (int i = 0; i < _styleInputField.validators.length; i++) {
      switch (_styleInputField.validators[i]) {
        case ValidatorText.requiredValue:
          error = value.isEmpty
              ? getIt<AppLocalizations>().failureEmptyField
              : null;
          break;
        case ValidatorText.minLenght3:
          error = value.length < 3
              ? getIt<AppLocalizations>().failureInvalidNumberChar("3")
              : null;
          break;
        case ValidatorText.email:
          error = !emailRegex.hasMatch(value)
              ? getIt<AppLocalizations>().failureInvalidFormatInputEmail
              : null;
          break;
        default:
          error = null;
          break;
      }
    }
    return error;
  }

  void _initConditions() {
    if (_styleInputField.validators.contains(ValidatorText.verifyPassword)) {
      assert(widget.compareWith != null,
          getIt<AppLocalizations>().failureMissingArgument("compareWith?"));
    }
    if (widget.onFocusListener != null) {
      _focusNode.addListener(widget.onFocusListener!);
    }
  }
}

class TextFieldNoObscure extends StatelessWidget {
  const TextFieldNoObscure(
      {super.key,
      required this.validator,
      required this.controller,
      required this.focusNode,
      required this.onSubmitted,
      required this.onChanged,
      required this.maxLength,
      required this.textInputType,
      required this.colorText,
      required this.decoration,
      required this.initialValue,
      required this.minLines,
      required this.fontSize,
      required this.maxLines});

  final TextEditingController? controller;
  final FocusNode focusNode;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final int? maxLength;
  final TextInputType? textInputType;
  final Color? colorText;
  final InputDecoration? decoration;
  final String? Function(String? value) validator;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: textInputType,
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
          color: colorText, fontFamily: fontFamilyHind, fontSize: fontSize),
      decoration: decoration,
    );
  }
}

class TextFieldObscure extends StatefulWidget {
  const TextFieldObscure(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.onSubmitted,
      required this.onChanged,
      required this.maxLength,
      required this.textInputType,
      required this.colorText,
      required this.decoration,
      required this.isObscureNotifier,
      required this.validator,
      required this.initialValue,
      required this.minLines,
      this.fontSize});

  final TextEditingController? controller;
  final FocusNode focusNode;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final int? maxLength;
  final TextInputType? textInputType;
  final Color? colorText;
  final InputDecoration? decoration;
  final IsObscureNotifier isObscureNotifier;
  final String? Function(String? value) validator;
  final String? initialValue;
  final int? minLines;
  final double? fontSize;

  @override
  State<TextFieldObscure> createState() => _TextFieldObscureState();
}

class _TextFieldObscureState extends State<TextFieldObscure> {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      builder: (context, child) => TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: widget.isObscureNotifier.isObscure,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        keyboardType: widget.textInputType,
        validator: widget.validator,
        minLines: widget.minLines,
        initialValue: widget.initialValue,
        style: TextStyle(
            color: widget.colorText,
            fontFamily: fontFamilyHind,
            fontSize: widget.fontSize),
        decoration: widget.decoration,
      ),
      listenable: widget.isObscureNotifier,
    );
  }
}

class IconTextFieldWidget extends StatefulWidget {
  const IconTextFieldWidget({
    super.key,
    this.customIcon,
    required this.sizeIcon,
    required this.additionalPaddingIcon,
    required this.icon,
    required this.textLabel,
    required this.colorIconUnfocused,
    required this.colorIconFocused,
    required this.isObscureNotifier,
    required this.focusNode,
    this.onTapIcon,
  });
  final Widget? customIcon;
  final double sizeIcon;
  final double additionalPaddingIcon;
  final String? icon;
  final String? textLabel;
  final Color colorIconUnfocused;
  final Color colorIconFocused;
  final FocusNode focusNode;
  final VoidCallback? onTapIcon;
  final IsObscureNotifier isObscureNotifier;

  @override
  State<IconTextFieldWidget> createState() => _IconTextFieldWidgetState();
}

class _IconTextFieldWidgetState extends State<IconTextFieldWidget> {
  bool _showObscured = true;
  late Color colorIcon;

  void _focusListener() {
    if (mounted) {
      setState(() {
        colorIcon = widget.focusNode.hasFocus
            ? widget.colorIconFocused
            : widget.colorIconUnfocused;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    colorIcon = widget.colorIconUnfocused;
    widget.focusNode.addListener(_focusListener);
    _showObscured = widget.isObscureNotifier.showObscure;
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // icon obscure
    Widget iconWidget = _showObscured
        ? ListenableBuilder(
            builder: (context, child) {
              return SvgPicture.asset(
                "$pathManagementIcons${widget.isObscureNotifier.iconPassword}",
                semanticsLabel: widget.textLabel,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(colorIcon, BlendMode.srcIn),
              );
            },
            listenable: widget.isObscureNotifier,
          )
        : SvgPicture.asset(
            // icon by path
            "$pathManagementIcons${widget.icon}",
            semanticsLabel: widget.textLabel,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(colorIcon, BlendMode.srcIn),
          );

    return widget.customIcon ??
        (InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: _showObscured
                ? widget.isObscureNotifier.changeObscure
                : widget.onTapIcon,
            child: Container(
                width: widget.sizeIcon,
                height: widget.sizeIcon,
                padding: EdgeInsets.all(
                    paddingInput5 + widget.additionalPaddingIcon),
                child: iconWidget)));
  }
}

class IsObscureNotifier extends ChangeNotifier {
  bool _isObscure = true;
  bool showObscure = false;
  bool get isObscure => _isObscure;
  String _iconPassword = iconCloseEye;
  String get iconPassword => _iconPassword;

  void changeObscure() {
    _isObscure = !_isObscure;
    _iconPassword = _isObscure ? iconCloseEye : iconOpenEye;
    notifyListeners();
  }
}

class StyleInputField {
  final String? textLabel;
  final EdgeInsetsGeometry? contentPadding;
  final bool isObscure;
  final bool enable;
  final Color? colorText;
  final double fontSize;
  final Color? labelColor;
  final Color? fillColor;
  final Color colorIconUnfocus;
  final Color colorIconFocused;
  final double width;
  final double? height;
  final double sizeIcon;
  final double additionalPaddingIcon;
  final InputBorder? border;
  final InputBorder? borderFocus;
  final InputBorder? borderEnable;
  final int? maxLength;
  final TextInputType? textInputType;
  final InputDecoration? decoration;
  final List<ValidatorText> validators;

  ///  * [iconPrefixCustom] && [iconSuffixCustom] are required once [isObscure] is false or  [showIcon] is true.
  final Widget? iconPrefixCustom;
  final Widget? iconSuffixCustom;
  final String? icon;
  final VoidCallback? iconTap;
  final String? initialValue;

  const StyleInputField(
      {required this.textLabel,
      this.width = double.infinity,
      this.initialValue,
      this.fontSize = messageSize,
      this.validators = const [],
      this.iconTap,
      this.icon,
      this.height,
      this.contentPadding,
      this.textInputType,
      this.maxLength,
      this.border,
      this.additionalPaddingIcon = 2,
      this.sizeIcon = 35,
      this.isObscure = false,
      this.colorText = whiteColorTheme,
      this.labelColor = grayTextColorTheme,
      this.fillColor,
      this.enable = true,
      this.iconPrefixCustom,
      this.iconSuffixCustom,
      this.borderEnable,
      this.borderFocus,
      this.decoration,
      this.colorIconUnfocus = grayTextColorTheme,
      this.colorIconFocused = whiteColorTheme});

  StyleInputField copyWith({
    String? textLabel,
    bool? isObscure,
    bool? enable,
    Color? colorText,
    Color? labelColor,
    Color? fillColor,
    Color? colorIconUnfocus,
    Color? colorIconFocused,
    double? width,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    double? sizeIcon,
    double? additionalPaddingIcon,
    InputBorder? border,
    InputBorder? borderFocus,
    InputBorder? borderEnable,
    int? maxLength,
    TextInputType? textInputType,
    InputDecoration? decoration,
    List<ValidatorText>? validators,
    Widget? iconPrefixCustom,
    Widget? iconSuffixCustom,
    String? icon,
    VoidCallback? iconTap,
    String? initialValue,
  }) {
    return StyleInputField(
      textLabel: textLabel ?? this.textLabel,
      isObscure: isObscure ?? this.isObscure,
      enable: enable ?? this.enable,
      colorText: colorText ?? this.colorText,
      labelColor: labelColor ?? this.labelColor,
      fillColor: fillColor ?? this.fillColor,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeIcon: sizeIcon ?? this.sizeIcon,
      additionalPaddingIcon:
          additionalPaddingIcon ?? this.additionalPaddingIcon,
      border: border ?? this.border,
      contentPadding: contentPadding ?? this.contentPadding,
      borderFocus: borderFocus ?? this.borderFocus,
      borderEnable: borderEnable ?? this.borderEnable,
      maxLength: maxLength ?? this.maxLength,
      textInputType: textInputType ?? this.textInputType,
      decoration: decoration ?? this.decoration,
      validators: validators ?? this.validators,
      iconPrefixCustom: iconPrefixCustom ?? this.iconPrefixCustom,
      iconSuffixCustom: iconSuffixCustom ?? this.iconSuffixCustom,
      icon: icon ?? this.icon,
      iconTap: iconTap ?? this.iconTap,
      initialValue: initialValue ?? this.initialValue,
    );
  }
}
