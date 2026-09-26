import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/company_model.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_cubit.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_state.dart';
import 'package:ponte_glam/src/client/company/ui/widgets/step_company_info.dart';
import 'package:ponte_glam/src/client/company/ui/widgets/step_headquarter_info.dart';
import 'package:ponte_glam/src/client/company/ui/widgets/step_time_config.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/config/utils/overlay_util.dart';
import 'package:ponte_glam/shared/widgets/place_selector_menu.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/company/ui/widgets/company_intro_widget.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';

import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';

class CompanyCreationPage extends StatelessWidget {
  const CompanyCreationPage({super.key, this.controllerMenu, this.notifierNav});
  static const String routeName = 'company_creation';
  final FancyDrawerController? controllerMenu;
  final NotifierNav? notifierNav;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CompanyCreationCubit>(),
      child: CompanyCreationView(
        controllerMenu: controllerMenu,
        notifierNav: notifierNav,
      ),
    );
  }
}

class CompanyCreationView extends StatefulWidget {
  const CompanyCreationView({super.key, this.controllerMenu, this.notifierNav});
  final FancyDrawerController? controllerMenu;
  final NotifierNav? notifierNav;

  @override
  State<CompanyCreationView> createState() => _CompanyCreationViewState();
}

class _CompanyCreationViewState extends State<CompanyCreationView> {
  bool _checkingExistingCompany = true;
  bool _showIntro = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingCompany();
    });
  }

  Future<void> _checkExistingCompany() async {
    final storage = getIt<IStorage>();
    final geoDevice = getIt<GeoDevice>();
    final prefs = getIt<SharedPreferences>();

    final hasSeenIntro = prefs.getBool(keyCompanyIntroSeen) ?? false;

    final params = ParamsDoGetServices(
      storage: storage,
      filter: const FilterServiceModel(mine: true),
      geoDevice: geoDevice,
    );

    final result = await getIt<DoGetServices>().call(params: params);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _showIntro = !hasSeenIntro;
            _checkingExistingCompany = false;
          });
        }
      },
      (paginator) {
        if (paginator.headquarters.isNotEmpty) {
          if (mounted) {
            PonteSnackBar.show(
              context,
              message: 'Solo puedes tener una compañía registrada actualmente.',
              type: TypeAlert.error,
            );

            Future.microtask(() {
              if (mounted) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else if (widget.notifierNav != null) {
                  widget.notifierNav!.setRoute(HomePage.routeName);
                } else {
                  context.pushReplacement('/home');
                }
              }
            });

            final user = getIt<SettingBloc>().user ?? userModelFromJson("{}");
            final appLocalization = getIt<AppLocalizations>();
            final width = MediaQuery.of(context).size.width;

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
                overlayController: overlayController,
              ),
            );
            overlayController.show();
          }
        } else {
          if (mounted) {
            setState(() {
              _showIntro = !hasSeenIntro;
              _checkingExistingCompany = false;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<SettingBloc>().user ?? UserModel.empty();

    return Scaffold(
      backgroundColor: whiteColorTheme,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: CustomMainAppBar(
          iconMenu: widget.controllerMenu != null,
          controllerMenu: widget.controllerMenu,
          leftContent: 40,
          top: 20,
          textAppBar: 'Ofrecer servicio',
          subtitleAppBar: user.fullName ?? '',
          trailingAppBar: CircleImageProfile(
            size: MediaQuery.of(context).size.width * 0.13,
            showSubIcon: false,
            typeSourceImage: TypeSourceImage.network,
            imageMain: user.picture,
          ),
        ),
      ),
      body: _checkingExistingCompany
          ? const Center(
              child: CircularProgressIndicator(
                color: secondaryColorTheme,
              ),
            )
          : _showIntro
              ? CompanyIntroWidget(
                  onFinished: () {
                    setState(() {
                      _showIntro = false;
                    });
                  },
                )
              : BlocConsumer<CompanyCreationCubit, CompanyCreationState>(
              listener: (context, state) {
                if (state is CompanyCreationSuccess) {
                  PonteSnackBar.show(
                    context,
                    message: 'Lugar creado correctamente',
                    type: TypeAlert.success,
                  );

                  final headquarterId = state.form.createdHeadquarterId;
                  final headquarterModel = HeadquarterModel.empty().copyWith(
                    id: headquarterId,
                    companyInfo: CompanyModel.empty().copyWith(
                      name: state.form.companyName,
                      description: state.form.companyDescription,
                      imageUrl: state.form.companyProfileImagePath,
                    ),
                  );
                  if (headquarterId != null) {
                    getIt<SharedPreferences>().setInt(keyPlace, headquarterId);
                  }

                  context.pushReplacement(
                    '/${HomePageSupplier.routeName}',
                    extra: headquarterModel,
                  );
                }
                if (state is CompanyCreationError) {
                  PonteSnackBar.show(
                    context,
                    message: state.message,
                    type: TypeAlert.error,
                  );
                }
              },
              builder: (context, state) {
                final progress = (state.form.currentStep + 1) / 3;

                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: secondaryColorTheme.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(secondaryColorTheme),
                      minHeight: 4,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          IndexedStack(
                            index: state.form.currentStep,
                            children: [
                              StepCompanyInfo(form: state.form),
                              StepHeadquarterInfo(form: state.form),
                              StepTimeConfig(form: state.form),
                            ],
                          ),
                          if (state is CompanyCreationLoading)
                            Container(
                              color: Colors.black26,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: secondaryColorTheme,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
