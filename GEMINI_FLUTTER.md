# 📱 Reglas de Desarrollo — Proyecto Flutter

> Estas reglas aplican a todo el desarrollo asistido por IA en este proyecto.
> Deben seguirse **sin excepción** en cada sesión de trabajo.

---
# ⚙️ Patrones Avanzados y Flujo de Trabajo — Flutter

> Complemento de `GEMINI_FLUTTER.md`. Aplica en conjunto.
> Detalla implementación de Clean Architecture, Cubit/Bloc, y flujo del asistente.

---

## 1. Clean Architecture — Implementación por Capas

### `data/datasource/` — Fuentes de Datos

Responsable de comunicarse con APIs, bases de datos locales o servicios externos.

```dart
// src/book_page/data/datasource/book_remote_datasource.dart
abstract class BookRemoteDatasource {
  Future<List<BookModel>> getBooks();
  Future<BookModel> getBookById(String id);
}

class BookRemoteDatasourceImpl implements BookRemoteDatasource {
  BookRemoteDatasourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<BookModel>> getBooks() async {
    final response = await _dio.get(EndPointsConstants.booksList);
    return (response.data as List)
        .map((e) => BookModel.fromJson(e))
        .toList();
  }
}
```

### `data/model/` — Modelos de Datos

Solo serialización/deserialización. Sin lógica de negocio.

```dart
// src/book_page/data/model/book_model.dart
class BookModel extends BookEntity {
  const BookModel({required super.id, required super.title, required super.author});

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json['id'] as String,
    title: json['title'] as String,
    author: json['author'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'author': author};
}
```

### `data/implement/` — Implementación del Repositorio

```dart
// src/book_page/data/implement/book_repository_impl.dart
class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl(this._datasource);
  final BookRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    try {
      final books = await _datasource.getBooks();
      return Right(books);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error del servidor'));
    }
  }
}
```

### `domain/repository/` — Contratos Abstractos

Solo interfaces. Cero implementación.

```dart
// src/book_page/domain/repository/book_repository.dart
abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, BookEntity>> getBookById(String id);
}
```

### `domain/implement/` — Entidades de Dominio

Clases puras de Dart. Sin dependencias de Flutter ni paquetes externos.

```dart
// src/book_page/domain/implement/book_entity.dart
class BookEntity extends Equatable {
  const BookEntity({required this.id, required this.title, required this.author});

  final String id;
  final String title;
  final String author;

  @override
  List<Object?> get props => [id, title, author];
}
```

### `domain/use_case/` — Casos de Uso

Un archivo por caso de uso. Lógica de negocio aislada.

```dart
// src/book_page/domain/use_case/get_books_use_case.dart
class GetBooksUseCase {
  GetBooksUseCase(this._repository);
  final BookRepository _repository;

  Future<Either<Failure, List<BookEntity>>> call() => _repository.getBooks();
}
```

---

## 2. Cubit y Bloc — Patrones de Estado

### Estados base recomendados

```dart
// src/book_page/ui/cubit/book_state.dart
abstract class BookState extends Equatable {
  const BookState();
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}
class BookLoading extends BookState {}
class BookLoaded extends BookState {
  const BookLoaded(this.books);
  final List<BookEntity> books;
  @override
  List<Object?> get props => [books];
}
class BookError extends BookState {
  const BookError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
```

### BlocBuilder — Uso correcto en UI

```dart
// ✅ Usar buildWhen para optimizar rebuilds
BlocBuilder<BookCubit, BookState>(
  buildWhen: (previous, current) => current is! BookLoading || previous is! BookLoading,
  builder: (context, state) {
    return switch (state) {
      BookLoading() => const AppLoadingIndicator(),
      BookLoaded(:final books) => BookList(books: books),
      BookError(:final message) => AppErrorView(message: message),
      _ => const SizedBox.shrink(),
    };
  },
)
```

### BlocListener — Para efectos secundarios

