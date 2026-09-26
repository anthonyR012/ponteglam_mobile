import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoSignOut {
  final SignInRepository signInRepository;

  DoSignOut(this.signInRepository);

  Future<Either<Failure, bool>> call({required ParamsDoSignOut params}) async {
    // Read both tokens before wiping storage.
    final authToken = await params.storage.read(key: keyAuthToken);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    // Delete keyAuthToken immediately so the onTokenRefresh listener in
    // main.dart finds no auth token and cannot re-register the device if
    // FirebaseMessaging.deleteToken() triggers a token rotation mid-logout.
    await params.storage.delete(key: keyAuthToken);
    await params.storage.delete(key: keyFcmToken);

    // Deregister FCM device server-side — failure must not block logout.
    if (authToken != null && fcmToken != null) {
      final fcmResult = await signInRepository.deleteFcmToken(
        authToken: authToken,
        fcmToken: fcmToken,
      );
      fcmResult.fold(
        (failure) => catchError(failure.message, 'DoSignOut'),
        (_) {},
      );
    }

    // Close Firebase Auth + Google Sign-In session.
    final stateFirebase =
        await signInRepository.signOut(datasource: Repository.firebase);
    if (stateFirebase.isLeft()) return stateFirebase;

    await signInRepository.signOut(datasource: Repository.local);

    // Step 7: Clear preferences and reset blocs
    params.prefs.remove(keyLogin);
    params.prefs.remove(keyCompanyDraft);
    params.settingBloc.add(const DoResetSettingEvent());
    params.homeBloc.add(const DoResetHomeEvent());
    params.serviceBloc.add(const DoResetServiceEvent());
    params.headquarterCubit.resetState();

    return right(true);
  }
}

class ParamsDoSignOut {
  const ParamsDoSignOut(this.prefs, this.storage, this.settingBloc,
      this.homeBloc, this.serviceBloc, this.headquarterCubit);
  final SharedPreferences prefs;
  final IStorage storage;
  final SettingBloc settingBloc;
  final HomeBloc homeBloc;
  final ServiceBloc serviceBloc;
  final HeadquarterCubit headquarterCubit;
}
