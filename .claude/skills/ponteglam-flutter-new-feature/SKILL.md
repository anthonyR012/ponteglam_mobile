---
name: ponteglam-flutter-new-feature
description: Receta paso a paso para crear una feature o pantalla nueva de punta a punta en el app Flutter PonteGlam (endpoint → modelo → datasource → repositorio → caso de uso → cubit/estado → DI → ruta → página → l10n → verificación), o para agregar una operación nueva a una feature existente. Úsala cuando el usuario pida una pantalla, un flujo o una llamada nueva al backend.
---

# Crear una feature de punta a punta

Antes de empezar: decidir si es `src/client/`, `src/supplier/` o `src/shared/`, y revisar si ya
existe una feature, modelo o widget reutilizable (`shared/model`, `shared/widgets`, `shared/blocs`).
Si el backend no tiene el endpoint, crearlo primero (en el repo backend, skill `ponteglam-backend-api-endpoints`).

Ejemplo: feature `promotion` del cliente que lista promociones.

## 1. Endpoint — `config/constant/end_point_constant.dart`

```dart
String get listPromotionsUrl => "$baseUrl/services/api/list-promotions/";
```

## 2. Modelo — `src/client/promotion/data/model/promotion_model.dart`

(o `shared/model/` si lo usarán otras features). `Equatable`, `fromJson` tolerante, función
`promotionsModelFromJson(String)`. Detalle en skill `ponteglam-flutter-networking`.

## 3. Datasource

- `data/datasource/promotion_datasource.dart` → `abstract class PromotionDatasource { Future<List<PromotionModel>> listPromotions({required String authToken}); }`
- `data/implement/promotion_api_datasource.dart` → `PromotionApiDatasourceImplement extends PromotionDatasource`
  con `Dio`, `NetworkState`, `EndPoints`, `FailureManage`: conectividad → request con `.timeout` →
  chequeo de `error`/`detail`/status → parseo de `success`.

## 4. Repositorio

- `domain/repository/promotion_repository.dart` → abstracto, devuelve `Future<Either<Failure, List<PromotionModel>>>`.
- `domain/implement/promotion_implement.dart` → `try { Right(...) } catch` con `catchError` para errores no-`Failure`.

## 5. Caso de uso — `domain/use_case/do_list_promotions.dart`

`class DoListPromotions { call() }` que lee el token de `IStorage` (`keyAuthToken`) y llama al repositorio.

## 6. Estado y cubit — `ui/cubit/`

`promotion_state.dart` (clases selladas o enum + `copyWith`, ver `ponteglam-flutter-state`) y
`promotion_cubit.dart` que recibe `DoListPromotions` por constructor y hace `fold`.

## 7. DI — `di/modules_dp.dart`

```dart
void injectPromotionDatasource() {
  _registerOrUnregister<PromotionDatasource>(
      () => PromotionApiDatasourceImplement(getIt(), getIt(), getIt(), getIt()));
  _registerOrUnregister<PromotionRepository>(() => PromotionImplement(getIt<PromotionDatasource>()));
  _registerOrUnregister<DoListPromotions>(() => DoListPromotions(getIt()));
  _registerOrUnregister<PromotionCubit>(() => PromotionCubit(doListPromotions: getIt()), isFactory: true);
}
```

Llamarla desde `homeRegisterModules()` (o el grupo correspondiente). Ver `ponteglam-flutter-di`.

## 8. Página y widgets — `ui/`

- `ui/promotion_page.dart` con `static const String routeName = 'promotions';`.
- `BlocBuilder` para pintar, `BlocListener` para snackbars/navegación.
- Componentes de más de ~80 líneas a `ui/widgets/`. Reutilizar `shared/widgets` (skill `ponteglam-flutter-ui-kit`).
- Colores del tema, imágenes con `ImageLoadWidget`, fechas con `AppDateUtils`, textos con l10n.

## 9. Ruta — `config/routers/router.dart`

`GoRoute(path:, name:, builder:)` como hija de `/home` o `/home_supplier` según corresponda,
con `BlocProvider(create: (_) => getIt<PromotionCubit>()..load())`. Argumentos por `extra`.
Ver `ponteglam-flutter-navigation`.

## 10. Textos — `l10n/app_en.arb` y `l10n/app_es.arb`

Todas las claves nuevas en ambos archivos y `flutter gen-l10n`.

## 11. Verificar

```bash
flutter analyze lib/src/client/promotion lib/di lib/config
flutter build apk --debug      # si hay que probarlo en un teléfono
```

Probar contra el backend real por el túnel. Si la feature depende de un endpoint nuevo, comprobar
primero con `curl` que responde con el sobre `success`.

## Agregar una operación a una feature existente

Mismo recorrido, pero solo las piezas nuevas: getter en `EndPoints` → método en datasource
(abstracto + impl) → repositorio (abstracto + impl) → nuevo `Do<Accion>` → registro en el
`inject*` de esa feature → método en el cubit. Parámetros nuevos opcionales con default, para no
romper a otros llamadores (ejemplo real: `getCategories({bool includeEmpty = false})`).

## Checklist final

- [ ] Ninguna capa `ui/` importa Dio, `EndPoints` ni datasources.
- [ ] Datasource con chequeo de conectividad, `.timeout(timeOutApi)` y lectura de `error`/`detail`.
- [ ] Repositorio devuelve `Either` y loguea errores inesperados.
- [ ] Cubit de pantalla registrado como factory.
- [ ] Ruta con `routeName` estático.
- [ ] Textos en ambos `.arb`; sin colores ni strings de assets literales.
- [ ] `flutter analyze` sin issues nuevos.
