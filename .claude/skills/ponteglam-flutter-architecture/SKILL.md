---
name: ponteglam-flutter-architecture
description: Mapa de la arquitectura real del app Flutter de PonteGlam (Clean Architecture por feature con data/domain/ui, separación client/supplier/shared, carpetas globales config/core/device/di/shared/l10n) y las reglas de capas. Úsala SIEMPRE antes de crear, mover o revisar código en ponteglam_mobile, o para decidir dónde vive un archivo nuevo.
---

# Arquitectura del app PonteGlam

Flutter 3.41 (stable) / Dart 3.7+. Paquete: `ponte_glam`. Estado con `flutter_bloc`,
DI con `get_it`, HTTP con `dio`, errores con `dartz` (`Either<Failure, T>`), navegación con `go_router`.

## Árbol de `lib/`

```
lib/
├── main.dart              # init (timezone, DI, Firebase, notificaciones) + MultiBlocProvider global
├── config/
│   ├── constant/          # end_point_constant.dart (EndPoints), keys_constant.dart, values_constant.dart,
│   │                      # assets_constant.dart, enum_constant.dart, http_response_constant.dart, ...
│   ├── routers/router.dart    # GoRouter único
│   ├── theme/theme.dart       # colores, gradientes y ThemeData (ligthTheme)
│   └── utils/             # AlertManageUtil, DateFormatUtil, FormatCurrencyUtil, NotifierNav, OverlayController...
├── core/
│   ├── errors/            # Failure + subclases, FailureManage, throwIfError, throwClient/ServerResponse
│   ├── navigation/        # NotificationHandler, NotificationNavigator
│   └── utils/             # AppDateUtils, ImageUrlHelper, CurrencyUtils, SoundUtil
├── device/                # Abstracciones de hardware/SO: storage (IStorage), connectivity (NetworkState),
│                          # firebase (FCM), local_notifications, geolocator, camera, permission
├── di/                    # get_it_instance.dart, modules_dp.dart (registros), shared_imports.dart (barrel)
├── l10n/                  # app_en.arb (plantilla), app_es.arb, generados app_localizations*.dart
├── shared/
│   ├── blocs/             # Blocs/Cubits globales (setting, home, service, sign_in, alert_manage...)
│   ├── model/             # Modelos usados por varias features (service, headquarter, user, category...)
│   └── widgets/           # Componentes UI reutilizables (ver skill ponteglam-flutter-ui-kit)
└── src/
    ├── client/<feature>/  # Experiencia del cliente (home, book, appointment, history, profile...)
    ├── supplier/<feature>/# Experiencia del proveedor (company, headquarter, service, worker, addon...)
    └── shared/<feature>/  # Features usadas por ambos (wallet, core/log)
```

## Anatomía de una feature (nombres reales)

```
src/client/appointment/
├── data/
│   ├── datasource/appointment_datasource.dart        # abstract class AppointmentDatasource
│   ├── implement/appointment_api_datasource.dart     # AppointmentApiDatasourceImplement (llama a Dio)
│   └── model/appointment_model.dart                  # modelos propios de la feature (fromJson/toJson)
├── domain/
│   ├── repository/appointment_repository.dart        # abstract class AppointmentRepository (Either)
│   ├── implement/appointment_implement.dart          # AppointmentRepositoryImpl / XImplement
│   └── use_case/do_list_appointments.dart            # class DoListAppointments { call(...) }
└── ui/
    ├── cubit/appointment_cubit.dart + appointment_state.dart   (o bloc/ con *_event.dart)
    ├── widgets/                                      # componentes solo de esta feature
    ├── responsive/small_mobile_page.dart             # algunas features separan layout por tamaño
    └── appointment_detail_page.dart                  # páginas (en supplier a veces ui/pages/)
```

