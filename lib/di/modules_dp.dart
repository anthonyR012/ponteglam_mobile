import 'package:flutter/material.dart';
import 'package:ponte_glam/src/shared/wallet/data/datasource/wallet_datasource.dart';
import 'package:ponte_glam/src/shared/wallet/data/implement/wallet_api_datasource.dart';
import 'package:ponte_glam/src/shared/wallet/domain/implement/wallet_repository_impl.dart';
import 'package:ponte_glam/src/shared/wallet/domain/repository/wallet_repository.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_cubit.dart';
import 'package:ponte_glam/src/client/appointment/data/datasource/appointment_datasource.dart';
import 'package:ponte_glam/src/client/appointment/data/implement/appointment_api_datasource.dart';
import 'package:ponte_glam/src/client/appointment/domain/implement/appointment_repository_impl.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_cancel_appointment.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_confirm_cash_appointment.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_get_appointment_detail.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_list_appointments.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_reschedule_appointment.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_rate_service.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_list_supplier_appointments.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/confirm_cash_payment_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/supplier_service_appointments_cubit.dart';
import 'package:ponte_glam/src/client/book/data/datasource/booking_datasource.dart';
import 'package:ponte_glam/src/client/book/data/implement/booking_api_datasource.dart';
import 'package:ponte_glam/src/client/book/domain/implement/booking_implement.dart';
import 'package:ponte_glam/src/client/book/domain/repository/booking_repository.dart';
import 'package:ponte_glam/src/client/book/domain/use_case/do_create_appointment.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_cubit.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_delete_user_address.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_get_user_addresses.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_update_user_address.dart';
import 'package:ponte_glam/src/client/company/data/datasource/company_datasource.dart';
import 'package:ponte_glam/src/client/company/data/implement/company_api_datasource_implement.dart';
import 'package:ponte_glam/src/client/company/data/implement/company_repository_implement.dart';
import 'package:ponte_glam/src/client/company/domain/repository/company_repository.dart';
import 'package:ponte_glam/src/client/company/domain/use_case/do_create_company_use_cases.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_cubit.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_cities.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_countries.dart';
import 'package:ponte_glam/src/client/rate/domain/use_case/do_reply_rating.dart';
import 'package:ponte_glam/src/client/sign_up/domain/use_case/get_legal_content.dart';
import 'package:ponte_glam/src/supplier/service/data/datasource/service_creation_datasource.dart';
import 'package:ponte_glam/src/supplier/service/data/implement/service_creation_api_datasource_implement.dart';
import 'package:ponte_glam/src/supplier/service/domain/implement/service_creation_repository_implement.dart';
import 'package:ponte_glam/src/supplier/service/domain/repository/service_creation_repository.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_create_service.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_update_service.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_delete_service.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/company/data/datasource/company_datasource.dart'
    as supplier_company;
import 'package:ponte_glam/src/supplier/company/data/implement/company_api_datasource.dart';
import 'package:ponte_glam/src/supplier/company/domain/implement/company_implement.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart'
    as supplier_company_repo;
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_update_company.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_delete_company.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_request_nequi_update.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_update_nequi_number.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_cubit.dart';
import 'package:ponte_glam/src/supplier/headquarter/data/datasource/headquarter_datasource.dart'
    as supplier_hq;
import 'package:ponte_glam/src/supplier/headquarter/data/implement/headquarter_api_datasource.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/implement/headquarter_implement.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/repository/headquarter_repository.dart'
    as supplier_hq_repo;
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_delete_headquarter.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_update_headquarter.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_get_week_configuration.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_cubit.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/datasource/worker_datasource.dart'
    as supplier_worker;
import 'package:ponte_glam/src/supplier/worker/data/implement/worker_api_datasource.dart'
    as supplier_worker_api;
import 'package:ponte_glam/src/supplier/worker/data/implement/worker_repository_implement.dart'
    as supplier_worker_repo;
import 'package:ponte_glam/src/supplier/worker/domain/repository/worker_repository.dart'
    as supplier_worker_domain;

