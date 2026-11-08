---
name: ponteglam-flutter-networking
description: Capa de datos y manejo de errores del app Flutter PonteGlam — Dio con validateStatus abierto, EndPoints, header Authorization Token desde IStorage, chequeo de conectividad, timeout, lectura del sobre success/error/detail, jerarquía Failure/FailureManage, throwIfError, Either en repositorios, log remoto de errores y resolución de URLs de imagen. Úsala al escribir o modificar cualquier datasource, repositorio, modelo con fromJson o manejo de errores HTTP.
---

# Red, datos y errores

## Piezas globales

| Pieza | Dónde | Qué hace |
|---|---|---|
| `Dio` | registrado en `injectOverallDependencies` | `BaseOptions(validateStatus: (_) => true)` → **nunca lanza por 4xx/5xx**; hay que revisar status y llaves a mano |
| `MobileLogInterceptor` | `src/shared/core/log/...` | Envía al backend (`create-mobile-app-log`) toda respuesta ≥400 y todo `DioException` |
| `EndPoints` | `config/constant/end_point_constant.dart` | `baseUrl` + un getter por endpoint |
| `NetworkState` | `device/connectivity/network_state.dart` | `status` actual de conectividad |
| `FailureManage` | `core/errors/failure.dart` | Fábrica de `Failure` con mensajes l10n |
| `IStorage` | `device/storage/istorage.dart` | Secure storage; token en `keyAuthToken` |
| llaves | `config/constant/keys_constant.dart` | `keySuccess='success'`, `keyErr='error'`, `keyDetail='detail'` |
| `timeOutApi` | `values_constant.dart` | 30 s |

## Patrón estándar de datasource (el que usa la gran mayoría de features)

```dart
class FooApiDatasourceImplement extends FooDatasource {
  FooApiDatasourceImplement(this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'Token $authToken'});

  @override
  Future<List<FooModel>> listFoo({required String authToken, int? categoryId}) async {
    throwIfError(_network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Response response = await _dio
        .get(
          _endPoints.listFooUrl,
          options: _authOptions(authToken),
          queryParameters: {if (categoryId != null) 'category': categoryId},
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) && response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK, _failureManage.server('...'));

    return fooModelsFromJson(jsonEncode(response.data[keySuccess]));
  }
}
```

Puntos clave:
- El datasource **lanza** `Failure` (no devuelve `Either`).
- Parámetros opcionales con `if (x != null) 'k': x` o `queryParameters: cond ? {...} : null`.
- Listados paginados del backend vienen como `{count, next, previous, results}`; listados simples dentro de `success`.
- `error` puede ser un `String` o un `Map` de errores de serializer: convertir con `.toString()` si se va a mostrar.

## Repositorio (`domain/implement/`)

```dart
@override
Future<Either<Failure, List<FooModel>>> listFoo({required String authToken}) async {
  try {
    return Right(await _datasource.listFoo(authToken: authToken));
  } catch (e, stackTrace) {
    if (e is! Failure) {
      catchError(e.toString(), stackTrace.toString());   // log remoto de errores inesperados
    }
    return Left(e is Failure ? e : UnknownFailure(e.toString()));
  }
}
```

El repositorio es la frontera: de aquí hacia arriba todo es `Either<Failure, T>`.

## Caso de uso (`domain/use_case/do_<accion>.dart`)

```dart
class DoListFoo {
  DoListFoo({required this.repository});
  final FooRepository repository;

  Future<Either<Failure, List<FooModel>>> call({int? categoryId}) async {
    final String authToken = await getIt<IStorage>().read(key: keyAuthToken) ?? '';
    return repository.listFoo(authToken: authToken, categoryId: categoryId);
  }
}
```

El token se lee en el caso de uso (o en el repositorio en algunas features), **nunca** en la UI.
Endpoints públicos (catálogos) no llevan token.

## Failures

`Failure(message)` con subclases: `ConnectivityFailure`, `ServerFailure`, `ClientFailure`,
`EmptyFailure`, `WentWrongFailure`, `NoFoundFailure`, `MissingArgumentFailure`,
`InsufficientParametersFailure`, `UnknownFailure`, `WidgetsFailure`.
Crear con `FailureManage` (`_failureManage.connectivity`, `.server(msg)`, `.client(msg)`,
`.noFound(x)`) para que el mensaje salga traducido. La UI muestra `failure.message`.

## Modelos (`fromJson`)

```dart
List<FooModel> fooModelsFromJson(String str) =>
    List<FooModel>.from(json.decode(str).map((x) => FooModel.fromJson(x)));

class FooModel extends Equatable {
  const FooModel({required this.id, required this.name, this.imageUrl});
  final int id;
  final String name;
  final String? imageUrl;

  factory FooModel.fromJson(Map<String, dynamic> json) => FooModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        imageUrl: json['image'],
      );

  @override
  List<Object?> get props => [id, name, imageUrl];
}
```

- `fromJson` tolerante (`?? default`): el backend puede omitir campos y los APKs viejos conviven con backends nuevos.
- Decimales del backend pueden venir como string: `double.tryParse('${json['price']}') ?? 0`.
- Fechas: guardar el `DateTime.parse(...)` (UTC) y convertir con `AppDateUtils.fromUtc` **al mostrar**.
- Imágenes: guardar la URL tal cual; resolver con `ImageUrlHelper.resolve(url)` al mostrar.

## Agregar un endpoint

1. Getter en `EndPoints`: `String get fooUrl => "$baseUrl/<app>/api/<ruta>/";`. Para ids:
   `String fooDetailUrl(int id) => "$baseUrl/<app>/api/<ruta>/$id/";`.
2. Método en el datasource abstracto + implementación con el patrón de arriba.
3. Método en repositorio abstracto + implementación.
4. Caso de uso `Do<Accion>` y su registro en DI (`ponteglam-flutter-di`).
5. Revisar el contrato del backend con la skill `ponteglam-api-contract`.

## Errores comunes

- Asumir que Dio lanza en 400 → no lanza; sin el chequeo de llaves, el 400 se parsea como éxito y revienta en `fromJson`.
- Olvidar `.timeout(...)` → la UI queda cargando para siempre si el túnel cae.
- Construir URLs de imagen a mano (`baseUrl + path`) → usar `ImageUrlHelper`.
- `print`/`debugPrint` de tokens o respuestas con datos personales.