Atención, difiere de `GEMINI_FLUTTER.md`:
- `data/implement/` = **implementación del datasource** (la que habla con la API).
- `domain/implement/` = **implementación del repositorio** (no entidades).
- No hay capa de entidades: los modelos (`*Model extends Equatable`) se usan en todas las capas.
- Los casos de uso se llaman `Do<Accion>` y viven en `do_<accion>.dart`.

## Reglas de capas

| Capa | Puede usar | No debe usar |
|---|---|---|
| `ui/` | use cases, cubits/blocs, modelos, `shared/widgets`, `config/theme` | Dio, datasources, `EndPoints` |
| `domain/use_case` | repositorio abstracto, `IStorage` (leer token) | Dio, widgets |
| `domain/implement` | datasource abstracto | widgets |
| `data/` | Dio, `EndPoints`, `NetworkState`, `FailureManage`, modelos | `ui/`, BuildContext |

## Dónde poner algo nuevo

| Necesito… | Lugar |
|---|---|
| Pantalla o flujo nuevo | `src/client|supplier/<feature>/` completo → skill `ponteglam-flutter-new-feature` |
| Modelo usado por 2+ features | `shared/model/` |
| Widget reutilizable | `shared/widgets/` (revisar el catálogo antes) |
| Estado global (vive toda la sesión) | `shared/blocs/` + `BlocProvider` en `main.dart` |
| Endpoint | getter en `EndPoints` (`config/constant/end_point_constant.dart`) |
| Llave de storage/preferencias o de respuesta | `config/constant/keys_constant.dart` |
| Valor fijo (timeouts, zona horaria) | `config/constant/values_constant.dart` |
| Acceso a hardware o SO | `device/` |
| Texto visible | `l10n/app_en.arb` + `app_es.arb` |

## Reglas obligatorias (resumen de GEMINI_FLUTTER.md)

1. Sin comentarios obvios ni `// TODO` vacíos.
2. Colores solo desde `config/theme/theme.dart`; assets desde `assets_constant.dart`; endpoints desde `EndPoints`.
3. Textos visibles por l10n en **ambos** `.arb`.
4. Navegación con GoRouter; `Navigator` solo para diálogos y bottom sheets.
5. Fechas del API → `AppDateUtils.fromUtc(...)` antes de mostrar. Nunca `DateTime.now()` para mostrar.
6. Imágenes del backend → `ImageUrlHelper.resolve(...)` (o `ImageLoadWidget`, que ya lo hace).
7. Snackbars solo con `PonteSnackBar.show(...)`.
8. APIs no deprecadas: `withValues(alpha:)`, `PopScope`, `WidgetStateProperty`, `colorScheme.surface`; `if (!mounted) return;` / `context.mounted` tras cada `await`.
9. Archivos privados (`google-services.json`, `key.properties`, `*.jks`, `firebase_options.dart`): preguntar antes de abrirlos.
10. Widgets de más de ~80 líneas o con varias responsabilidades → separarlos en `ui/widgets/`.

## Deuda conocida (no replicar)

- Hay strings en español hardcodeados en widgets y datasources (`"Error al cargar adicionales"`). En código nuevo, usar l10n.
- `supplier/addon` usa un estilo distinto (el datasource devuelve `Either` y arma headers propios). El estándar es el de la skill `ponteglam-flutter-networking`.
- Tests del app: no existen (`test/` vacío). `mockito` y `http_mock_adapter` ya están en dev_dependencies.

## Comandos

```bash
flutter analyze lib/<ruta>          # antes de entregar
flutter gen-l10n                    # tras editar .arb
flutter build apk --debug           # APK de prueba (build/app/outputs/flutter-apk/app-debug.apk)
```

## Skills relacionadas

`ponteglam-flutter-new-feature`, `ponteglam-flutter-di`, `ponteglam-flutter-networking`,
`ponteglam-flutter-state`, `ponteglam-flutter-ui-kit`, `ponteglam-flutter-navigation`,
`ponteglam-api-contract`.
