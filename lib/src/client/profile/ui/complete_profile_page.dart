import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/devices_size_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/background_login_widget.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/dropdown_select_widget.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/shared/widgets/line_information_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/complete_profile_widgets/header_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/complete_profile_widgets/icon_top_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/complete_profile_widgets/text_filter_content_widget.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final FocusNode _focusNodeAddress = FocusNode();
  final FocusNode _focusNodeCountry = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();
  final FocusNode _focusNodeKindPlace = FocusNode();
  final FocusNode _focusNodeGender = FocusNode();
  final FocusNode _focusNodeBirthday = FocusNode();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController controllerCountry = TextEditingController();
  final TextEditingController controllerGender = TextEditingController();
  final TextEditingController controllerCity = TextEditingController();
  final TextEditingController _controllerKindPlace = TextEditingController();
  final TextEditingController _controllerBirthday = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return LayoutBuilder(builder: (context, constraints) {
      return SmallMobileAdditionalInformationPage(
          focusNodeCountry: _focusNodeCountry,
          focusNodeAddress: _focusNodeAddress,
          focusNodeCity: _focusNodeCity,
          focusNodeGender: _focusNodeGender,
          focusNodeKindPlace: _focusNodeKindPlace,
          focusNodeBithday: _focusNodeBirthday,
          controllerBirthday: _controllerBirthday,
          controllerKindPlace: _controllerKindPlace,
          controllerAddress: _controllerAddress,
          controllerCountry: controllerCountry,
          controllerGender: controllerGender,
          controllerCity: controllerCity,
          width: width,
          height: height);
    });
  }

  void changeFocusNode(
      String value, FocusNode unFocusNode, FocusNode focusNode) {
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }
}

class SmallMobileAdditionalInformationPage extends StatefulWidget {
  const SmallMobileAdditionalInformationPage({
    super.key,
    required this.focusNodeCountry,
    required this.focusNodeAddress,
    required this.focusNodeCity,
    required this.controllerKindPlace,
    required this.controllerAddress,
    required this.controllerCountry,
    required this.controllerGender,
    required this.controllerCity,
    required this.focusNodeGender,
    required this.focusNodeKindPlace,
    required this.controllerBirthday,
    required this.focusNodeBithday,
    required this.width,
    required this.height,
  });
  final FocusNode focusNodeCountry;
  final FocusNode focusNodeAddress;
  final FocusNode focusNodeCity;
  final FocusNode focusNodeKindPlace;
  final FocusNode focusNodeGender;
  final FocusNode focusNodeBithday;
  final TextEditingController controllerKindPlace;
  final TextEditingController controllerAddress;
  final TextEditingController controllerCountry;
  final TextEditingController controllerCity;
  final TextEditingController controllerGender;
  final TextEditingController controllerBirthday;
  final double width;
  final double height;

  @override
  State<SmallMobileAdditionalInformationPage> createState() =>
      _SmallMobileAdditionalInformationPageState();
}

