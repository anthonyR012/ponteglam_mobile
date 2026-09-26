import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/utils/alert_default_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/filter_alert_widget.dart';

class InputSearchCompleteText extends StatefulWidget {
  const InputSearchCompleteText({
    super.key,
    required this.width,
    required this.decoration,
    required this.percentage,
    required this.textInputSearch,
    this.focusNode,
  });

  final double width;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextEditingController textInputSearch;
  final double percentage;

  @override
  State<InputSearchCompleteText> createState() =>
      _InputSearchCompleteTextState();
}

class _InputSearchCompleteTextState extends State<InputSearchCompleteText> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _triggerSearch() {
    getIt<ServiceBloc>().setFilter(
      context: context,
      query: widget.textInputSearch.text,
    );
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    final iconSuffix = InkWell(
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        if (isFocused) {
          _triggerSearch();
        } else {
          showCustomBottomSheet(context, const BottonFilterWidget());
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            final filter = state is GetFilterServiceLoaded
                ? state.filter
                : getIt<ServiceBloc>().filterService;
            final isFiltering = filter.isFiltering;
            final count = filter.filterCount;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFocused
                    ? secondaryColorTheme
                    : (isFiltering ? primaryColorTheme : secondaryColorTheme),
                boxShadow: (isFiltering && !isFocused)
                    ? [
                        BoxShadow(
                          color: primaryColorTheme.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              padding: const EdgeInsets.all(paddingInput5),
              child: Center(
                child: isFocused
                    ? const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      )
                    : (isFiltering
                        ? Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: h4Size,
                            ),
                          )
                        : SvgPicture.asset(
                            "$pathManagementIcons$iconSettingFilter",
                            semanticsLabel: iconPonteSecondary,
                            width: lerpDouble(
                                13, 15, ((widget.percentage - 1) * -1)),
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                                whiteColorTheme, BlendMode.srcIn),
                          )),
              ),
            );
          },
        ),
      ),
    );

    return Positioned(
      bottom: 10,
      left: widget.width * 0.15,
      child: Opacity(
        opacity: lerpDouble(0, 1, (0.5 - widget.percentage) * 3)!.clamp(0, 1),
        child: Hero(
          tag: getIt<AppLocalizations>().inputSearchServices,
          child: Material(
            type: MaterialType.transparency,
            child: InputTextField(
                controller: widget.textInputSearch,
                focusNode: _focusNode,
                onSubmitted: (_) => _triggerSearch(),
                onChanged: (value) {
                  if (value.isEmpty) {
                    getIt<ServiceBloc>()
                        .setFilter(context: context, query: value);
                  }
                },
                styleInputField: StyleInputField(
                  textLabel: getIt<AppLocalizations>().inputSearchServices,
                  fillColor: whiteColorTheme,
                  decoration: widget.decoration,
                  icon: iconSearch,
                  colorText: secondaryColorTheme,
                  additionalPaddingIcon: 3,
                  colorIconUnfocus: secondaryColorTheme,
                  colorIconFocused: secondaryColorTheme,
                  borderEnable: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(rounded28),
                      borderSide: BorderSide(
                        color: secondaryColorTheme.withValues(alpha: 0.4),
                        width: 1,
                        style: BorderStyle.solid,
                      )),
                  borderFocus: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(rounded28),
                      borderSide: const BorderSide(
                        color: secondaryColorTheme,
                        width: 1,
                        style: BorderStyle.solid,
                      )),
                  sizeIcon: 35,
                  width: widget.width * 0.7,
                  iconSuffixCustom: iconSuffix,
                  height: heightTextFieldSize + 6,
                  textInputType: TextInputType.text,
                )),
          ),
        ),
      ),
    );
  }
}