```dart
// ✅ Separar lógica visual de efectos (snackbars, navegación, dialogs)
BlocListener<BookCubit, BookState>(
  listenWhen: (_, current) => current is BookError,
  listener: (context, state) {
    if (state is BookError) {
      AppSnackbar.showError(context, state.message);
    }
  },
  child: BookPageBody(),
)
```

---

## 3. Estructura de Widgets — Reglas de Separación

### Umbral de separación

| Condición | Acción |
|---|---|
| Widget > 80 líneas | Separar en subcomponentes |
| Widget con 2+ responsabilidades visuales | Separar en subcomponentes |
| Widget reutilizable en otras features | Mover a `utils/widgets/` |
| Widget específico de una feature | Colocar en `feature/ui/widgets/` |

### Nombrado de componentes

```
BookPage           → pantalla principal (en ui/)
BookAppBar         → componente del appbar (en ui/widgets/)
BookCard           → tarjeta reutilizable (en ui/widgets/)
BookEmptyState     → estado vacío (en ui/widgets/)
BookFilterSheet    → bottom sheet de filtros (en ui/widgets/)
```

### Convención de archivos

```
book_page.dart           → pantalla
book_app_bar.dart        → componente
book_card.dart           → componente
book_empty_state.dart    → componente
book_cubit.dart          → cubit
book_state.dart          → estados
```

---

## 4. Colores, Gradientes y Tema — Referencia Completa

Nunca usar valores hexadecimales directos en widgets. Siempre importar y usar las constantes:

```dart
import 'package:myapp/config/theme/app_colors.dart';
```

### Uso de gradientes

```dart
// ✅ Gradiente principal (fondo de pantallas hero)
Container(
  decoration: BoxDecoration(gradient: glamGradientTheme),
)

// ✅ Overlay oscuro sobre imágenes
Container(
  decoration: BoxDecoration(gradient: darkStrongGradientTheme),
)

// ✅ Gradiente de opacidad lineal
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [linearColorTheme, Colors.transparent]),
  ),
)
```

### Uso de colores de estado

```dart
// En chips, badges, o indicadores de estado
Color getStatusColor(OrderStatus status) => switch (status) {
  OrderStatus.seen       => seenColorTheme,
  OrderStatus.inProgress => inProgressColorTheme,
  OrderStatus.success    => successColorTheme,
  OrderStatus.cancelled  => cancelColorTheme,
};
```

---

## 5. GoRouter — Definición y Uso

### Estructura de rutas

```dart
// config/router/app_router.dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/books',
      name: AppRoutes.books,
      builder: (context, state) => BlocProvider(
        create: (_) => BookCubit(getIt<GetBooksUseCase>())..fetchBooks(),
        child: const BookPage(),
      ),
      routes: [
        GoRoute(
          path: 'detail/:id',
          name: AppRoutes.bookDetail,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BookDetailPage(bookId: id);
          },
        ),
      ],
    ),
  ],
);
```

### Constantes de rutas

```dart
// config/constants/app_routes.dart
class AppRoutes {
  static const books       = 'books';
  static const bookDetail  = 'book-detail';
}
```

### Navegación en widgets

```dart
// ✅ Navegación declarativa con GoRouter
context.goNamed(AppRoutes.books);
context.pushNamed(AppRoutes.bookDetail, pathParameters: {'id': book.id});
context.pop();

// ✅ Solo para modales, no para pantallas
showDialog(context: context, builder: (_) => const BookDeleteDialog());
showModalBottomSheet(context: context, builder: (_) => const BookFilterSheet());
```

---

## 6. l10n — Flujo Completo de Internacionalización

### Al agregar cualquier texto nuevo

1. Identificar la clave semántica (`bookTitle`, `noResultsFound`)
2. Agregar en `app_es.arb`
3. Agregar en `app_en.arb`
4. Ejecutar `flutter gen-l10n` (o el build runner configurado)
5. Usar en el widget con `context.l10n.claveNueva`

### Claves — Convención de nombrado