import 'package:ponte_glam/src/shared/core/log/data/datasource/log_datasource.dart';
import 'package:ponte_glam/src/shared/core/log/data/implement/log_api_datasource.dart';
import 'package:ponte_glam/src/shared/core/log/data/interceptor/mobile_log_interceptor.dart';
import 'package:ponte_glam/src/shared/core/log/domain/implement/log_repository_impl.dart';
import 'package:ponte_glam/src/shared/core/log/domain/repository/log_repository.dart';
import 'package:ponte_glam/src/shared/core/log/domain/use_case/create_mobile_log.dart';
import 'package:ponte_glam/src/supplier/addon/data/datasource/addon_datasource.dart';
import 'package:ponte_glam/src/supplier/addon/data/implement/addon_api_datasource.dart';
import 'package:ponte_glam/src/supplier/addon/domain/implement/addon_implement.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_create_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_delete_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_update_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_get_service_addons.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_link_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_unlink_addon.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_cubit.dart';
import './shared_imports.dart';

///  * [injectOverallDependencies] inject all required instances for the application,
/// you can access to one of them by using the following structure: [getIt<DependencyName>()]
/// As you can see, there are several dependency that recived parameters, nevertheless, I am passing
/// this dependency as : [getIt()] The reason is because the library seek for the correct instance for us.
void injectOverallDependencies() {
  Dio dioHttp = Dio();
  dioHttp.options = BaseOptions(validateStatus: (status) => true);
  getIt.registerLazySingleton(() => dioHttp);

  getIt.registerLazySingleton(() => GoogleSignIn(scopes: ['profile', 'email']));
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  AndroidOptions getAndroidOptions() => const AndroidOptions();
  final flutterStorage = FlutterSecureStorage(aOptions: getAndroidOptions());
  IStorage iStorage = MyStorage(flutterStorage);
  getIt.registerLazySingleton<IStorage>(() => iStorage);
  final stateNetwork = NetworkState(Connectivity());
  stateNetwork.watchConnectionState();
  getIt.registerLazySingleton(() => stateNetwork);

  getIt.registerLazySingleton(() => GeoDevice());
  getIt.registerLazySingleton(() => PermissionHandle());
  getIt.registerLazySingleton(() => FormatCurrencyUtil());
  getIt.registerLazySingleton(() => DateFormatUtil());
  getIt.registerLazySingleton(() => FailureManage());
  getIt.registerLazySingleton<FirebaseMessaging>(
      () => FirebaseMessaging.instance);

  // LOGS
  _registerOrUnregister<LogDatasource>(() =>
      LogApiDatasourceImplement(getIt(), getIt(), getIt(), getIt<IStorage>()));
  _registerOrUnregister<LogRepository>(() => LogRepositoryImpl(getIt()));
  _registerOrUnregister<CreateMobileLog>(() => CreateMobileLog(getIt()));

  dioHttp.interceptors.add(MobileLogInterceptor(getIt()));
}

void injectBuildDependencies(BuildContext context) {
  getIt.registerLazySingleton<AppLocalizations>(
      () => AppLocalizations.of(context));
  //alert overlay
  getIt.registerSingleton<AlertManageUtil>(
      AlertManageUtil(buildContext: context));
}

Future<void> injectAsyncDependencies() async {
  //firebase
  FirebaseApp firebaseApp;
  if (Firebase.apps.isEmpty) {
    try {
      firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        firebaseApp = Firebase.app();
      } else {
        rethrow;
      }
    }
  } else {
    firebaseApp = Firebase.app();
  }
  getIt.registerSingleton<FirebaseApp>(firebaseApp);
  //device info
  getIt.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());
  //end points
  getIt.registerLazySingleton(() => EndPoints());
}

void needRegisterModules() {
  injectSettingDatasource();
  injectNotificationDatasource();
  injectSplashDatasource();
  injectSignInDatasource();
  injectSignUpDatasource();
  injectProfileDatasource();
  injectWalletDatasource();

  authRegisterModules();
  homeRegisterModules();
  blocsModulesRegister();
}

