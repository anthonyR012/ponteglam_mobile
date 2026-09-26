import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/get_selected_type_widget.dart';

class DropdownChanged extends StatefulWidget {
  const DropdownChanged({
    super.key,
    required this.addressesTypes,
    required this.iconsAddress,
    required this.width,
    required this.controllerType,
    this.initialValue,
  });
  final List<TypeModel> addressesTypes;
  final Map<int, IconData> iconsAddress;
  final double width;
  final TypeModel? initialValue; 
  final TextEditingController controllerType;

  @override
  State<DropdownChanged> createState() => _DropdownChangedState();
}

class _DropdownChangedState extends State<DropdownChanged> {
  IconData? iconSelected;
  String? typeTextSelected;
  bool isOpen = false;

  @override
  void initState() {
    
    typeTextSelected = widget.initialValue?.description;
    iconSelected = widget.initialValue == null ? null : widget.iconsAddress[widget.initialValue!.id];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetDropdownSelectedTypes(
        addressesTypes: widget.addressesTypes,
        lineColor: grayTextColorTheme.withValues(alpha: 0.3),
        width: widget.width,
        iconsAddress: widget.iconsAddress,
        onOpen: () => setState(() => isOpen = true),
        onCanceled: () => setState(() => isOpen = false),
        onSelected: (TypeModel selected) {
          setState(() {
            isOpen = false;
            iconSelected = widget.iconsAddress[selected.id];
            typeTextSelected = selected.description;
            widget.controllerType.text = selected.id.toString();
          });
        },
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: iconSelected == null
              ? null
              : Icon(
                  iconSelected,
                  size: 17,
                  color: secondaryColorTheme,
                ),
          trailing: Icon(
            isOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            size: 17,
            color: secondaryColorTheme,
          ),
          title: TextLabelWidget(
            text: typeTextSelected == null
                ? getIt<AppLocalizations>().titleAddressType
                : typeTextSelected!,
            styleTextItem: const StyleTextItem(
              textAlign: TextAlign.start,
              maxLines: 1,
              colorText: secondaryColorTheme,
              fontSize: h4Size - 2,
            ),
          ),
        ));
  }
}