```
// Pantallas: camelCase descriptivo
booksPageTitle       → "Mis Libros" / "My Books"
bookDetailPageTitle  → "Detalle del Libro" / "Book Detail"

// Acciones
saveButton           → "Guardar" / "Save"
cancelButton         → "Cancelar" / "Cancel"
deleteButton         → "Eliminar" / "Delete"

// Estados
loadingMessage       → "Cargando..." / "Loading..."
emptyStateMessage    → "No hay resultados" / "No results"
errorMessage         → "Ocurrió un error" / "An error occurred"

// Campos de formulario
emailLabel           → "Correo electrónico" / "Email"
passwordLabel        → "Contraseña" / "Password"
```

### Textos con parámetros

```json
// app_es.arb
{
  "booksCount": "{count} libros encontrados",
  "@booksCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

```dart
// En el widget
Text(context.l10n.booksCount(books.length))
```

---

## 7. Utils — Catálogo de Uso

Antes de crear cualquier componente nuevo, revisar qué existe en `utils/`:

```
utils/
├── widgets/
│   ├── app_loading_indicator.dart    ← indicador de carga global
│   ├── app_error_view.dart           ← vista de error reutilizable
│   ├── app_empty_state.dart          ← estado vacío reutilizable
│   └── app_snackbar.dart             ← snackbars estandarizados
├── extensions/
│   ├── string_extensions.dart        ← utilidades de string
│   ├── context_extensions.dart       ← helpers de BuildContext
│   └── date_extensions.dart          ← formateo de fechas
└── helpers/
    ├── validators.dart               ← validadores de formularios
    └── formatters.dart               ← formateadores de texto/números
```

```dart
// ✅ Usar siempre los utilitarios existentes
import 'package:myapp/utils/widgets/app_loading_indicator.dart';

// En lugar de crear un loader nuevo:
const AppLoadingIndicator()

// ✅ Usar extensiones
context.l10n.someKey
someString.toCapitalized()
```

---

## 8. Seguridad Móvil — Checklist por Componente

### Al crear un Datasource

- [ ] ¿Usa HTTPS en todos los endpoints?
- [ ] ¿Los errores de red no exponen información interna al usuario?
- [ ] ¿Los tokens se obtienen de `FlutterSecureStorage`, no de `SharedPreferences`?
- [ ] ¿Se manejan timeouts y reintentos de forma controlada?

### Al crear un formulario

- [ ] ¿Los campos de contraseña usan `obscureText: true`?
- [ ] ¿Se valida la entrada antes de enviar a la API?
- [ ] ¿No se loguea la entrada del usuario con `print` o `debugPrint`?

### Al crear storage local

- [ ] ¿Los datos sensibles usan `flutter_secure_storage`?
- [ ] ¿Los datos no sensibles usan `SharedPreferences` o `Hive`?
- [ ] ¿No se almacena el token en texto plano en ningún lugar?

### Al configurar Dio / HTTP

```dart
// ✅ No deshabilitar SSL — nunca hacer esto
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    (client) {
  client.badCertificateCallback = (_, __, ___) => true; // ❌ NUNCA
  return client;
};

// ✅ Configuración segura
final dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  headers: {'Content-Type': 'application/json'},
));
```

---

## 9. Resumen Rápido de Reglas

| # | Regla | Acción por defecto |
|---|---|---|
| 1 | Estado | Cubit simple / Bloc complejo |
| 2 | Estructura | Respetar `data/domain/ui` por feature |
| 3 | Widgets | Separar si > 80 líneas o > 2 responsabilidades |
| 4 | Comentarios | Solo lógica no obvia |
| 5 | Archivos privados | Preguntar antes de acceder |
| 6 | Seguridad | Checklist por tipo de componente |
| 7 | Colores | Solo constantes del tema |
| 8 | Assets | Solo constantes de `assets_constants.dart` |
| 9 | Endpoints | Solo constantes de `end_points_constants.dart` |
| 10 | Navegación | GoRouter primero, Navigator solo para modales |
| 11 | Textos | Siempre `l10n`, nunca strings literales |
| 12 | Utils | Revisar antes de crear algo nuevo |


## 1. Gestión de Estado — Cubit y Bloc

- Usar **Cubit** para lógica simple (toggles, carga de datos, formularios sencillos).
- Usar **Bloc** cuando la lógica involucre múltiples eventos, transformaciones de streams, o estados derivados complejos.

```
¿Cuándo usar cada uno?