void authRegisterModules() {
  injectRecoverPassDatasource();
  injectConfirmationAccountDatasource();
}

void homeRegisterModules() {
  injectHomeDatasource();
  injectServiceDatasource();
  injectHeadquarterDatasource();
  injectWorkerDatasource();
  injectBookingDatasource();
  injectAppointmentDatasource();
  injectCompanyDatasource();
  injectServiceCreationDatasource();
  injectRatingDatasource();
  injectSupplierCompanyDatasource();
  injectSupplierHeadquarterDatasource();
  injectSupplierWorkerDatasource();
  injectAddonDatasource();
}

void injectSupplierCompanyDatasource() {
  _registerOrUnregister<supplier_company.SupplierCompanyDatasource>(
      () => SupplierCompanyApiDatasource(getIt(), getIt()));
  _registerOrUnregister<supplier_company_repo.SupplierCompanyRepository>(
      () => SupplierCompanyImplement(datasource: getIt(), storage: getIt()));
  _registerOrUnregister<DoUpdateCompany>(() => DoUpdateCompany(getIt()));
  _registerOrUnregister<DoDeleteCompany>(() => DoDeleteCompany(getIt()));
  _registerOrUnregister<DoRequestNequiUpdate>(() => DoRequestNequiUpdate(getIt()));
  _registerOrUnregister<DoUpdateNequiNumber>(() => DoUpdateNequiNumber(getIt()));
  _registerOrUnregister<CompanyCubit>(
      () => CompanyCubit(
            doUpdateCompany: getIt(),
            doDeleteCompany: getIt(),
            doRequestNequiUpdate: getIt(),
            doUpdateNequiNumber: getIt(),
          ));
}

void injectSupplierHeadquarterDatasource() {
  _registerOrUnregister<supplier_hq.SupplierHeadquarterDatasource>(
      () => SupplierHeadquarterApiDatasource(getIt(), getIt()));
  _registerOrUnregister<supplier_hq_repo.SupplierHeadquarterRepository>(() =>
      SupplierHeadquarterImplement(datasource: getIt(), storage: getIt()));
  _registerOrUnregister<DoDeleteHeadquarter>(
      () => DoDeleteHeadquarter(getIt()));
  _registerOrUnregister<DoUpdateHeadquarter>(
      () => DoUpdateHeadquarter(getIt()));
  _registerOrUnregister<DoGetWeekConfiguration>(
      () => DoGetWeekConfiguration(getIt()));
  _registerOrUnregister<SupplierHeadquarterCubit>(
      () => SupplierHeadquarterCubit(doDeleteHeadquarter: getIt()),
      isFactory: true);
  if (getIt.isRegistered<HeadquarterCreationCubit>()) {
    getIt.unregister<HeadquarterCreationCubit>();
  }
  getIt.registerFactoryParam<HeadquarterCreationCubit, int,
          HeadquarterFormModel?>(
      (companyId, initialForm) => HeadquarterCreationCubit(
            companyId: companyId,
            sharedPreferences: getIt(),
            doCreateHeadquarter: getIt(),
            doCreateTimeConfig: getIt(),
            doUpdateHeadquarter: getIt(),
            doGetWeekConfiguration: getIt(),
            isEditing: initialForm != null,
            initialForm: initialForm,
          ));
}

