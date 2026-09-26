import 'dart:convert';

import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/appointment/ui/appointment_detail_page.dart';
import 'package:ponte_glam/src/client/book/ui/book_page.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/confirmation_page.dart';
import 'package:ponte_glam/src/client/headquarter/ui/headquarter_detail_page.dart';
import 'package:ponte_glam/src/client/history/ui/history_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/notification/ui/notification_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/create_address_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/update_address_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/personal_information_widgets/personal_information_page.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/adresses_available_widget.dart';
import 'package:ponte_glam/src/client/recover_password/ui/recover_password_page.dart';
import 'package:ponte_glam/src/client/service/ui/service_detail_place.dart';
import 'package:ponte_glam/src/client/sign_in/ui/sign_in_page.dart';
import 'package:ponte_glam/src/client/sign_up/ui/sign_up_page.dart';
import 'package:ponte_glam/src/client/splash/ui/introduction_animation_page.dart';
import 'package:ponte_glam/src/client/splash/ui/splash_page.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';
import 'package:ponte_glam/src/supplier/notification/ui/supplier_notification_page.dart';
import 'package:ponte_glam/src/supplier/service/ui/create_service_page.dart';
import 'package:ponte_glam/src/supplier/service/ui/supplier_service_detail_page.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/create_headquarter_page.dart';
import 'package:ponte_glam/src/shared/wallet/ui/page/wallet_page.dart';
import 'package:ponte_glam/src/supplier/worker/ui/pages/worker_management_page.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';
import 'package:ponte_glam/src/supplier/worker/domain/repository/worker_repository.dart'
    as supplier_worker_domain;

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: SplashPage.routeName,
        name: SplashPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
        routes: [
          GoRoute(
              path: SignInPage.routeName,
              name: SignInPage.routeName,
              builder: (BuildContext context, GoRouterState state) {
                return SignInPage();
              },
              routes: [
                GoRoute(
                  path: RecoverPasswordPage.routeName,
                  name: RecoverPasswordPage.routeName,
                  builder: (BuildContext context, GoRouterState state) {
                    return const RecoverPasswordPage();
                  },
                ),
              ]),
          GoRoute(
            path: IntroductionAnimationPage.routeName,
            name: IntroductionAnimationPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const IntroductionAnimationPage();
            },
          ),
          GoRoute(
              path: SignUpPage.routeName,
              name: SignUpPage.routeName,
              builder: (BuildContext context, GoRouterState state) {
                return SignUpPage();
              },
              routes: [
                GoRoute(
                  path: ConfirmationAccountPage.routeName,
                  name: ConfirmationAccountPage.routeName,
                  builder: (BuildContext context, GoRouterState state) {
                    UserModel user = state.extra as UserModel;
                    final String? parameter =
                        state.uri.queryParameters['canSendCode'];
                    bool canSendCode = parameter == 'true';
                    return ConfirmationAccountPage(
                        user: user, canSendCode: canSendCode);
                  },
                ),
              ]),
        ]),
    GoRoute(
        path: '/${HomePage.routeName}',
        name: HomePage.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder: trasitionsAnimationScale);
        },
        routes: [
          GoRoute(
            path: ServiceDetailPage.routeName,
            name: ServiceDetailPage.routeName,
            routes: [
              GoRoute(
                path: BookPage.routeName,
                name: BookPage.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  final map = state.extra as Map<String, dynamic>;
                  HeadquarterModel headquarter =
                      headquarterModelFromJson(jsonEncode(map["headquarter"]));
                  ServiceModel service =
                      serviceModelFromJson(jsonEncode(map["service"]));
                  return BookPage(
                    headquarterModel: headquarter,
                    service: service,
                  );
                },
              ),
            ],
            builder: (BuildContext context, GoRouterState state) {
              final map = state.extra as Map<String, dynamic>;
              HeadquarterModel headquarter =
                  headquarterModelFromJson(jsonEncode(map["headquarter"]));
              ServiceModel service =
                  serviceModelFromJson(jsonEncode(map["service"]));
              return ServiceDetailPage(
                  headquarter: headquarter, service: service);
            },
          ),
          GoRoute(
            path: HeadquarterDetailPage.routeName,
            name: HeadquarterDetailPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              HeadquarterModel headquarter =
                  headquarterModelFromJson(jsonEncode(state.extra));
              return HeadquarterDetailPage(headquarter: headquarter);
            },
          ),
        ]),
    GoRoute(
        path: '/${HomePageSupplier.routeName}',
        name: HomePageSupplier.routeName,
        pageBuilder: (context, state) {
          HeadquarterModel headquarter = state.extra != null
              ? headquarterModelFromJson(jsonEncode(state.extra))
              : HeadquarterModel.empty();
          return CustomTransitionPage(
              key: state.pageKey,
              child: HomePageSupplier(
                headquarter: headquarter,
              ),
              transitionsBuilder: trasitionsAnimationScale);
        },
        routes: [
          GoRoute(
            path: CreateServicePage.routeName,
            name: CreateServicePage.routeName,
            pageBuilder: (context, state) {
              HeadquarterModel headquarter;
              ServiceModel? service;
              if (state.extra is Map) {
                final map = state.extra as Map<String, dynamic>;
                headquarter =
                    headquarterModelFromJson(jsonEncode(map["headquarter"]));
                if (map["service"] != null) {
                  service = serviceModelFromJson(jsonEncode(map["service"]));
                }
              } else {
                headquarter = state.extra != null
                    ? headquarterModelFromJson(jsonEncode(state.extra))
                    : HeadquarterModel.empty();
              }
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: CreateServicePage(
                      headquarter: headquarter, service: service),
                  transitionsBuilder: trasitionsAnimationSlide);
            },
          ),
          GoRoute(
            path: SupplierServiceDetailPage.routeName,
            name: SupplierServiceDetailPage.routeName,
            pageBuilder: (context, state) {
              final map = state.extra as Map<String, dynamic>;
              HeadquarterModel headquarter =
                  headquarterModelFromJson(jsonEncode(map["headquarter"]));
              ServiceModel service =
                  serviceModelFromJson(jsonEncode(map["service"]));
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: SupplierServiceDetailPage(
                      headquarter: headquarter, service: service),
                  transitionsBuilder: trasitionsAnimationScale);
            },
          ),
          GoRoute(
            path: SupplierNotificationPage.routeName,
            name: SupplierNotificationPage.routeName,
            pageBuilder: (context, state) {
              final FancyDrawerController? controllerMenu =
                  state.extra is FancyDrawerController
                      ? state.extra as FancyDrawerController
                      : null;
              return CustomTransitionPage(
                  key: state.pageKey,
                  child:
                      SupplierNotificationPage(controllerMenu: controllerMenu),
                  transitionsBuilder: trasitionsAnimationSlide);
            },
          ),
          GoRoute(
            path: CreateHeadquarterPage.routeName,
            name: CreateHeadquarterPage.routeName,
            pageBuilder: (context, state) {
              final int companyId = state.extra as int;
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: CreateHeadquarterPage(companyId: companyId),
                  transitionsBuilder: trasitionsAnimationSlide);
            },
          ),
          GoRoute(
            path: WorkerManagementPage.routeName,
            name: WorkerManagementPage.routeName,
            builder: (context, state) {
              final map = state.extra as Map<String, dynamic>;
              final int headquarterId = map['headquarterId'] as int;
              final List<ServiceModel> services =
                  map['services'] as List<ServiceModel>;

              return BlocProvider(
                create: (context) => WorkerManagementCubit(
                  getIt<supplier_worker_domain.WorkerRepository>(),
                  headquarterId,
                  services,
                ),
                child: WorkerManagementPage(headquarterId: headquarterId),
              );
            },
          ),
        ]),
    GoRoute(
      path: "/${NotificationPage.routeName}",
      name: NotificationPage.routeName,
      pageBuilder: (context, state) {
        final FancyDrawerController? controllerMenu =
            state.extra is FancyDrawerController
                ? state.extra as FancyDrawerController
                : null;
        return CustomTransitionPage(
            key: state.pageKey,
            child: NotificationPage(controllerMenu: controllerMenu),
            transitionsBuilder: trasitionsAnimationSlide);
      },
    ),
    GoRoute(
      path: "/${AppointmentHistory.routeName}",
      name: AppointmentHistory.routeName,
      pageBuilder: (context, state) {
        // Puede llegar FancyDrawerController (desde menú) o null (desde push notification)
        final extra = state.extra;
        final FancyDrawerController? controllerMenu =
            extra is FancyDrawerController ? extra : null;
        return CustomTransitionPage(
            key: state.pageKey,
            child: AppointmentHistory(controllerMenu: controllerMenu),
            transitionsBuilder: trasitionsAnimationSlide);
      },
      routes: [
        GoRoute(
          path: AppointmentDetailPage.routeName,
          name: AppointmentDetailPage.routeName,
          pageBuilder: (context, state) {
            // extra puede ser int (navegación normal) o Map (desde push notification)
            final extra = state.extra;
            int appointmentId;
            bool autoOpenRating = false;
            if (extra is Map) {
              appointmentId = extra['appointmentId'] as int;
              autoOpenRating = extra['autoOpenRating'] as bool? ?? false;
            } else {
              appointmentId = extra as int;
            }
            return CustomTransitionPage(
                key: state.pageKey,
                child: AppointmentDetailPage(
                  appointmentId: appointmentId,
                  autoOpenRating: autoOpenRating,
                ),
                transitionsBuilder: trasitionsAnimationSlide);
          },
        ),
      ],
    ),
    GoRoute(
        path: '/${ProfilePage.routeName}',
        name: ProfilePage.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
              transitionsBuilder: trasitionsAnimationScale);
        },
        routes: [
          GoRoute(
            path: PersonalInformationPage.routeName,
            name: PersonalInformationPage.routeName,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: const PersonalInformationPage(),
                  transitionsBuilder: trasitionsAnimationSlide);
            },
          ),
          GoRoute(
              path: AddressesPage.routeName,
              name: AddressesPage.routeName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddressesPage(),
                    transitionsBuilder: trasitionsAnimationSlide);
              },
              routes: [
                GoRoute(
                  path: CreateAddressWidget.routeName,
                  name: CreateAddressWidget.routeName,
                  pageBuilder: (context, state) {
                    final Position? currentPosition =
                        state.extra is Position ? state.extra as Position : null;
                    return CustomTransitionPage(
                        key: state.pageKey,
                        child: CreateAddressWidget(
                          currentPosition: currentPosition,
                        ),
                        transitionsBuilder: trasitionsAnimationSlide);
                  },
                ),
                GoRoute(
                  path: UpdateAddressWidget.routeName,
                  name: UpdateAddressWidget.routeName,
                  pageBuilder: (context, state) {
                    final AddressModel address = addressModelFromJson(
                        jsonEncode(state.extra as Map<String, dynamic>));
                    return CustomTransitionPage(
                        key: state.pageKey,
                        child: UpdateAddressWidget(addressModel: address),
                        transitionsBuilder: trasitionsAnimationSlide);
                  },
                ),
              ]),
        ]),
    GoRoute(
      path: "/${WalletPage.routeName}",
      name: WalletPage.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            key: state.pageKey,
            child: const WalletPage(),
            transitionsBuilder: trasitionsAnimationSlide);
      },
    ),
  ],
);

Widget trasitionsAnimationSlide(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

Widget trasitionsAnimationScale(context, animation, secondaryAnimation, child) {
  const curve = Curves.easeInOut;
  var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));

  return ScaleTransition(
    scale: animation.drive(tween),
    child: child,
  );
}
