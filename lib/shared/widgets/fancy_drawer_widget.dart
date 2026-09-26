import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/config/utils/overlay_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/sign_in/ui/sign_in_page.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/place_selector_menu.dart';

class FancyDrawerWrapperCustom extends StatefulWidget {
  const FancyDrawerWrapperCustom(
      {super.key,
      required this.controller,
      required this.child,
      required this.listButtonNav,
      required this.notifierNav,
      this.currentHeadquarter});

  final FancyDrawerController controller;
  final NotifierNav notifierNav;
  final List<ButtonNavModel> listButtonNav;
  final Widget child;
  final HeadquarterModel? currentHeadquarter;

  @override
  State<FancyDrawerWrapperCustom> createState() =>
      _FancyDrawerWrapperCustomState();
}

class _FancyDrawerWrapperCustomState extends State<FancyDrawerWrapperCustom> {
  bool _hasCompany = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentHeadquarter != null && widget.currentHeadquarter!.id != 0) {
      _hasCompany = true;
    }
    _checkUserCompanies();
  }

  Future<void> _checkUserCompanies() async {
    final storage = getIt<IStorage>();
    final geoDevice = getIt<GeoDevice>();

    final params = ParamsDoGetServices(
      storage: storage,
      filter: const FilterServiceModel(mine: true),
      geoDevice: geoDevice,
    );

    final result = await getIt<DoGetServices>().call(params: params);
    result.fold(
      (_) {},
      (paginator) {
        if (mounted) {
          setState(() {
            _hasCompany = paginator.headquarters.isNotEmpty;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final UserModel user = getIt<SettingBloc>().user ?? userModelFromJson("{}");
    final appLocalization = getIt<AppLocalizations>();

    return Scaffold(
      body: Stack(
        children: [
          FancyDrawerWrapper(
              backgroundColor: secondaryColorTheme,
              controller: widget.controller,
              hideOnContentTap: false,
              cornerRadius: rounded28,
              drawerPadding: EdgeInsets.zero,
              drawerItems: <Widget>[
                _HeaderNav(
                    width: width,
                    user: user,
                    appLocalization: appLocalization,
                    showPlaceSelector: _hasCompany,
                    currentHeadquarter: widget.currentHeadquarter),
                for (int i = 0; i < widget.listButtonNav.length; i++)
                  widget.listButtonNav[i].isLine
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getLineDivider(width * 0.5),
                          ],
                        )
                      : _GetButtonNav(
                          description: widget.listButtonNav[i].description,
                          icon: widget.listButtonNav[i].icon,
                          iconData: widget.listButtonNav[i].iconData,
                          iconSize: widget.listButtonNav[i].iconSize,
                          width: width,
                          showBadge: widget.listButtonNav[i].showBadge,
                          showRedDot: widget.listButtonNav[i].showRedDot,
                          customBadgeText:
                              widget.listButtonNav[i].customBadgeText,
                          customBadgeColor:
                              widget.listButtonNav[i].customBadgeColor,
                          onTapButton: widget.listButtonNav[i].onTapButton ??
                              () {
                                _toggleAlert();
                                widget.notifierNav
                                    .setRoute(widget.listButtonNav[i].goto);
                              },
                          isSelected: widget.notifierNav.routeName ==
                              widget.listButtonNav[i].goto),
                _GetButtonNav(
                    description: appLocalization.titleLogout,
                    icon: iconLogout,
                    width: width,
                    onTapButton: context.read<SignInCubit>().doSingOut),
              ],
              child: Stack(
                children: [
                  widget.child,
                  ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, child) {
                      return IgnorePointer(
                        ignoring: widget.controller.percentOpen == 0,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.controller.close();
                              },
                              child: Container(
                                color: Colors.black.withValues(
                                  alpha: 0.4 * widget.controller.percentOpen,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              top: 20,
                              child: Opacity(
                                opacity: widget.controller.percentOpen,
                                child: InkWell(
                                  onTap: () {
                                    widget.controller.close();
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: whiteColorTheme,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.25),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: secondaryColorTheme,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )),
          BlocListener<SignInCubit, SignInState>(
              listener: (context, state) {
                if (state is SignOutGetLoaded) {
                  context.pushReplacementNamed(SignInPage.routeName);
                }
              },
              child: const SizedBox.shrink())
        ],
      ),
    );
  }

  Widget _getLineDivider(double width) {
    return SizedBox(
      width: width,
      height: 2,
      child: const Divider(
        color: whiteColorTheme,
      ),
    );
  }

  void _toggleAlert() async {
    widget.controller.close();
  }
}

class ButtonNavModel {
  final String description;
  final String icon;
  final IconData? iconData;
  final bool isLine;
  final String goto;
  final VoidCallback? onTapButton;
  final bool showBadge;
  final bool showRedDot;
  final double? iconSize;
  final String? customBadgeText;
  final Color? customBadgeColor;

  ButtonNavModel({
    this.description = "",
    this.icon = "",
    this.iconData,
    this.goto = "",
    this.isLine = false,
    this.onTapButton,
    this.showBadge = false,
    this.showRedDot = false,
    this.iconSize,
    this.customBadgeText,
    this.customBadgeColor,
  });
}

class _GetButtonNav extends StatelessWidget {
  const _GetButtonNav({
    required this.description,
    required this.icon,
    this.iconData,
    required this.width,
    this.isSelected = false,
    this.onTapButton,
    this.showBadge = false,
    this.showRedDot = false,
    this.iconSize,
    this.customBadgeText,
    this.customBadgeColor,
  });

  final String description;
  final String icon;
  final IconData? iconData;
  final double width;
  final bool isSelected;
  final VoidCallback? onTapButton;
  final bool showBadge;
  final bool showRedDot;
  final double? iconSize;
  final String? customBadgeText;
  final Color? customBadgeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapButton,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: isSelected
                ? const BoxDecoration(
                    color: whiteColorTheme,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(rounded28),
                        topRight: Radius.circular(rounded28)))
                : null,
            width: width * 0.6,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: spaceBetween10 + 2),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      iconData != null
                          ? Icon(
                              iconData,
                              size: iconSize ?? 25,
                              color: isSelected
                                  ? secondaryColorTheme
                                  : whiteColorTheme,
                            )
                          : SvgPicture.asset(
                              alignment: Alignment.center,
                              '$pathManagementIcons$icon',
                              width: iconSize ?? 25,
                              height: iconSize ?? 25,
                              colorFilter: ColorFilter.mode(
                                  isSelected
                                      ? secondaryColorTheme
                                      : whiteColorTheme,
                                  BlendMode.srcIn),
                            ),
                      if (showBadge)
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen: (_, s) => s is UnreadCountUpdated,
                          builder: (ctx, state) {
                            final count = getIt<HomeBloc>().unreadCount;
                            if (count <= 0) return const SizedBox.shrink();
                            return Positioned(
                              top: -4,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                decoration: const BoxDecoration(
                                  color: cancelColorTheme,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  count > 99 ? '99+' : '$count',
                                  style: const TextStyle(
                                    color: whiteColorTheme,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      if (showRedDot)
                        Positioned(
                          top: -2,
                          right: -4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: cancelColorTheme,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            description,
                            style: TextStyle(
                                fontSize: h3Size,
                                color: isSelected
                                    ? secondaryColorTheme
                                    : whiteColorTheme,
                                fontFamily: fontFamilyMontserrat,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (customBadgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: customBadgeColor ?? seenColorTheme,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              customBadgeText!,
                              style: TextStyle(
                                color: primaryColorTheme,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                fontFamily: fontFamilyMontserrat,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

class _HeaderNav extends StatelessWidget {
  const _HeaderNav(
      {required this.width,
      required this.user,
      required this.appLocalization,
      required this.showPlaceSelector,
      this.currentHeadquarter});

  final double width;
  final UserModel user;
  final AppLocalizations appLocalization;
  final HeadquarterModel? currentHeadquarter;
  final bool showPlaceSelector;

  @override
  Widget build(BuildContext context) {
    final bool hasPlace =
        currentHeadquarter != null && currentHeadquarter!.id != 0;
    final String? imageToShow = hasPlace &&
            (currentHeadquarter!.companyInfo?.imageUrl?.isNotEmpty ?? false)
        ? currentHeadquarter!.companyInfo!.imageUrl
        : user.picture;
    final String titleToShow = hasPlace
        ? currentHeadquarter!.companyInfo?.name ?? ''
        : appLocalization.titleHi(user.fullName?.split(' ').first ?? "");

    final bool isLocalImage = imageToShow != null &&
        (imageToShow.startsWith('/') ||
            imageToShow.startsWith('file://') ||
            (!imageToShow.startsWith('http') && !imageToShow.startsWith('assets')));

    return Row(
      children: [
        const SizedBox(width: spaceBetween10 + 2),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleImageProfile(
            size: width * 0.13,
            showSubIcon: false,
            typeSourceImage: isLocalImage ? TypeSourceImage.file : TypeSourceImage.network,
            imageMain: imageToShow,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: width * 0.5,
              child: Text(
                titleToShow,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: h3Size,
                    color: whiteColorTheme,
                    fontFamily: fontFamilyMontserrat,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (showPlaceSelector) ...[
              const SizedBox(height: 2),
              InkWell(
                onTap: () {
                  OverlayController overlayController = OverlayController();
                  overlayController.initOverlay(
                      context: context,
                      onDismiss: () {
                        overlayController.hide();
                      },
                      width: width * 0.9,
                      child: PlaceSelectorMenu(
                          user: user,
                          appLocalization: appLocalization,
                          overlayController: overlayController));
                  overlayController.show();
                },
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(rounded28)),
                      border: Border.all(color: whiteColorTheme)),
                  child: Center(
                    child: Text(
                      appLocalization.sentenceChoosePlace,
                      style: const TextStyle(
                          color: whiteColorTheme,
                          fontFamily: fontFamilyMontserrat,
                          fontWeight: FontWeight.bold,
                          fontSize: h5Size),
                    ),
                  ),
                ),
              ),
            ],
          ],
        )
      ],
    );
  }
}