void injectRatingDatasource() {
  _registerOrUnregister<RatingApiDatasource>(
      () => RatingApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<RatingRepository>(
      () => RatingRepositoryImpl(getIt<RatingApiDatasource>()));
  _registerOrUnregister<DoListRatings>(() => DoListRatings(getIt()));
  _registerOrUnregister<DoCreateRating>(() => DoCreateRating(getIt()));
  _registerOrUnregister<DoReplyRating>(() => DoReplyRating(getIt()));
  _registerOrUnregister<RatingCubit>(
      () => RatingCubit(
            doListRatings: getIt(),
            doCreateRating: getIt(),
            doReplyRating: getIt(),
          ),
      isFactory: true);
}

void injectServiceCreationDatasource() {
  _registerOrUnregister<ServiceCreationDatasource>(
      () => ServiceCreationApiDatasourceImplement(getIt(), getIt()));
  _registerOrUnregister<ServiceCreationRepository>(() =>
      ServiceCreationRepositoryImplement(
          datasource: getIt(), storage: getIt()));
  _registerOrUnregister<DoCreateService>(() => DoCreateService(getIt()));
  _registerOrUnregister<DoUpdateService>(() => DoUpdateService(getIt()));
  _registerOrUnregister<DoDeleteService>(() => DoDeleteService(getIt()));
  _registerOrUnregister<ServiceCreationCubit>(
      () => ServiceCreationCubit(
          doCreateService: getIt(),
          doUpdateService: getIt(),
          doGetCategories: getIt(),
          doGetTypesByCategory: getIt(),
          doGetAmenities: getIt(),
          doDeleteService: getIt()),
      isFactory: true);
}

void injectCompanyDatasource() {
  _registerOrUnregister<CompanyApiDatasource>(
      () => CompanyApiDatasourceImplement(getIt(), getIt()));
  _registerOrUnregister<CompanyRepository>(
      () => CompanyRepositoryImplement(datasource: getIt(), storage: getIt()));
  _registerOrUnregister<DoCreateCompany>(() => DoCreateCompany(getIt()));
  _registerOrUnregister<DoCreateHeadquarter>(
      () => DoCreateHeadquarter(getIt()));
  _registerOrUnregister<DoCreateTimeConfig>(() => DoCreateTimeConfig(getIt()));
  _registerOrUnregister<CompanyCreationCubit>(
      () => CompanyCreationCubit(
          sharedPreferences: getIt(),
          doCreateCompany: getIt(),
          doCreateHeadquarter: getIt(),
          doCreateTimeConfig: getIt()),
      isFactory: true);
}

void injectAppointmentDatasource() {
  _registerOrUnregister<AppointmentDatasource>(() =>
      AppointmentApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<AppointmentRepository>(
      () => AppointmentRepositoryImpl(getIt<AppointmentDatasource>()));
  _registerOrUnregister<DoListAppointments>(
      () => DoListAppointments(repository: getIt()));
  _registerOrUnregister<DoGetAppointmentDetail>(
      () => DoGetAppointmentDetail(repository: getIt()));
  _registerOrUnregister<DoCancelAppointment>(
      () => DoCancelAppointment(repository: getIt()));
  _registerOrUnregister<DoRescheduleAppointment>(
      () => DoRescheduleAppointment(repository: getIt()));
  _registerOrUnregister<DoConfirmCashAppointment>(
      () => DoConfirmCashAppointment(repository: getIt()));
  _registerOrUnregister<DoRateService>(
      () => DoRateService(repository: getIt()));
  _registerOrUnregister<AppointmentCubit>(
      () => AppointmentCubit(
            doListAppointments: getIt(),
            doGetAppointmentDetail: getIt(),
            doCancelAppointment: getIt(),
            doRescheduleAppointment: getIt(),
            doRateService: getIt(),
          ),
      isFactory: true);
  _registerOrUnregister<DoListSupplierAppointments>(
      () => DoListSupplierAppointments(getIt()));
  _registerOrUnregister<SupplierServiceAppointmentsCubit>(
      () => SupplierServiceAppointmentsCubit(
            doListSupplierAppointments: getIt(),
            storage: getIt(),
          ),
      isFactory: true);
  _registerOrUnregister<ConfirmCashPaymentCubit>(
      () => ConfirmCashPaymentCubit(doConfirmCashAppointment: getIt()),
      isFactory: true);
}

void injectBookingDatasource() {
  _registerOrUnregister<BookingDatasource>(
      () => BookingApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<BookingRepository>(
      () => BookingImplement(getIt<BookingDatasource>()));
  _registerOrUnregister<DoCreateAppointment>(
      () => DoCreateAppointment(repository: getIt()));
  _registerOrUnregister<BookingCubit>(
      () => BookingCubit(getIt<BookingRepository>()),
      isFactory: true);
}

void injectWorkerDatasource() {
  _registerOrUnregister<WorkerApiDatasource>(
      () => WorkerApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<WorkerRepository>(
      () => WorkerImplement(getIt<WorkerApiDatasource>()));
  _registerOrUnregister<DoGetWorkers>(() => DoGetWorkers(getIt()));
}

void injectSplashDatasource() {
  // ---------------SPLASH MODULE--------------
  // * [SPLASH]
  _registerOrUnregister<SplashDatasource>(() => SplashDatasourceApiImplement());
  _registerOrUnregister<SplashRepository>(() => SplashImplement(getIt()));
  //USES CASES
  _registerOrUnregister<DoInitApp>(() => DoInitApp());
}

void blocsModulesRegister() {
  _registerOrUnregister<SettingBloc>(
      () => SettingBloc(getIt(), getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<AlertManageCubit>(() => AlertManageCubit());
  _registerOrUnregister<SplashCubit>(() => SplashCubit(
        getIt(),
      ));
  _registerOrUnregister<SignInCubit>(() => SignInCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));
  _registerOrUnregister<ConfirmationCubit>(() => ConfirmationCubit(
        getIt(),
        getIt(),
      ));
  _registerOrUnregister<SignUpCubit>(() => SignUpCubit(
        getIt(),
      ));
  _registerOrUnregister<RecoverCubit>(() => RecoverCubit(
        getIt(),
        getIt(),
        getIt(),
      ));
  _registerOrUnregister<ServiceBloc>(() => ServiceBloc(
        getIt(),
      ));
  _registerOrUnregister<HomeBloc>(() => HomeBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));
  _registerOrUnregister<WorkerBloc>(() => WorkerBloc(getIt()));
  _registerOrUnregister<SlotBloc>(() => SlotBloc(getIt()));
  _registerOrUnregister<HeadquarterCubit>(() => HeadquarterCubit(getIt()));
}

void injectSettingDatasource() {
  _registerOrUnregister<SettingApiDatasourceImplement>(
      () => SettingApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<SettingRepository>(
      () => SettingImplement(getIt<SettingApiDatasourceImplement>()));
  _registerOrUnregister<DoGetUser>(() => DoGetUser(getIt<SharedPreferences>()));
  _registerOrUnregister<DoGetCategories>(() => DoGetCategories(getIt()));
  _registerOrUnregister<DoGetTypes>(() => DoGetTypes(getIt()));
  _registerOrUnregister<DoGetAmenities>(() => DoGetAmenities(getIt()));
  _registerOrUnregister<DoGetTypesByCategory>(
      () => DoGetTypesByCategory(getIt()));
  _registerOrUnregister<DoGetCities>(() => DoGetCities(getIt()));
  _registerOrUnregister<DoGetCountries>(() => DoGetCountries(getIt()));
}

void injectSignInDatasource() {
  _registerOrUnregister<SingInFirebaseDatasource>(() =>
      SignInFirebaseDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<SingInApiDatasource>(
      () => SignInApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<SingInLocalDatasource>(
      () => SignInLocalDatasourceImplement(getIt()));
  _registerOrUnregister<SignInRepository>(() => SignInImplement(
      getIt<SingInApiDatasource>(),
      getIt<SingInLocalDatasource>(),
      getIt<SingInFirebaseDatasource>(),
      getIt<IStorage>(),
      getIt<FirebaseMessaging>()));
  _registerOrUnregister<DoSignIn>(() => DoSignIn(getIt()));
  _registerOrUnregister<DoSignOut>(() => DoSignOut(getIt()));
  _registerOrUnregister<DoSaveUser>(() => DoSaveUser(getIt()));
}

void injectServiceDatasource() {
  _registerOrUnregister<ServiceLocalDatasourceImplement>(
      () => ServiceLocalDatasourceImplement(getIt(), getIt()));
  _registerOrUnregister<ServiceRepository>(
      () => ServiceImplement(getIt<ServiceLocalDatasourceImplement>()));
  _registerOrUnregister<DoGetAmenity>(() => DoGetAmenity(getIt()));
  _registerOrUnregister<DoMakeCall>(() => DoMakeCall());
}

void injectSignUpDatasource() {
  // ---------------SIGN UP MODULE --------------
  // * [SIGN UP]
  _registerOrUnregister<SignUpDatasource>(
      () => SignUpApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<SignUpRepository>(() => SingUpImplement(
        getIt<SignUpDatasource>(),
      ));
  //USES CASES
  _registerOrUnregister<DoSignUp>(() => DoSignUp(getIt()));
  // * [TERMS AND CONDITIONS]
  _registerOrUnregister<TermsDatasource>(
      () => TermsApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<TermsRepository>(
      () => TermsImplement(getIt<TermsDatasource>()));
  _registerOrUnregister<DoAcceptTerms>(() => DoAcceptTerms(getIt()));
  _registerOrUnregister<GetLegalContent>(() => GetLegalContent(getIt()));
}

void injectProfileDatasource() {
  // ---------------SIGN UP MODULE --------------
  // * [SIGN UP]
  _registerOrUnregister<ProfileApiDatasourceImplement>(
      () => ProfileApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<ProfileRepository>(() => ProfileImplement(
        getIt<ProfileApiDatasourceImplement>(),
      ));
  //USES CASES
  _registerOrUnregister<DoCreateUserAddress>(
      () => DoCreateUserAddress(getIt()));
  _registerOrUnregister<DoGetUserAddresses>(() => DoGetUserAddresses(getIt()));
  _registerOrUnregister<DoUpdateUserAddresses>(
      () => DoUpdateUserAddresses(getIt()));
  _registerOrUnregister<DoDeleteUserAddress>(
      () => DoDeleteUserAddress(getIt()));
  _registerOrUnregister<DoUpdateUserInformation>(
      () => DoUpdateUserInformation(getIt()));
  _registerOrUnregister<DoRequestCreatePassword>(
      () => DoRequestCreatePassword(getIt()));
  _registerOrUnregister<DoConfirmCreatePassword>(
      () => DoConfirmCreatePassword(getIt()));
  _registerOrUnregister<DoUpdateUserPassword>(
      () => DoUpdateUserPassword(getIt()));

  // CUBITS
  _registerOrUnregister<ProfileCubit>(
      () => ProfileCubit(
            doUpdateUserInformation: getIt(),
            doRequestCreatePassword: getIt(),
            doConfirmCreatePassword: getIt(),
            doUpdateUserPassword: getIt(),
          ),
      isFactory: true);
}

void injectWalletDatasource() {
  _registerOrUnregister<WalletApiDatasource>(
      () => WalletApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<WalletRepository>(
      () => WalletRepositoryImpl(getIt<WalletApiDatasource>()));
  _registerOrUnregister<WalletCubit>(
      () => WalletCubit(repository: getIt<WalletRepository>()),
      isFactory: true);
}

void injectRecoverPassDatasource() {
  // ---------------RECOVER PASS MODULE--------------
  // * [RECOVER PASS]
  _registerOrUnregister<RecoverPassDatasource>(
      () => RecoverApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<RecoverPassRepository>(
      () => RecoverPassImplement(getIt<RecoverPassDatasource>()));
  //USES CASES
  _registerOrUnregister<DoUpdatePassword>(() => DoUpdatePassword(getIt()));
  _registerOrUnregister<DoRecoverSendEmail>(() => DoRecoverSendEmail(getIt()));
  _registerOrUnregister<DoRecoverVerifyCode>(
      () => DoRecoverVerifyCode(getIt()));
}

void injectHomeDatasource() {
  // ---------------HOME MODULE--------------
  // * [HOME]
  _registerOrUnregister<HomeApiDatasource>(
      () => HomeApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<HomeRepository>(
      () => HomeImplement(getIt<HomeApiDatasource>()));
  //USES CASES
  _registerOrUnregister<DoGetServices>(() => DoGetServices(getIt()));
}

void injectConfirmationAccountDatasource() {
  // ---------------CONFIRMATION ACCOUNT MODULE--------------
  // * [CONFIRMATION ACCOUNT]
  _registerOrUnregister<ConfirmationAccountDatasource>(() =>
      ConfirmationAccountApiDatasource(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<ConfirmationAccountRepository>(() =>
      ConfirmationAccountImplement(getIt<ConfirmationAccountDatasource>()));
  //USES CASES
  _registerOrUnregister<DoVerifyEmail>(() => DoVerifyEmail(getIt()));
  _registerOrUnregister<DoResendEmail>(() => DoResendEmail(getIt()));
}

void injectHeadquarterDatasource() {
  // ---------------HEADQUARTER MODULE--------------
  // * [HEADQUARTER]
  _registerOrUnregister<HeadquarterDatasource>(() =>
      HeadquarterApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<HeadquarterRepository>(
      () => HeadquarterImplement(getIt<HeadquarterDatasource>()));
  //USES CASES
  _registerOrUnregister<DoInteractionHeadquarter>(
      () => DoInteractionHeadquarter(getIt()));
}

void injectNotificationDatasource() {
  // ---------------NOTIFICATION MODULE--------------
  // * [NOTIFICATION]
  _registerOrUnregister<NotificationFirebaseDatasource>(() =>
      NotificationFirebaseDatasourceImplement(
          getIt(), getIt(), FirebaseCloudMessaging(getIt(), getIt())));
  _registerOrUnregister<NotificationApiDatasource>(() =>
      NotificationApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));

  _registerOrUnregister<NotificationRepository>(() => NotificationImplement(
      getIt<NotificationFirebaseDatasource>(),
      getIt<NotificationApiDatasource>()));
  //USES CASES
  _registerOrUnregister<DoInitNotification>(() => DoInitNotification(getIt()));
  _registerOrUnregister<DoGetNotifications>(() => DoGetNotifications(getIt()));
  _registerOrUnregister<DoRegisterDevice>(() => DoRegisterDevice(getIt()));
  _registerOrUnregister<DoGetUnreadCount>(() => DoGetUnreadCount(getIt()));
}

void injectSupplierWorkerDatasource() {
  _registerOrUnregister<supplier_worker.WorkerDatasource>(
      () => supplier_worker_api.WorkerApiDatasource(getIt(), getIt()));
  _registerOrUnregister<supplier_worker_domain.WorkerRepository>(
      () => supplier_worker_repo.WorkerRepositoryImplement(getIt(), getIt()));
}

void injectAddonDatasource() {
  _registerOrUnregister<AddonDataSource>(
      () => AddonApiDataSource(getIt(), getIt(), getIt()));
  _registerOrUnregister<AddonRepository>(
      () => AddonImplement(getIt<AddonDataSource>()));
  _registerOrUnregister<DoGetServiceAddons>(
      () => DoGetServiceAddons(getIt()));
  _registerOrUnregister<DoCreateAddon>(
      () => DoCreateAddon(getIt()));
  _registerOrUnregister<DoUpdateAddon>(
      () => DoUpdateAddon(getIt()));
  _registerOrUnregister<DoDeleteAddon>(
      () => DoDeleteAddon(getIt()));
  _registerOrUnregister<DoLinkAddon>(
      () => DoLinkAddon(getIt()));
  _registerOrUnregister<DoUnlinkAddon>(
      () => DoUnlinkAddon(getIt()));
  _registerOrUnregister<AddonCubit>(
      () => AddonCubit(
            doGetServiceAddons: getIt(),
            doCreateAddon: getIt(),
            doLinkAddon: getIt(),
            doUnlinkAddon: getIt(),
            doUpdateAddon: getIt(),
            doDeleteAddon: getIt(),
          ),
      isFactory: true);
}

void _registerOrUnregister<T extends Object>(T Function() instanceBuilder,
    {bool isFactory = false}) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
    return;
  }
  if (isFactory) {
    getIt.registerFactory<T>(instanceBuilder);
  } else {
    getIt.registerLazySingleton<T>(instanceBuilder);
  }
}
