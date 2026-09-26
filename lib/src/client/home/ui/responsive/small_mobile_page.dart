import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/fancy_drawer_widget.dart';
import 'package:ponte_glam/src/client/history/ui/history_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/home_detail_page.dart';
import 'package:ponte_glam/src/client/notification/ui/notification_page.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/shared/wallet/ui/page/wallet_page.dart';
import 'package:ponte_glam/src/client/company/ui/company_creation_page.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

class SmallMobileHomePage extends StatefulWidget {
  const SmallMobileHomePage(
      {super.key, required this.controllerMenu, required this.notifierNav});

  final FancyDrawerController controllerMenu;
  final NotifierNav notifierNav;

  @override
  State<SmallMobileHomePage> createState() => _SmallMobileHomePageState();
}

class _SmallMobileHomePageState extends State<SmallMobileHomePage> {
  bool _showRedDot = false;
  bool _hasCompany = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const DoGetUnreadCountEvent());
      _checkUserCompany();
    });
    _checkOfrecerServicioSeen();
  }

  Future<void> _checkUserCompany() async {
    try {
      final storage = getIt<IStorage>();
      final geoDevice = getIt<GeoDevice>();
      final params = ParamsDoGetServices(
        storage: storage,
        filter: const FilterServiceModel(mine: true),
        geoDevice: geoDevice,
      );

      final result = await getIt<DoGetServices>().call(params: params);
      result.fold(
        (failure) {},
        (paginator) {
          if (mounted) {
            setState(() {
              _hasCompany = paginator.headquarters.isNotEmpty;
            });
          }
        },
      );
    } catch (_) {}
  }

  void _checkOfrecerServicioSeen() {
    final prefs = getIt<SharedPreferences>();
    final hasSeen = prefs.getBool('has_seen_ofrecer_servicio') ?? false;
    setState(() {
      _showRedDot = !hasSeen;
    });
  }

  void _markOfrecerServicioAsSeen() {
    final prefs = getIt<SharedPreferences>();
    prefs.setBool('has_seen_ofrecer_servicio', true);
    setState(() {
      _showRedDot = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = getIt<AppLocalizations>();
    final controllerMenu = widget.controllerMenu;
    final notifierNav = widget.notifierNav;
    return SafeArea(
      child: FancyDrawerWrapperCustom(
          controller: controllerMenu,
          notifierNav: notifierNav,
          listButtonNav: [
            ButtonNavModel(
              description: appLocalization.titleServices,
              icon: iconPonteSecondary,
              goto: HomePage.routeName,
            ),
            ButtonNavModel(
                description: appLocalization.titleProfile,
                icon: iconProfile,
                goto: ProfilePage.routeName),
            if (!_hasCompany)
              ButtonNavModel(
                description: "Ofrecer servicio",
                iconData: Icons.storefront_rounded,
                showRedDot: _showRedDot,
                goto: CompanyCreationPage.routeName,
                onTapButton: () {
                  _markOfrecerServicioAsSeen();
                  controllerMenu.close();
                  notifierNav.setRoute(CompanyCreationPage.routeName);
                },
              ),
            // ButtonNavModel(
            //     description: appLocalization.titleWallet,
            //     iconData: Icons.account_balance_wallet_rounded,
            //     iconSize: 20,
            //     goto: WalletPage.routeName),
            ButtonNavModel(isLine: true),
            ButtonNavModel(
              description: appLocalization.titleNotification,
              icon: iconNotification,
              goto: NotificationPage.routeName,
              showBadge: true,
            ),
            ButtonNavModel(
              description: appLocalization.titleCalendar,
              icon: iconCalendar,
              goto: AppointmentHistory.routeName,
            ),
            ButtonNavModel(
              description: "Ayuda / PQRS",
              iconData: Icons.help_outline_rounded,
              onTapButton: () async {
                final url = Uri.parse(getIt<EndPoints>().createPQRSUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ButtonNavModel(isLine: true),
          ],
          child: Scaffold(
            backgroundColor: backgroundColorTheme,
            body: ListenableBuilder(
              builder: (context, child) {
                switch (notifierNav.routeName) {
                  case HomePage.routeName:
                    return HomeDetailPage(
                      controllerMenu: controllerMenu,
                    );
                  case ProfilePage.routeName:
                    return ProfilePage(
                      controllerMenu: controllerMenu,
                    );
                  case CompanyCreationPage.routeName:
                    return CompanyCreationPage(
                      controllerMenu: controllerMenu,
                      notifierNav: notifierNav,
                    );
                  case WalletPage.routeName:
                    return WalletPage(
                      controllerMenu: controllerMenu,
                    );
                  case NotificationPage.routeName:
                    return NotificationPage(
                      controllerMenu: controllerMenu,
                    );
                  case AppointmentHistory.routeName:
                    return AppointmentHistory(
                      controllerMenu: controllerMenu,
                    );
                  default:
                    return const Text("No route found");
                }
              },
              listenable: notifierNav,
            ),
          )),
    );
  }
}