Cubit  → un botón que carga datos, un toggle de visibilidad, un formulario simple
Bloc   → flujo de autenticación, paginación con filtros, lógica con múltiples eventos concurrentes
```

```dart
// ✅ Cubit — lógica simple
class BookCubit extends Cubit<BookState> {
  BookCubit(this._getBooks) : super(BookInitial());

  final GetBooksUseCase _getBooks;

  Future<void> fetchBooks() async {
    emit(BookLoading());
    final result = await _getBooks();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }
}

// ✅ Bloc — lógica compleja con múltiples eventos
class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc(this._getBooks, this._searchBooks) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<FilterBooksEvent>(_onFilterBooks);
  }
}
```

---

## 2. Estructura del Proyecto — Clean Architecture

La estructura es fija y debe respetarse. **No crear carpetas fuera de este esquema** sin justificación.

```
lib/
├── src/
│   └── book_page/
│       ├── data/
│       │   ├── datasource/       ← fuentes de datos (API, local DB, cache)
│       │   ├── implement/        ← implementación de repositorios (data layer)
│       │   └── model/            ← modelos de datos con fromJson/toJson
│       ├── domain/
│       │   ├── repository/       ← contratos (interfaces abstractas)
│       │   ├── implement/        ← entidades de dominio puras
│       │   └── use_case/         ← casos de uso (un archivo por use case)
│       └── ui/
│           ├── widgets/          ← componentes reutilizables de esta feature
│           ├── cubit/ o bloc/    ← gestión de estado
│           └── book_page.dart    ← pantalla principal
├── config/
│   ├── constants/
│   │   ├── assets_constants.dart
│   │   └── end_points_constants.dart
│   └── theme/
├── utils/                        ← componentes y utilidades globales
└── main.dart
```

### Reglas de capas

| Capa | Puede importar | NO puede importar |
|---|---|---|
| `domain/` | Solo Dart puro, entities | `data/`, `ui/`, Flutter SDK |
| `data/` | `domain/`, modelos, Dio/Http | `ui/` |
| `ui/` | `domain/use_case/`, cubit/bloc | `data/` directamente |

---

## 3. Widgets — Separación en Componentes

- Si un widget supera **~80 líneas** o contiene más de **2 responsabilidades visuales**, debe separarse.
- Los componentes de una feature van en `ui/widgets/` de su feature.
- Los componentes reutilizables entre features van en `utils/widgets/`.

```dart
// ❌ Widget monolítico
class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 50 líneas de AppBar personalizado
      // 60 líneas de lista de libros
      // 40 líneas de filtros
      // 30 líneas de empty state
    ]);
  }
}

// ✅ Separado en componentes
class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const BookAppBar(),
      const BookFilterBar(),
      Expanded(child: BookList()),
    ]);
  }
}
// Cada componente en src/book_page/ui/widgets/
```

---

## 4. Comentarios — Solo Cuando Aporten Valor

- ❌ No comentar código obvio ni dejar placeholders vacíos.
- ❌ `// TODO: implement`, `// Your code here`, `// ignore this`
- ✅ Documentar decisiones no obvias, workarounds o contratos de API.

```dart
// ❌ Innecesario
final books = await repository.getBooks(); // Obtenemos los libros

// ✅ Útil
// La API devuelve 422 cuando el token expira, no 401 — manejado aquí intencionalmente
if (response.statusCode == 422) { ... }
```

---

## 5. Archivos Privados — No Acceder sin Permiso

El asistente **no debe leer, mostrar ni modificar** estos archivos sin confirmación explícita:

- `.env`, `env.dart`, `secrets.dart`
- `google-services.json`, `GoogleService-Info.plist`
- `key.properties`, `keystore.jks`, `*.p12`
- `firebase_options.dart` (si contiene claves hardcodeadas)

**Protocolo**:
> "Este archivo puede contener información sensible. ¿Confirmas que quieres que lo revise?"

