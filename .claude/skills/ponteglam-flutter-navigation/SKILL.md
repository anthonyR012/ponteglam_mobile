---
name: ponteglam-flutter-navigation
description: Navegación y notificaciones del app Flutter PonteGlam — GoRouter único en config/routers/router.dart, routeName estático por página, paso de argumentos por extra, rutas anidadas cliente/proveedor, transición CustomTransitionPage, NotificationNavigator, manejo de push FCM y notificaciones locales con action/go_to. Úsala al agregar o cambiar una pantalla, una ruta, el paso de argumentos entre pantallas o la reacción del app a una notificación push.
---

# Navegación y notificaciones

## GoRouter (`lib/config/routers/router.dart`)

Un solo `final GoRouter router` que usa `MaterialApp.router`. Cada página declara su nombre:

```dart
class FooPage extends StatelessWidget {
  const FooPage({super.key, required this.fooId});
  static const String routeName = 'foo';
  final int fooId;
  ...
}
```

Registro (path y name iguales a `routeName`; las rutas raíz llevan `/`):

```dart
GoRoute(
  path: FooPage.routeName,               // hija: sin '/'
  name: FooPage.routeName,
  builder: (context, state) {
    final int fooId = state.extra as int;
    return BlocProvider(
      create: (_) => getIt<FooCubit>()..load(fooId),
      child: FooPage(fooId: fooId),
    );
  },
),
```

Raíces actuales: splash (`/`, con hijas sign_in, introducción, sign_up…), `/home` (cliente,
con detalle de servicio → book y detalle de sede), `/home_supplier` (proveedor, con crear servicio,
detalle de servicio, notificaciones, crear sede, gestión de trabajadores…), `/notification`,
`/history` (→ detalle de cita), `/profile` (→ info personal → direcciones), `/wallet`.
Las páginas principales usan `pageBuilder` con `CustomTransitionPage(... transitionsBuilder: trasitionsAnimationScale)`.

## Navegar

```dart
context.pushNamed(FooPage.routeName, extra: foo.id);       // apila
context.goNamed(HomePage.routeName);                       // reemplaza el stack
context.push('/${HomePageSupplier.routeName}/${CreateServicePage.routeName}', extra: headquarter.toJson());
context.pop(result);
```

- `extra` es la forma de pasar argumentos en el proyecto (int, Map o un modelo serializado con `toJson`).
  El builder lo castea; si una ruta recibe tipos distintos según el origen, comprobar con `is`
  (ver `AppointmentDetailPage`: `int` o `Map` con `appointmentId` / `autoOpenRating`).
- Modelos por `extra`: enviar `model.toJson()` y reconstruir con `xModelFromJson(jsonEncode(state.extra))`, como hacen sede y servicio.
- `Navigator` solo para `showDialog` / `showModalBottomSheet`.
- Cliente ↔ proveedor: `PlaceSelectorMenu` cambia de modo con `pushReplacementNamed(HomePageSupplier.routeName, extra: headquarter)`;
  la sede elegida se guarda con `keyPlace`.

## Notificaciones push

Archivos:
- `device/firebase/cloud_messaging.dart` — permisos, token FCM y mensajes en primer plano/abiertos.
- `device/local_notifications/local_notification_service.dart` — canal Android, mostrar notificación local y navegar desde su payload.
- `core/navigation/notification_handler.dart` — traduce `data['go_to'] ?? data['action']` a una ruta.
- `core/navigation/notification_navigator.dart` — `NotificationNavigator.navigate(router, ruta, extra:)`:
  hace `go('/home')` y en el siguiente frame `push(ruta)`, para que la ruta destino tenga un "atrás".
- `main.dart` — handler de background (`@pragma('vm:entry-point')`), app abierta desde una notificación terminada,
  y re-registro del token en `onTokenRefresh`.

Destinos soportados (contrato con el backend, ver `ponteglam-api-contract`):

| `go_to` / `action` | Acción |
|---|---|
| `history`, `client_appointments`, `appointment_detail` | Detalle de cita del cliente (`appointment_id`; `prompt_rating: 'true'` abre calificación) |
| `supplier_appointments` | Home del proveedor / agenda |
| desconocido | No navega (intencional) |

El backend también envía `confirm_cash` (al finalizar una cita en efectivo) y **hoy no tiene caso**:
si se implementa, agregarlo en `notification_handler.dart`, `cloud_messaging.dart` y
`local_notification_service.dart`.

Al agregar un destino nuevo: ruta en el router, caso en los tres archivos y valor acordado con el backend.
