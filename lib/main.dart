import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/routers/router.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/device/local_notifications/local_notification_service.dart';
import 'package:ponte_glam/di/modules_dp.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_cubit.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// The pragma is required so that the compiler does not eliminate this function
// in release builds (Dart AOT tree-shaking).
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationService.showFromRemoteMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(kDefaultTimezone));

  final results = await Future.wait([
    injectAsyncDependencies(),
    SharedPreferences.getInstance(),
  ]);
  final sharedPreferences = results[1] as SharedPreferences;
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  injectOverallDependencies();
  needRegisterModules();

  // Re-register FCM token whenever Firebase rotates it.
  FirebaseMessaging.instance.onTokenRefresh.listen(
    (newToken) async {
      final storage = getIt<IStorage>();
      final authToken = await storage.read(key: keyAuthToken);
      if (authToken != null) {
        final repo = getIt<SignInRepository>();
        await repo.registerFcmToken(authToken: authToken);
      }
    },
  );

  // Initialize the Android notification channel (required from API 26).
  await LocalNotificationService.init();

  // Terminated state: check if the app was opened by tapping a notification.
  // Must be queried BEFORE runApp to capture the payload before
  // the plugin discards it.
  final launchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runApp(const BlocsProviders());

  // If the app started from a local notification, navigate to the destination
  // after the widget tree (and router) are mounted.
  if (launchDetails?.didNotificationLaunchApp == true) {
    final payload = launchDetails!.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LocalNotificationService.navigateFromPayload(payload);
      });
    }
  }
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<SignInCubit>(
          create: (context) => getIt<SignInCubit>(), lazy: true),
      BlocProvider<AlertManageCubit>(
          create: (context) => getIt<AlertManageCubit>(), lazy: true),
      BlocProvider<SignUpCubit>(
          create: (context) => getIt<SignUpCubit>(), lazy: true),
      BlocProvider<RecoverCubit>(
          create: (context) => getIt<RecoverCubit>(), lazy: true),
      BlocProvider<ConfirmationCubit>(
          create: (context) => getIt<ConfirmationCubit>(), lazy: true),
      BlocProvider<HeadquarterCubit>(
          create: (context) => getIt<HeadquarterCubit>(), lazy: true),
      BlocProvider<SplashCubit>(
          create: (context) => getIt<SplashCubit>(), lazy: true),
      BlocProvider<HomeBloc>(
          create: (context) => getIt<HomeBloc>(), lazy: true),
      BlocProvider<WalletCubit>(
          create: (context) => getIt<WalletCubit>(), lazy: true),
      BlocProvider<SettingBloc>(
          create: (context) => getIt<SettingBloc>(), lazy: true),
      BlocProvider<ServiceBloc>(
          create: (context) => getIt<ServiceBloc>(), lazy: true),
      BlocProvider<WorkerBloc>(
          create: (context) => getIt<WorkerBloc>(), lazy: true),
      BlocProvider<SlotBloc>(
          create: (context) => getIt<SlotBloc>(), lazy: true),
      BlocProvider<CompanyCubit>(
          create: (context) => getIt<CompanyCubit>(), lazy: true),
      BlocProvider<ProfileCubit>(
          create: (context) => getIt<ProfileCubit>(), lazy: true),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Locale locale = View.of(context).platformDispatcher.locale;
    return MaterialApp.router(
      routerConfig: router,
      title: "PonteGlam",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'CO'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ligthTheme,
      locale: locale,
    );
  }
}
