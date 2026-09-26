import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

part 'alert_manage_state.dart';

class AlertManageCubit extends Cubit<AlertManageState> {
  AlertManageCubit() : super(AlertManageInitial());
  ParameterSnackBarCustom snackParamaters = const ParameterSnackBarCustom(
    message: "",
  );
}
