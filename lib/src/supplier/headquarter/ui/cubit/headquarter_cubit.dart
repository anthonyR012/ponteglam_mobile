import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_delete_headquarter.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_state.dart';

class SupplierHeadquarterCubit extends Cubit<SupplierHeadquarterState> {
  final DoDeleteHeadquarter _doDeleteHeadquarter;

  SupplierHeadquarterCubit({
    required DoDeleteHeadquarter doDeleteHeadquarter,
  })  : _doDeleteHeadquarter = doDeleteHeadquarter,
        super(HeadquarterInitial());

  Future<void> deleteHeadquarter({required int headquarterId}) async {
    if (isClosed) return;
    emit(HeadquarterLoading());
    final result =
        await _doDeleteHeadquarter(headquarterId: headquarterId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HeadquarterError(failure)),
      (_) => emit(HeadquarterDeleted()),
    );
  }
}
