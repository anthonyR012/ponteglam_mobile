---
name: ponteglam-flutter-state
description: Gestión de estado del app Flutter PonteGlam con flutter_bloc — cuándo Cubit vs Bloc, los dos estilos de estado del proyecto (clases selladas vs estado único con enum + copyWith), Equatable, fold de Either en el cubit, BlocBuilder/BlocListener/BlocConsumer, blocs globales en shared/blocs y errores típicos. Úsala al crear o modificar cubits, blocs, estados o la UI que reacciona a ellos.
---

# Estado (Cubit / Bloc)

## Cubit o Bloc

- **Cubit** (la mayoría, 21 en el proyecto): carga de datos, formularios, acciones simples.
- **Bloc** (5: `SettingBloc`, `HomeBloc`, `ServiceBloc`, `WorkerBloc`, `SlotBloc`): varios eventos,
  necesidad de `bloc_concurrency` (`droppable`, `restartable`) o eventos disparados desde muchos lugares.

Ubicación: `ui/cubit/<x>_cubit.dart` + `<x>_state.dart` en la feature; globales en `shared/blocs/<cubit_x|bloc_x>/`.
Blocs con `part`/`part of` para `_event.dart` y `_state.dart`.

## Estilo A — estados como clases (selladas)

Para pantallas con estados excluyentes (cargando / error / datos):

```dart
part of 'foo_bloc.dart';

sealed class FooState extends Equatable {
  const FooState();
  @override
  List<Object?> get props => [];
}

final class FooInitial extends FooState {}
final class FooLoading extends FooState {}
final class FooLoaded extends FooState {
  const FooLoaded(this.items);
  final List<FooModel> items;
  @override
  List<Object?> get props => [items];
}
final class FooError extends FooState {
  const FooError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
```

UI con `switch` de patrones:

```dart
BlocBuilder<FooCubit, FooState>(
  builder: (context, state) => switch (state) {
    FooLoading() => const Center(child: CircularProgressIndicator()),
    FooLoaded(:final items) => FooList(items: items),
    FooError(:final message) => UnavailableWidget(/* ... */),
    _ => const SizedBox.shrink(),
  },
)
```

## Estilo B — estado único con enum + `copyWith`

Para pantallas con datos que persisten mientras ocurren acciones (ver `AppointmentState`):

```dart
enum FooStatus { initial, loading, success, failure }

class FooState extends Equatable {
  const FooState({this.status = FooStatus.initial, this.items = const [], this.errorMessage});
  final FooStatus status;
  final List<FooModel> items;
  final String? errorMessage;

  FooState copyWith({FooStatus? status, List<FooModel>? items, String? errorMessage}) => FooState(
        status: status ?? this.status,
        items: items ?? this.items,
        errorMessage: errorMessage,          // sin "?? this": permite limpiar el error
      );

  @override
  List<Object?> get props => [status, items, errorMessage];
}
```

**Trampa conocida:** con `errorMessage: errorMessage ?? this.errorMessage`, pasar `null` no limpia
el campo (pasa en `AppointmentState`). Para campos que deben poder volver a `null`, no usar `??`,
o usar un parámetro `bool clearError`.

Separar estado de carga y estado de acción (`status` vs `actionStatus`) cuando una acción
(cancelar, guardar) no debe reemplazar la lista en pantalla.

## Cubit típico

```dart
class FooCubit extends Cubit<FooState> {
  FooCubit({required this.doListFoo}) : super(FooInitial());
  final DoListFoo doListFoo;

  Future<void> load() async {
    emit(FooLoading());
    final result = await doListFoo();
    if (isClosed) return;
    result.fold(
      (failure) => emit(FooError(failure.message)),
      (items) => emit(FooLoaded(items)),
    );
  }
}
```

- El cubit solo conoce casos de uso. Nada de Dio, `EndPoints` ni `IStorage`.
- `if (isClosed) return;` tras `await` en cubits de pantalla (factory): el usuario pudo salir.
- Todo estado extiende `Equatable` con `props` completos; si falta un campo en `props`, el `BlocBuilder` no se redibuja.

## Efectos secundarios en la UI

- `BlocListener` (o `listener` de `BlocConsumer`) para snackbars, navegación y diálogos; `BlocBuilder` solo pinta.
- Usar `listenWhen` / `buildWhen` para no repetir efectos.
- Snackbar: `PonteSnackBar.show(context, message: ..., type: TypeAlert.error)`.
- Tras `await` en un widget: `if (!context.mounted) return;`.

## Blocs globales (`main.dart` → `BlocsProviders`)

`SignInCubit`, `AlertManageCubit`, `SignUpCubit`, `RecoverCubit`, `ConfirmationCubit`,
`HeadquarterCubit`, `SplashCubit`, `HomeBloc`, `WalletCubit`, `SettingBloc`, `ServiceBloc`,
`WorkerBloc`, `SlotBloc`, `CompanyCubit`, `ProfileCubit`.

Son singletons compartidos: un estado emitido en una pantalla se ve en todas. `SettingBloc` en
particular lo usan varias pantallas para categorías, tipos y amenidades; si una pantalla
necesita su propia carga sin pisar a otras, usar un cubit de pantalla (como `ServiceCreationCubit`).
