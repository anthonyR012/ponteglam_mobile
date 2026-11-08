---
name: ponteglam-flutter-ui-kit
description: Kit de UI global del app Flutter PonteGlam — tokens de color y gradientes del tema, catálogo de widgets compartidos (shared/widgets), PonteSnackBar y alertas overlay, ImageLoadWidget + ImageUrlHelper para imágenes del backend, l10n con getIt<AppLocalizations>(), assets, fechas con AppDateUtils, moneda COP y APIs de Flutter no deprecadas. Úsala al construir o modificar cualquier pantalla o widget, antes de crear un componente nuevo (para reutilizar uno existente) y al mostrar textos, imágenes, fechas o precios.
---

# Kit de UI

## Tema (`config/theme/theme.dart`)

Nunca `Color(0x...)` ni `Colors.*` en widgets nuevos. Tokens:

| Token | Uso |
|---|---|
| `primaryColorTheme` (#5B0055) | Marca, acciones principales |
| `secondaryColorTheme` (#009CA1) | Acentos, íconos, botones secundarios |
| `backgroundColorTheme` | Fondo de pantallas |
| `appBarColorTheme` | AppBar |
| `cardColorTheme` | Tarjetas |
| `grayTextColorTheme` | Texto secundario, placeholders |
| `whiteColorTheme`, `blackColorTheme` | Blanco/negro de marca |
| `successColorTheme`, `cancelColorTheme`, `inProgressColorTheme`, `seenColorTheme` | Estados (citas, alertas) |
| `greyBlockColorTheme`, `borderColorTheme`, `borderColorActiveTheme` | Bordes y separadores |
| `glamGradientTheme` | Gradiente de marca (fondos hero) |
| `darkStrongGradientTheme` | Overlay oscuro sobre imágenes |
| `linearColorTheme` | Base para gradientes lineales |

Tema global: `ligthTheme` (inputs, cards, botones, snackbar ya estilizados): preferir `Theme.of(context)`
antes que estilos inline. Opacidad: `color.withValues(alpha: 0.5)`.

## Widgets compartidos (`shared/widgets/`) — revisar antes de crear uno

| Necesidad | Widget |
|---|---|
| Botón principal | `ButtonMain` |
| Botones de navegación/acción en lista | `ListButtonsForward`, `ButtonForwadIcon`, `ButtonTopWidget`, `ButtonLabelShadow` |
| Inputs | `InputTextField`, `TextFieldObscure` (contraseñas), `TextFieldNoObscure`, `ModernTextField` |
| Formularios modernos | `ModernSectionHeader`, `ModernFormCard`, `ModernTextField`, `ModernDropdown` |
| Selector | `DropdownCustomSelect`, `TextOptionField` |
| Búsqueda/filtro | `TextFilterData` |
| Títulos | `TextLabelWidget`, `GradientText`, `GetBannerTitleLabel`, `LabelContentWidget`, `LineInformation` |
| AppBar | `CustomMainAppBar` |
| Drawer | `FancyDrawerWrapperCustom` |
| Imagen (asset, red, caché, archivo) | `ImageLoadWidget(image:, typeSourceImage: TypeSourceImage.network)` |
| Avatar | `CircleImageProfile` |
| Calificación | `RatingBarWidget`, `RatingWidget`, `RatingBarIndicator` |
| Calendario por día | `DayCalendarCard` |
| Línea de tiempo de cita | `TraceabilityTimelineWidget` |
| Adicionales de servicio | `AddonDetailSection` |
| Amenidades | `AmenityCard` |
| Estado vacío / sin datos | `UnavailableWidget` |
| Diálogo de confirmación | `PonteAlertDialog` |
| Mapa | `OpenMapMarker` |
| Cambiar entre cliente y sede (proveedor) | `PlaceSelectorMenu` |
| Lista de notificaciones | `NotificationListBody` |
| Contador | `TimerCustomWidget` |
| Fondos | `BackgroundLogin`, `BackgroundOverlayWidget` |

Componente usado en una sola feature → `ui/widgets/` de esa feature. Usado en 2+ → `shared/widgets/`.

## Feedback al usuario

- Snackbar: **solo** `PonteSnackBar.show(context, message: ..., title: ..., type: TypeAlert.success|error|warning|info)`.
  Prohibido `ScaffoldMessenger.showSnackBar` directo y `SnackBar` inline.
- Overlays de carga/alerta: `getIt<AlertManageUtil>().show(type: OverlayAlertType.load)` / `.hide(...)` / `.showFor(seconds:, type:)`.
- Bottom sheet genérico: `showCustomBottomSheet(...)` (`config/utils/alert_default_util.dart`).
- Confirmaciones: `PonteAlertDialog`.

## Textos (l10n)

- Archivos: `lib/l10n/app_en.arb` (plantilla) y `lib/l10n/app_es.arb`. Agregar la clave en **ambos**, luego `flutter gen-l10n`.
- Acceso en el proyecto: `final l10n = getIt<AppLocalizations>();` → `l10n.miClave`
  (`AppLocalizations.of(context)` también funciona dentro de widgets).
- `getIt<AppLocalizations>()` solo existe después del splash (`injectBuildDependencies`).
- Claves camelCase semánticas (`appointmentCancelTitle`), con placeholders para valores variables.

## Imágenes

- Del backend: `ImageLoadWidget(image: url, typeSourceImage: TypeSourceImage.network)`; ya pasa
  por `ImageUrlHelper.resolve`. Con `Image.network` directo, resolver primero y poner `loadingBuilder` + `errorBuilder`.
- Assets: constantes de `config/constant/assets_constant.dart`
  (`'$pathManagementImages$imageBackground'`), registrar el asset en `pubspec.yaml`.
- Fuentes: `fontFamilyMontserrat`, `fontFamilyLora`, `fontFamilyHind`.

## Fechas y dinero

- `AppDateUtils.now()` (hora Colombia), `AppDateUtils.fromUtc(dt)` antes de mostrar,
  `AppDateUtils.fromUtcToTz(dt, tz)`, `AppDateUtils.format(...)`. Zona: `kDefaultTimezone`, nunca `'America/Bogota'` literal.
- Moneda: `CurrencyUtils.formatCOP(amount)` o `getIt<FormatCurrencyUtil>()`.

## Flutter 3.41 — no generar APIs deprecadas

| ❌ | ✅ |
|---|---|
| `withOpacity` | `withValues(alpha:)` |
| `WillPopScope` | `PopScope(canPop:, onPopInvokedWithResult:)` |
| `MaterialStateProperty` / `MaterialState` | `WidgetStateProperty` / `WidgetState` |
| `colorScheme.background` | `colorScheme.surface` |
| `textTheme.headline6/bodyText2/caption` | `titleLarge/bodyMedium/bodySmall` |
| `Navigator.push` para pantallas | `context.push/go` (GoRouter) |
| `context` tras `await` sin chequeo | `if (!context.mounted) return;` |

Además: `const` en todo widget que lo permita, `ListView.separated` para listas con separador,
`Flexible` cuando el contenido no garantiza llenar el espacio, switch expressions y patrones de Dart 3.