```dart
// ✅ Las claves nunca deben estar en el código fuente
// Usar flutter_dotenv, --dart-define, o similar
final apiKey = const String.fromEnvironment('API_KEY');
```

---

## 6. Seguridad en Aplicaciones Móviles

### Almacenamiento seguro
```dart
// ❌ Nunca usar SharedPreferences para datos sensibles
prefs.setString('token', accessToken);

// ✅ Usar IStorage
final storage = getIt<IStorage>();
await storage.write(key: 'token', value: accessToken);
```
para esto puedes ver el archivo lib/device/storage/istorage.dart

### Comunicaciones
- Siempre HTTPS. No deshabilitar verificación de certificados SSL.
- No loguear tokens, contraseñas ni PII en consola (`print`, `debugPrint`).
- Usar `certificate pinning` cuando el proyecto lo requiera.

### Datos sensibles en UI
- No mostrar tokens, IDs internos ni datos bancarios en texto plano.
- Enmascarar campos sensibles con `obscureText: true`.

### Código generado
- No hardcodear URLs de producción, API keys ni credenciales.
- Validar y sanitizar toda entrada del usuario antes de enviarla a la API.
- Usar `dart-define` o `flutter_dotenv` para configuración por entorno.

### Protección del binario
- No incluir lógica de autenticación crítica solo en el cliente.
- Las reglas de negocio sensibles deben validarse en el backend.

---

## 7. Colores y Estilos — Usar Solo el Tema Definido

**Nunca usar colores literales** (`Color(0xFF...)`, `Colors.blue`, etc.) en widgets.
Siempre referenciar las constantes del tema:

```dart
// ❌ Mal
Container(color: Color(0xFF5B0055))
Text("Hola", style: TextStyle(color: Colors.grey))

// ✅ Bien
Container(color: primaryColorTheme)
Text("Hola", style: TextStyle(color: grayTextColorTheme))
```

### Paleta disponible

| Constante | Uso |
|---|---|
| `primaryColorTheme` | Color principal de la app |
| `secondaryColorTheme` | Acentos, botones secundarios |
| `backgroundColorTheme` | Fondo de pantallas |
| `appBarColorTheme` | Fondo del AppBar |
| `grayTextColorTheme` | Texto secundario, placeholders |
| `cardColorTheme` | Fondo de tarjetas |
| `successColorTheme` | Estados de éxito |
| `cancelColorTheme` | Estados de error / cancelación |
| `inProgressColorTheme` | Estados en progreso |
| `seenColorTheme` | Estados vistos |
| `greyBlockColorTheme` | Bordes, separadores |
| `borderColorTheme` | Bordes inactivos |
| `borderColorActiveTheme` | Bordes activos |
| `glamGradientTheme` | Gradiente principal |
| `darkStrongGradientTheme` | Overlay oscuro sobre imágenes |

---

## 8. Assets — Usar Constantes de `assets_constants.dart`

**Nunca escribir rutas de assets como strings literales** en los widgets.

```dart
// ❌ Mal
Image.asset("assets/images/image_background.png")
Text("Hello", style: TextStyle(fontFamily: "Montserrat"))

// ✅ Bien
Image.asset("$pathManagementImages$imageBackground")
Text("Hello", style: TextStyle(fontFamily: fontFamilyMontserrat))
```

Para nuevos assets:
1. Agregar la constante en `config/constants/assets_constants.dart`
2. Registrar el asset en `pubspec.yaml`
3. Luego referenciar desde la constante

---

## 9. Endpoints — Usar `end_points_constants.dart`

- Todos los endpoints deben estar definidos en `config/constants/end_points_constants.dart`.
- **No escribir URLs o paths inline** dentro de datasources o servicios.

```dart
// ❌ Mal
final response = await dio.get('/api/v1/books/list');

// ✅ Bien
final response = await dio.get(EndPointsConstants.booksList);
```

- Si un endpoint nuevo es necesario, **agregar primero la constante** y luego usarla.

---

## 10. Navegación — GoRouter como Estándar