class _SmallMobileAdditionalInformationPageState
    extends State<SmallMobileAdditionalInformationPage> {
  late bool _isExtraSmall;
  final double sizeIconPrefix = 30;
  final double sizeIconSuffix = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isExtraSmall = widget.width >= 0 && widget.width <= (smallMobileX - 50);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundLogin(
            width: widget.width,
            height: widget.height,
            bottonPositionWorld: -190,
            contentForm: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeaderAdditionalInformation(
                        sizeScreen: _isExtraSmall
                            ? TypeSizeScreenDevice.extraSmallMobile
                            : TypeSizeScreenDevice.smallMobile,
                        width: widget.width),
                    const SizedBox(height: spaceBetween30),
                    TextFilterContentAdditionalInformation(
                        width: widget.width,
                        height: widget.height,
                        itemBuilderCountry: (context, suggestion, clean) {
                          return GestureDetector(
                            onTap: () {
                              widget.controllerCountry.value =
                                  TextEditingValue(text: suggestion);
                              clean();
                              _changeFocusNode(
                                  suggestion,
                                  widget.focusNodeCountry,
                                  widget.focusNodeCity);
                            },
                            child: ListTile(
                              title: Text(suggestion,
                                  style: const TextStyle(
                                      color: whiteColorTheme,
                                      fontSize: minimalMonserratSize,
                                      fontFamily: fontFamilyMontserrat)),
                              leading: const Icon(
                                Icons.abc,
                                color: whiteColorTheme,
                              ),
                            ),
                          );
                        },
                        itemBuilderCity: (context, suggestion, clean) {
                          return GestureDetector(
                              onTap: () {
                                widget.controllerCity.value =
                                    TextEditingValue(text: suggestion);
                                clean();
                                _changeFocusNode(
                                    suggestion,
                                    widget.focusNodeCity,
                                    widget.focusNodeAddress);
                              },
                              child: ListTile(
                                title: Text(suggestion,
                                    style: const TextStyle(
                                        color: whiteColorTheme,
                                        fontSize: minimalMonserratSize,
                                        fontFamily: fontFamilyMontserrat)),
                                leading: const Icon(
                                  Icons.abc,
                                  color: whiteColorTheme,
                                ),
                              ));
                        },
                        sizeScreen: TypeSizeScreenDevice.smallMobile,
                        focusNodeCountry: widget.focusNodeCountry,
                        focusNodeCity: widget.focusNodeCity,
                        controllerCountry: widget.controllerCountry,
                        controllerCity: widget.controllerCity),
                    const SizedBox(height: spaceBetween10),
                    InputTextField(
                        controller: widget.controllerAddress,
                        styleInputField: StyleInputField(
                          textLabel: getIt<AppLocalizations>().inputAddress,
                          width: widget.width,
                        ),
                        focusNode: widget.focusNodeAddress,
                        onSubmitted: (value) => _changeFocusNode(value,
                            widget.focusNodeAddress, widget.focusNodeGender)),
                    const SizedBox(height: spaceBetween10),
                    DropdownCustomSelect(
                      styleInputField: StyleInputField(
                          textLabel: getIt<AppLocalizations>().inputGender),
                      cardColor: appBarColorTheme,
                      lineColor: whiteColorTheme,
                      focusNode: widget.focusNodeGender,
                      shadowColor: whiteColorTheme,
                      controller: widget.controllerGender,
                      onSelected: (String value) {
                        widget.controllerGender.value =
                            TextEditingValue(text: value);
                      },
                      items: const [
                        'Masculino',
                        'Femenino',
                        'No binario',
                        'Otro',
                      ],
                      itemBuilder: (BuildContext context, String item) {
                        return SizedBox(
                          width: widget.width / 2.5,
                          child: Text(
                            "Option $item",
                            style: const TextStyle(color: whiteColorTheme),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: spaceBetween10),
                    DropdownCustomSelect(
                      styleInputField: StyleInputField(
                        textLabel: getIt<AppLocalizations>().inputKindOfPlace,
                      ),
                      cardColor: appBarColorTheme,
                      lineColor: whiteColorTheme,
                      focusNode: widget.focusNodeKindPlace,
                      shadowColor: whiteColorTheme,
                      controller: widget.controllerKindPlace,
                      onSelected: (String value) {
                        widget.controllerKindPlace.value =
                            TextEditingValue(text: value);
                      },
                      items: const [
                        'Casa',
                        'Trabajo',
                        'Otro',
                      ],
                      itemBuilder: (BuildContext context, String item) {
                        return SizedBox(
                          width: widget.width / 2.5,
                          child: Text("Option $item",
                              style: const TextStyle(color: whiteColorTheme)),
                        );
                      },
                    ),
                    const SizedBox(height: spaceBetween10),
                    InputTextField(
                      controller: widget.controllerAddress,
                      styleInputField: StyleInputField(
                          textLabel: getIt<AppLocalizations>().inputBirthday,
                          icon: iconCalendar,
                          sizeIcon: sizeIconSuffix,
                          enable: false,
                          width: widget.width),
                      focusNode: widget.focusNodeBithday,
                    ),
                    const SizedBox(height: spaceBetween10 * 2),
                    ButtonMain(
                      width: widget.width,
                      textButton: getIt<AppLocalizations>().titleOk,
                      actionButton: ActionButtonLog.confirm,
                      actionDescription: runtimeType.toString(),
                      onPressed: () {},
                    ),
                    const SizedBox(height: spaceBetween10 / 2),
                    LineInformation(
                        inRow: false,
                        leftText: getIt<AppLocalizations>().questionWhyRequired,
                        rightText: getIt<AppLocalizations>().titleKnown),
                    const SizedBox(height: spaceBetween10 * 2),
                  ],
                ),
              ),
            ),
          ),
          IconTopAdditionalInformation(
              size: widget.width * 0.2,
              sizeScreen: TypeSizeScreenDevice.smallMobile)
        ],
      ),
    );
  }

  void _changeFocusNode(
      String value, FocusNode unFocusNode, FocusNode focusNode) {
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }
}
