import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_confirm_cash_appointment.dart';

enum ConfirmCashStatus { initial, loading, success, failure }

class ConfirmCashPaymentState {
  final ConfirmCashStatus status;
  final String? errorMessage;
  final int? confirmedAppointmentId;

  const ConfirmCashPaymentState({
    this.status = ConfirmCashStatus.initial,
    this.errorMessage,
    this.confirmedAppointmentId,
  });

  ConfirmCashPaymentState copyWith({
    ConfirmCashStatus? status,
    String? errorMessage,
    int? confirmedAppointmentId,
  }) {
    return ConfirmCashPaymentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      confirmedAppointmentId:
          confirmedAppointmentId ?? this.confirmedAppointmentId,
    );
  }
}

class ConfirmCashPaymentCubit extends Cubit<ConfirmCashPaymentState> {
  final DoConfirmCashAppointment doConfirmCashAppointment;

  ConfirmCashPaymentCubit({required this.doConfirmCashAppointment})
      : super(const ConfirmCashPaymentState());

  Future<void> confirm(int appointmentId) async {
    emit(state.copyWith(status: ConfirmCashStatus.loading, errorMessage: null));

    final result =
        await doConfirmCashAppointment.call(appointmentId: appointmentId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ConfirmCashStatus.failure,
        errorMessage: failure.message,
      )),
      (appointment) => emit(state.copyWith(
        status: ConfirmCashStatus.success,
        confirmedAppointmentId: appointment.id,
      )),
    );
  }

  void reset() {
    emit(const ConfirmCashPaymentState());
  }
}
