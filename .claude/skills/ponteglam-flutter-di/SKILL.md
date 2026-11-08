---
name: ponteglam-flutter-di
description: Inyección de dependencias del app Flutter PonteGlam con get_it — orden de arranque en main.dart, funciones inject*Datasource en di/modules_dp.dart, el helper _registerOrUnregister (que hace toggle), lazy singleton vs factory vs registerFactoryParam, barrel shared_imports.dart y BlocProviders globales. Úsala al registrar un datasource, repositorio, caso de uso, cubit o bloc nuevo, o al depurar errores "is not registered" / "already registered" de GetIt.
---

# Inyección de dependencias (get_it)

`final GetIt getIt = GetIt.instance;` en `lib/di/get_it_instance.dart`.

## Orden de arranque (`main.dart`)

1. `tz.initializeTimeZones()` + `tz.setLocalLocation(kDefaultTimezone)`.
2. `injectAsyncDependencies()` → `FirebaseApp`, `DeviceInfoPlugin`, `EndPoints`.
3. `SharedPreferences` como singleton.
4. `injectOverallDependencies()` → `Dio` (+ `MobileLogInterceptor`), `IStorage`, `NetworkState`,
   `GeoDevice`, `PermissionHandle`, `FormatCurrencyUtil`, `DateFormatUtil`, `FailureManage`,
   `FirebaseMessaging`, módulo de logs.
5. `needRegisterModules()` → todas las features.
6. `runApp(BlocsProviders())`.
7. En el splash, `DoInitApp` llama `injectBuildDependencies(context)` → registra
   `AppLocalizations` y `AlertManageUtil`, que necesitan `BuildContext`.
   **Antes del splash, `getIt<AppLocalizations>()` no existe**: no usarlo en código que corre antes.

## `_registerOrUnregister` (cuidado: es un toggle)

```dart
void _registerOrUnregister<T extends Object>(T Function() builder, {bool isFactory = false}) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
    return;            // ← NO vuelve a registrar
  }
  isFactory ? getIt.registerFactory<T>(builder) : getIt.registerLazySingleton<T>(builder);
}
```

Si una función `inject*` se ejecuta dos veces, la segunda **desregistra** todo. Por eso cada
`inject*` se llama una sola vez desde `needRegisterModules()`. No invocarlas desde pantallas.

## Registrar una feature nueva

En `lib/di/modules_dp.dart`:

```dart
void injectFooDatasource() {
  _registerOrUnregister<FooDatasource>(
      () => FooApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<FooRepository>(() => FooRepositoryImpl(getIt<FooDatasource>()));
  _registerOrUnregister<DoListFoo>(() => DoListFoo(repository: getIt()));
  _registerOrUnregister<FooCubit>(
      () => FooCubit(doListFoo: getIt()),
      isFactory: true);
}
```

y llamarla desde el grupo que corresponda: `homeRegisterModules()` (features de home/proveedor),
`authRegisterModules()` (auth) o `needRegisterModules()`.

- Registrar por el **tipo abstracto** (`FooDatasource`, `FooRepository`) para que `getIt()` lo resuelva.
- `getIt()` sin tipo resuelve por inferencia del parámetro del constructor; si hay ambigüedad, tipar: `getIt<FooDatasource>()`.
- Si hay dos clases con el mismo nombre en client y supplier, importar con alias
  (`import '...' as supplier_worker;`) como ya hace `modules_dp.dart`.

## Lazy singleton, factory o factory con parámetros

| Tipo | Cuándo | Ejemplo |
|---|---|---|
| `registerLazySingleton` (default) | Datasources, repositorios, casos de uso, blocs globales | `SettingBloc`, `HomeBloc` |
| `isFactory: true` | Cubits de pantalla: estado nuevo cada vez que se abre | `ServiceCreationCubit`, `RatingCubit`, `AppointmentCubit` |
| `registerFactoryParam<T, P1, P2>` | Cubit que necesita argumentos de la ruta | `HeadquarterCreationCubit(companyId, initialForm)` |

Un cubit de pantalla registrado como singleton conserva el estado de la visita anterior: es un bug típico.

## Proveer el bloc a la UI

- **Global** (sesión completa): agregar `BlocProvider<FooBloc>(create: (_) => getIt<FooBloc>(), lazy: true)` en `BlocsProviders` de `main.dart` y en `shared/blocs/`.
- **Por pantalla**: `BlocProvider(create: (_) => getIt<FooCubit>()..load(), child: FooPage())` en el builder de la ruta o en la página.

## `shared_imports.dart`

Barrel que reexporta datasources, repositorios, casos de uso y blocs usados en `modules_dp.dart`
y `main.dart`. Al crear una feature registrada en DI, agregar sus `export` aquí si `modules_dp.dart`
los consume a través del barrel (o importarlos directamente en `modules_dp.dart`, como hacen las features de supplier).