- Usar **GoRouter** para toda la navegación declarativa del proyecto.
- Usar `context.push()` / `context.go()` / `context.pop()` de GoRouter.
- Usar `Navigator.push` / `Navigator.pop` nativo **solo cuando sea estrictamente necesario** (ej. diálogos, bottom sheets, rutas fuera del árbol de GoRouter).

```dart
// ✅ Navegación estándar con GoRouter
context.go('/books/detail/${book.id}');
context.push('/books/filter');
context.pop();

// ✅ Permitido solo para modales/dialogs
showModalBottomSheet(context: context, builder: (_) => const BookFilterSheet());

// ❌ No usar Navigator directamente para pantallas normales
Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookDetailPage()));
```

---

## 11. Internacionalización — l10n Obligatorio

- **Todos los textos visibles para el usuario** deben ir a través de `l10n`.
- No usar strings literales en los widgets para textos de UI.
- Agregar las traducciones en **ambos archivos**: español (`app_es.arb`) e inglés (`app_en.arb`).

```dart
// ❌ Mal
Text("Mis Libros")
Text("No se encontraron resultados")

// ✅ Bien
Text(context.l10n.myBooks)
Text(context.l10n.noResultsFound)
```

```json
// app_es.arb
{
  "myBooks": "Mis Libros",
  "noResultsFound": "No se encontraron resultados"
}

// app_en.arb
{
  "myBooks": "My Books",
  "noResultsFound": "No results found"
}
```

- Al agregar cualquier texto nuevo, el asistente debe incluir ambas traducciones.

---

## 12. Utilidades Globales — `utils/`

- Antes de crear una función utilitaria nueva, **revisar `utils/`** para ver si ya existe.
- Los helpers reutilizables entre features van en `utils/`, no dentro de una feature específica.
- Los widgets genéricos (loaders, empty states, error views) van en `utils/widgets/`.

```dart
// ✅ Reutilizar lo que ya existe en utils/
import 'package:myapp/utils/widgets/loading_indicator.dart';
import 'package:myapp/utils/extensions/string_extensions.dart';
```
## 13. Documentación

- Puedes encontrar en la ruta de docs/info.pdf (Información de la app y otras reglas)

## 14. Zona horaria y manejo de fechas

### Regla fundamental
La API devuelve todas las fechas en UTC (ISO 8601).
Nunca mostrar una fecha al usuario sin convertirla primero
a America/Bogota. Una fecha sin convertir mostrará 5 horas
de diferencia respecto a la hora real en Colombia.

### Reglas obligatorias

1. Inicializar timezone en main.dart antes de runApp():
   tz.initializeTimeZones();
   tz.setLocalLocation(tz.getLocation(kDefaultTimezone));

2. Nunca usar DateTime.now() para mostrar hora al usuario.
   Usar siempre: AppDateUtils.now()

3. Todo DateTime que viene del API DEBE pasar por conversión
   antes de mostrarse:
   - BIEN: AppDateUtils.fromUtc(DateTime.parse(response['date']))
   - MAL:  DateTime.parse(response['date'])  ← muestra hora UTC

4. Nunca usar DateTime directamente en un Text() o DateFormat()
   si viene del API. Siempre convertir primero.

5. Nunca hardcodear 'America/Bogota' en widgets o lógica.
   Usar siempre la constante: kDefaultTimezone
   o la utilidad: AppDateUtils

6. Para comparar dos fechas, ambas deben estar en la misma
   zona. Convertir las dos antes de comparar.

### Utilidad centralizada
Toda lógica de fechas pasa por:
lib/core/utils/date_utils.dart → AppDateUtils

  AppDateUtils.now()
    Hora actual en Colombia.

  AppDateUtils.fromUtc(DateTime utcDate)
    Convierte fecha UTC del API a hora Colombia.
    Usar antes de mostrar cualquier fecha al usuario.

  AppDateUtils.fromUtcToTz(DateTime utcDate, String tzName)
    Convierte fecha UTC a una zona específica.
    Usar cuando la sede tiene timezone propio.

