import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';

class DropdownCustomSelect<T> extends StatefulWidget {
  final List<T> items;
  final double roundedValue;
  final Color lineColor;
  final Color shadowColor;
  final Color cardColor;
  final TextEditingController? controller;
  final void Function()? onFocusListener;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final void Function(T) onSelected;
  final FocusNode? focusNode;
  final StyleInputField? styleInputField;
  final Widget? customChild;
  final void Function()? onOpened;
  final void Function()? onCanceled;


  const DropdownCustomSelect({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onSelected,
    this.onOpened,
    this.onCanceled,
    this.controller,
    this.customChild,
    this.styleInputField,
    this.onFocusListener,
    this.focusNode,
    this.shadowColor = greyBlockColorTheme,
    this.roundedValue = rounded28,
    this.lineColor = Colors.transparent,
    this.cardColor = whiteColorTheme,
  });

  @override
  State<DropdownCustomSelect<T>> createState() => _DropdownCustomSelectState<T>();
}

class _DropdownCustomSelectState<T> extends State<DropdownCustomSelect<T>> {
  late StyleInputField _styleInputField = const StyleInputField(
    textLabel: "",
    additionalPaddingIcon: 5,
    sizeIcon: 10,
    colorText: whiteColorTheme,
    icon: "$pathManagementIcons$iconDownArrow",
    labelColor: grayTextColorTheme,
  );

  @override
  void initState() {
    if (widget.styleInputField != null) {
      _styleInputField = widget.styleInputField!;
    }
    if (widget.customChild == null) {
      assert(widget.controller != null, "Must provide a controller");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _styleInputField.width,
      height: 50,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.roundedValue),
        color: widget.cardColor,
        border: Border.all(color: widget.lineColor, width: 2),
      ),
      child: PopupMenuButton<T>(
        color: widget.cardColor,
        onOpened: widget.onOpened,
        onCanceled: widget.onCanceled,
        splashRadius: 0,
        tooltip: _styleInputField.textLabel,
        constraints: BoxConstraints(
            maxHeight: _styleInputField.height ?? 40,
            minHeight: 30,
            maxWidth: _styleInputField.width,
            minWidth: 110),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.roundedValue),
          side: BorderSide(color: widget.lineColor, width: 2),
        ),
        position: PopupMenuPosition.under,
        elevation: 3,
        shadowColor: widget.shadowColor,
        itemBuilder: (context) => widget.items
            .map((item) => PopupMenuItem<T>(
                  value: item,
                  child: widget.itemBuilder(context, item),
                ))
            .toList(),
        onSelected: widget.onSelected,
        child: widget.customChild ?? InputTextField(
          styleInputField: _styleInputField,
          controller: widget.controller,
          onFocusListener: widget.onFocusListener,
          focusNode: widget.focusNode,
        ),
      ),
    );
  }
}
