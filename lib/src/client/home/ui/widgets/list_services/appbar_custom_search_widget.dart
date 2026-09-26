import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/adresses_available_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnimatedAppBarCustomSearch extends StatefulWidget {
  const AnimatedAppBarCustomSearch(
      {super.key,
      required this.width,
      required this.height,
      required this.controllerMenu,
      required this.percentage,
      this.iconMenu = false,
      this.pathRigthIcon = ""});
  final double width;
  final double height;
  final double percentage;
  final bool iconMenu;
  final String pathRigthIcon;
  final FancyDrawerController controllerMenu;

  @override
  State<AnimatedAppBarCustomSearch> createState() =>
      _AnimatedAppBarCustomSearchState();
}

class _AnimatedAppBarCustomSearchState extends State<AnimatedAppBarCustomSearch> {
  late Widget futureAddress;
  String addressUser = getIt<AppLocalizations>().titleNotIdentified;
  double width = 0;

  @override
  void initState() {
    futureAddress = FutureBuilder<List<Placemark>>(
      future: _getPositionUserAddress(),
      builder: (context, snapshot) {
        Placemark place =
            Placemark(street: getIt<AppLocalizations>().titleNotIdentified);
        if (snapshot.hasData) {
          place = snapshot.data!.isNotEmpty
              ? snapshot.data!.first
              : Placemark(street: getIt<AppLocalizations>().titleNotIdentified);
        }
        return InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: () async {
            final geo = getIt<GeoDevice>();
            if (!(await geo.isLocationServiceEnabled())) {
              if (context.mounted) {
                await geo.promptEnableLocation(context);
              }
            } else {
              if (context.mounted) {
                context
                    .push("/${ProfilePage.routeName}/${AddressesPage.routeName}");
              }
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getIt<AppLocalizations>().titleServices.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  color: secondaryColorTheme,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: whiteColorTheme.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: whiteColorTheme.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      alignment: Alignment.center,
                      "$pathManagementIcons$iconLocation",
                      width: 14,
                      semanticsLabel: iconLocation,
                      colorFilter: const ColorFilter.mode(
                          secondaryColorTheme, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Skeletonizer(
                        enabled: snapshot.connectionState ==
                            ConnectionState.waiting,
                        containersColor: Colors.transparent,
                        child: Text(
                          place.street ??
                              getIt<AppLocalizations>().titleNotIdentified,
                          style: const TextStyle(
                            fontFamily: fontFamilyLora,
                            fontSize: bodySize - 3,
                            color: whiteColorTheme,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 12,
                      color: whiteColorTheme.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      getIt<AppLocalizations>().titleAddresses.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.bold,
                        color: secondaryColorTheme,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      alignment: Alignment.center,
                      "$pathManagementIcons$iconDownArrow",
                      width: 8,
                      semanticsLabel: iconDownArrow,
                      colorFilter: const ColorFilter.mode(
                          whiteColorTheme, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      width: widget.width,
      height: 90,
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: appBarColorTheme,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(rounded28),
              bottomRight: Radius.circular(rounded28))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: widget.iconMenu ? 1 : 0,
            child: IgnorePointer(
              ignoring: !widget.iconMenu,
              child: InkWell(
                onTap: () {
                  widget.controllerMenu.toggle();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: appBarColorTheme,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.menu_rounded,
                        color: whiteColorTheme,
                        size: 22,
                      )),
                ),
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              futureAddress,
            ],
          ),
          const Spacer(),
          Opacity(
            opacity: widget.pathRigthIcon.isNotEmpty ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: appBarColorTheme,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Visibility(
                  visible: widget.pathRigthIcon.isNotEmpty,
                  child: SvgPicture.asset(
                    widget.pathRigthIcon,
                    semanticsLabel: iconMenu,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                        whiteColorTheme, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Placemark>> _getPositionUserAddress() async {
    try {
      var position = await getIt<GeoDevice>().getCurrentPosition();
      return getIt<GeoDevice>().getAddressFromPosition(position);
    } catch (e) {
      return [];
    }
  }
}