### Ejemplo correcto — mostrar hora de una cita
  // API devuelve: "2026-04-14T20:00:00Z"
  final utc = DateTime.parse(appointment.startTime);
  final local = AppDateUtils.fromUtc(utc);
  final display = DateFormat('dd/MM/yyyy hh:mm a').format(local);
  // Resultado: "14/04/2026 03:00 PM" ✅

### Ejemplo incorrecto — NO hacer esto
  // API devuelve: "2026-04-14T20:00:00Z"
  final dt = DateTime.parse(appointment.startTime);
  final display = DateFormat('hh:mm a').format(dt);
  // Resultado: "08:00 PM" ❌ (muestra hora UTC, no Colombia)

### Cambiar zona horaria
Para migrar a otra zona o soportar múltiples zonas:
1. Cambiar kDefaultTimezone en values_constant.dart
2. No se requiere ningún otro cambio en el código
3. Para sedes en otros países usar fromUtcToTz() con el
   campo timezone del modelo de sede que llega del APIta`.


O una versión más estricta para que la AI no lo ignore:

## Mandatory Image URL Resolution Rule

All backend image URLs MUST be resolved using `ImageUrlHelper.resolve()`.

Never:
- concatenate image URLs manually
- use raw `/media/...` paths directly
- render backend image URLs without resolution

Always use:

```dart
ImageUrlHelper.resolve(imageUrl)
```


## 10. Flutter Version and Non-Deprecated APIs

### Target version
Flutter 3.41.0+ (channel stable, March 2026)
Dart 3.7+

### Main rule
Before using any widget, class, method or parameter,
verify it is compatible with Flutter 3.41.
Never generate APIs marked as deprecated in
previous versions. If a deprecated API is detected
in existing code, replace it with the modern
equivalent without being asked.

---

### Mandatory replacements — NEVER generate these

#### Colors and opacity
```dart
// ❌ Deprecated since Flutter 3.3
color.withOpacity(0.5)

// ✅ Correct
color.withValues(alpha: 0.5)
```

#### TextTheme
```dart
// ❌ Deprecated since Flutter 3.1
Theme.of(context).textTheme.headline6
Theme.of(context).textTheme.bodyText2
Theme.of(context).textTheme.subtitle1
Theme.of(context).textTheme.caption

// ✅ Correct
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.bodySmall
```

#### Buttons
```dart
// ❌ Deprecated since Flutter 2.0
RaisedButton(...)
FlatButton(...)
OutlineButton(...)

// ✅ Correct
ElevatedButton(...)
TextButton(...)
OutlinedButton(...)
```

#### WillPopScope
```dart
// ❌ Deprecated since Flutter 3.12
WillPopScope(
  onWillPop: () async => true,
  child: ...,
)

// ✅ Correct
PopScope(
  canPop: true,
  onPopInvokedWithResult: (didPop, result) {},
  child: ...,
)
```

#### WidgetStateProperty
```dart
// ❌ Deprecated since Flutter 3.19
MaterialStateProperty.all(Colors.red)
MaterialStateProperty.resolveWith(...)
MaterialState.pressed

// ✅ Correct
WidgetStateProperty.all(Colors.red)
WidgetStateProperty.resolveWith(...)
WidgetState.pressed
```

#### Scaffold background color
```dart
// ❌ Deprecated
Scaffold(
  backgroundColor: Theme.of(context).backgroundColor,
)

// ✅ Correct
Scaffold(
  backgroundColor: Theme.of(context)
      .colorScheme.surface,
)
```

#### ColorScheme
```dart
// ❌ Deprecated since Flutter 3.3
Theme.of(context).colorScheme.background
Theme.of(context).colorScheme.onBackground

// ✅ Correct
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
```

#### Navigator vs GoRouter
```dart
// ❌ Never use Navigator directly for screens
Navigator.push(context, MaterialPageRoute(...))
Navigator.pushNamed(context, '/route')
Navigator.pushReplacement(...)

// ✅ Always GoRouter for screen navigation
context.go('/route')
context.push('/route')
context.pushReplacement('/route')
context.pop()

// ✅ Navigator only for modals and dialogs
showDialog(...)
showModalBottomSheet(...)
```

#### Network images
```dart
// ❌ No error handling or placeholder
Image.network(url)

