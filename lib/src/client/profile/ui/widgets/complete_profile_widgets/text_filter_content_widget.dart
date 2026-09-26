import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/shared/widgets/text_filter_data_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class TextFilterContentAdditionalInformation extends StatelessWidget {
  const TextFilterContentAdditionalInformation(
      {super.key,
      required this.width,
      required this.height,
      required this.sizeScreen,
      required this.focusNodeCountry,
      required this.focusNodeCity,
      required this.controllerCountry,
      required this.controllerCity,
      required this.itemBuilderCountry,
      required this.itemBuilderCity});
  final double width;
  final double height;
  final TypeSizeScreenDevice sizeScreen;
  final FocusNode focusNodeCountry;
  final FocusNode focusNodeCity;
  final TextEditingController controllerCountry;
  final TextEditingController controllerCity;
  final double sizeIconPrefix = 32;
  final Widget Function(BuildContext, String, void Function())
      itemBuilderCountry;
  final Widget Function(BuildContext, String, void Function()) itemBuilderCity;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      TextFilterData(
        styleInputField: StyleInputField(
          textLabel: getIt<AppLocalizations>().inputSearchCountry,
          sizeIcon: sizeIconPrefix,
          icon: iconWorldIcon,
          width: (sizeScreen == TypeSizeScreenDevice.extraBigMobile)
              ? width / 2.6
              : width,
        ),
        focusNode: focusNodeCountry,
        minSuggestions: 3,
        onChanged: (suggestion) {},
        listItems: const [
          'Afganistán',
          'Albania',
          'Baréin',
          'Bélgica',
          'Belice',
          'Burkina Faso',
          'Burundi',
          'Chile',
          'China',
          'Chipre',
          'Ciudad del Vaticano',
          'Colombia',
        ],
        controller: controllerCountry,
        openSuggestionOnFocus: true,
      ),
      (sizeScreen == TypeSizeScreenDevice.extraBigMobile)
          ? const Spacer()
          : const SizedBox(height: spaceBetween10),
      TextFilterData(
        focusNode: focusNodeCity,
        styleInputField: StyleInputField(
          textLabel: getIt<AppLocalizations>().inputSearchCity,
          icon: iconPlace,
          sizeIcon: sizeIconPrefix,
          width: (sizeScreen == TypeSizeScreenDevice.extraBigMobile)
              ? width / 2.6
              : width,
        ),
        minSuggestions: 3,
        onChanged: (suggestion) {},
        listItems: const [
          "Nueva",
          "Tokio",
          "París",
          "Londres",
          "Ciudad",
          "Roma",
          "Río",
          "Sydney",
        ],
        controller: controllerCity,
        openSuggestionOnFocus: true,
      ),
    ];
    if (sizeScreen == TypeSizeScreenDevice.extraBigMobile) {
      return Row(
        children: children,
      );
    } else {
      return Column(
        children: children,
      );
    }
  }
}
