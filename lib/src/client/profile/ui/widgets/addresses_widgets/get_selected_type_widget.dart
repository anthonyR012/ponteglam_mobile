import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/shared/widgets/dropdown_select_widget.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';

class GetDropdownSelectedTypes extends StatelessWidget {
  const GetDropdownSelectedTypes({
    super.key,
    required this.addressesTypes,
    required this.iconsAddress,
    required this.child,
    required this.width,
    required this.onSelected,
    this.onCanceled,
    this.onOpen,
    this.lineColor = grayTextColorTheme,
  });

  final List<TypeModel> addressesTypes;
  final Map<int, IconData> iconsAddress;
  final Widget child;
  final Color lineColor;
  final double width;
  final void Function(TypeModel) onSelected;
  final void Function()? onCanceled;
  final void Function()? onOpen;

  @override
  Widget build(BuildContext context) {
    return DropdownCustomSelect<TypeModel>(
        items: addressesTypes,
        lineColor: lineColor,
        onCanceled: onCanceled,
        onOpened: onOpen,
        styleInputField:
            StyleInputField(textLabel: null, height: 170, width: width),
        itemBuilder: (context, item) {
          return SizedBox(
            width: width,
            child: ListTile(
              leading:
                  Icon(iconsAddress[item.id], color: blackColorTheme, size: 15),
              title: TextLabelWidget(
                text: item.description,
                styleTextItem: const StyleTextItem(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  colorText: blackColorTheme,
                  fontSize: h4Size - 2,
                ),
              ),
            ),
          );
        },
        onSelected: onSelected,
        customChild: child);
  }
}