// ✅ With full error and loading handling
Image.network(
  url,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return const CircularProgressIndicator();
  },
  errorBuilder: (context, error, stack) =>
      const Icon(Icons.broken_image),
)
```

#### BuildContext across async gaps
```dart
// ❌ Using context after await without check
Future<void> submit() async {
  await someAsyncCall();
  context.go('/home'); // ← unsafe
}

// ✅ Always check mounted before using context
Future<void> submit() async {
  await someAsyncCall();
  if (!mounted) return;
  context.go('/home');
}
```

#### Lists with separators
```dart
// ❌ Manual outdated pattern
ListView(
  children: items
    .expand((e) => [ItemWidget(e), Divider()])
    .toList(),
)

// ✅ Modern pattern
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => const Divider(),
  itemBuilder: (_, i) => ItemWidget(items[i]),
)
```

#### Flexible vs Expanded
```dart
// ❌ Using Expanded when content may not
//    fill the available space
Row(children: [
  Expanded(child: Text('optional content')),
])

// ✅ Use Flexible when size is not guaranteed
Row(children: [
  Flexible(child: Text('optional content')),
])
```

---

### Dart 3.7+ — Mandatory modern patterns

#### Switch expressions
```dart
// ❌ Classic switch statement
String getLabel(Status s) {
  switch (s) {
    case Status.active:
      return 'Active';
    case Status.inactive:
      return 'Inactive';
    default:
      return 'Unknown';
  }
}

// ✅ Switch expression
String getLabel(Status s) => switch (s) {
  Status.active   => 'Active',
  Status.inactive => 'Inactive',
  _               => 'Unknown',
};
```

#### Pattern matching in BlocBuilder
```dart
// ✅ Modern pattern with switch + patterns
builder: (context, state) => switch (state) {
  BookingLoading() =>
      const AppLoadingIndicator(),
  BookingDatesLoaded(:final availableDates) =>
      _DateList(dates: availableDates),
  BookingNoAvailability() =>
      const _EmptyState(),
  BookingError(:final failure) =>
      AppErrorView(message: failure.message),
  _ => const SizedBox.shrink(),
},
```

#### Null safety and null-aware operators
```dart
// ❌ Verbose null checks
if (user != null) {
  return user!.name;
} else {
  return 'Guest';
}

// ✅ Null-aware
return user?.name ?? 'Guest';
```

#### Records for multiple return values
```dart
// ❌ Using a Map or list for multiple returns
Map<String, dynamic> getInfo() =>
    {'name': 'Anthony', 'age': 25};

// ✅ Use records
(String name, int age) getInfo() =>
    ('Anthony', 25);
final (name, age) = getInfo();
```

#### Const constructors
```dart
// ❌ Missing const where possible
Container(
  child: Text('Hello'),
)

// ✅ Always add const when the widget
//    has no runtime-dependent values
const SizedBox(height: 16)
const Divider()
const CircularProgressIndicator()
```

---

### Checklist before delivering any code

- [ ] No widget or method is marked
      @deprecated in Flutter 3.41
- [ ] withValues(alpha:) used instead of
      withOpacity()
- [ ] WidgetStateProperty used instead of
      MaterialStateProperty
- [ ] PopScope used instead of WillPopScope
- [ ] colorScheme.surface used instead of
      deprecated backgroundColor
- [ ] Every context used after await has
      a mounted check
- [ ] Switch expressions used instead of
      switch statements where applicable
- [ ] GoRouter used for all screen navigation
- [ ] Navigator used only for modals
      and dialogs
- [ ] const added to all widgets that
      allow it


## Mandatory Snackbar Rule

Never use Flutter default snackbar implementations directly.

Forbidden usages:
- `SnackBar`
- `ScaffoldMessenger.of(context).showSnackBar(...)`
- custom inline snackbar widgets outside the shared component

Always use the app standardized snackbar helper:

```dart
PonteSnackBar.show(
  context,
  message: 'Operation completed successfully',
  type: TypeAlert.success,
);