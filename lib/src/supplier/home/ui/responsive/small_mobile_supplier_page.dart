import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/widgets/fancy_drawer_widget.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';
import 'package:ponte_glam/src/supplier/home/ui/widgets/list_services/home_detail_page.dart';
import 'package:ponte_glam/src/supplier/company/ui/edit_company_page.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/create_headquarter_page.dart';
import 'package:ponte_glam/src/supplier/notification/ui/supplier_notification_page.dart';
import 'package:ponte_glam/src/supplier/worker/ui/pages/worker_management_page.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';
import 'package:ponte_glam/src/supplier/worker/domain/repository/worker_repository.dart'
    as supplier_worker_domain;
import 'package:ponte_glam/src/shared/wallet/ui/page/wallet_page.dart';
import 'package:ponte_glam/src/supplier/addon/ui/pages/addon_management_page.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_cubit.dart';

class SmallMobileHomeSupplierPage extends StatefulWidget {
  const SmallMobileHomeSupplierPage(
      {super.key,
      required this.controllerMenu,
      required this.notifierNav,
      required this.headquarter,
      required this.refreshCount,
      required this.onRefreshData});

  final FancyDrawerController controllerMenu;
  final NotifierNav notifierNav;
  final HeadquarterModel headquarter;
  final int refreshCount;
  final VoidCallback onRefreshData;

  @override
  State<SmallMobileHomeSupplierPage> createState() =>
      _SmallMobileHomeSupplierPageState();
}

class _SmallMobileHomeSupplierPageState
    extends State<SmallMobileHomeSupplierPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carga el badge inicial para esta sede/empresa
      context
          .read<HomeBloc>()
          .add(DoGetUnreadCountEvent(companyId: widget.headquarter.companyId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = getIt<AppLocalizations>();
    return SafeArea(
      child: FancyDrawerWrapperCustom(
          controller: widget.controllerMenu,
          notifierNav: widget.notifierNav,
          currentHeadquarter: widget.headquarter,
          listButtonNav: [
            ButtonNavModel(
              description: appLocalization.titleServices,
              icon: iconPonteSecondary,
              goto: HomePageSupplier.routeName,
            ),
            ButtonNavModel(
              description: "Personal",
              iconData: Icons.people_outline,
              goto: WorkerManagementPage.routeName,
            ),
            ButtonNavModel(
              description: "Adicionales",
              iconData: Icons.extension_outlined,
              goto: AddonManagementPage.routeName,
            ),
            ButtonNavModel(
              description: "Notificaciones",
              icon: iconNotification,
              goto: SupplierNotificationPage.routeName,
              showBadge: true,
            ),
            ButtonNavModel(
              description: "Editar empresa",
              icon: iconEdit,
              goto: EditCompanyPage.routeName,
            ),
            // "Crear sede" deshabilitado temporalmente para esta versión.
            // ButtonNavModel(
            //   description: "Crear sede",
            //   icon: iconBuilding,
            //   goto: CreateHeadquarterPage.routeName,
            // ),
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

            // ButtonNavModel(
            //     description: appLocalization.titleWallet,
            //     iconData: Icons.account_balance_wallet_rounded,
            //     iconSize: 20,
            //     goto: WalletPage.routeName),
          ],
          child: Scaffold(
            backgroundColor: backgroundColorTheme,
            body: ListenableBuilder(
              builder: (context, child) {
                 switch (widget.notifierNav.routeName) {
                  case HomePageSupplier.routeName:
                    return HomeDetailSupplierPage(
                      controllerMenu: widget.controllerMenu,
                      headquarter: widget.headquarter,
                      refreshCount: widget.refreshCount,
                      onRefreshData: widget.onRefreshData,
                    );
                  case SupplierNotificationPage.routeName:
                    return SupplierNotificationPage(
                        companyId: widget.headquarter.companyId,
                        headquarter: widget.headquarter,
                        controllerMenu: widget.controllerMenu);
                  case WorkerManagementPage.routeName:
                    return BlocProvider(
                      create: (context) => WorkerManagementCubit(
                        getIt<supplier_worker_domain.WorkerRepository>(),
                        widget.headquarter.id,
                        widget.headquarter.services,
                      ),
                      child: WorkerManagementPage(
                        headquarterId: widget.headquarter.id,
                        controllerMenu: widget.controllerMenu,
                      ),
                    );
                  case AddonManagementPage.routeName:
                    return BlocProvider(
                      create: (context) => getIt<AddonCubit>(),
                      child: AddonManagementPage(
                        headquarter: widget.headquarter,
                        controllerMenu: widget.controllerMenu,
                      ),
                    );
                  case EditCompanyPage.routeName:
                    return EditCompanyPage(
                      companyId: widget.headquarter.companyId ?? 0,
                      initialName: widget.headquarter.companyInfo?.name ?? '',
                      initialDescription:
                          widget.headquarter.companyInfo?.description,
                      imageUrl: widget.headquarter.companyInfo?.imageUrl,
                      initialNequiNumber:
                          widget.headquarter.companyInfo?.nequiNumber,
                      controllerMenu: widget.controllerMenu,
                      onSuccess: () {
                        widget.onRefreshData();
                        widget.notifierNav.setRoute(HomePageSupplier.routeName);
                      },
                    );
                  case CreateHeadquarterPage.routeName:
                    return CreateHeadquarterPage(
                      companyId: widget.headquarter.companyId ?? 0,
                      controllerMenu: widget.controllerMenu,
                      onSuccess: () {
                        widget.onRefreshData();
                        widget.notifierNav.setRoute(HomePageSupplier.routeName);
                      },
                    );
                  case WalletPage.routeName:
                    return WalletPage(
                      controllerMenu: widget.controllerMenu,
                    );
                  default:
                    return const Text("No route found");
                }
              },
              listenable: widget.notifierNav,
            ),
          )),
    );
  }
}
