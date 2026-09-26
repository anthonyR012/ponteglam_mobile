import 'dart:convert';

import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/appointment_addon_model.dart';

AppointmentModel appointmentModelFromJson(String str) =>
    AppointmentModel.fromJson(json.decode(str));

class AppointmentModel {
  final int id;
  final String status;
  final String price;
  final DateTime? confirmationIn;
  final DateTime? rememberIn;
  final String? cancellationReason;
  final bool refundPending;
  final String? stateDescription;
  final bool canCancel;
  final bool canReschedule;
  final bool canReview;
  final String? rescheduleMessage;
  final String paymentMethod;
  final bool isHomeService;
  final AddressModel? homeAddress;
  final List<AppointmentServiceModel> appointmentServices;
  final List<TraceabilityModel> traceability;
  final CancellationFeeInfo? cancellationFeeInfo;
  final List<AppointmentAddonModel> addons;

  AppointmentModel({
    required this.id,
    required this.status,
    required this.price,
    this.confirmationIn,
    this.rememberIn,
    this.cancellationReason,
    required this.refundPending,
    this.stateDescription,
    required this.canCancel,
    required this.canReschedule,
    required this.canReview,
    this.rescheduleMessage,
    this.paymentMethod = 'card',
    this.isHomeService = false,
    this.homeAddress,
    required this.appointmentServices,
    this.traceability = const [],
    this.cancellationFeeInfo,
    this.addons = const [],
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'] ?? 0,
        status: json['status'] ?? '',
        price: json['price']?.toString() ?? '0',
        confirmationIn: json['confirmation_in'] != null
            ? AppDateUtils.fromUtc(DateTime.parse(json['confirmation_in']))
            : null,
        rememberIn: json['remember_in'] != null
            ? AppDateUtils.fromUtc(DateTime.parse(json['remember_in']))
            : null,
        cancellationReason: json['cancellation_reason'],
        refundPending: json['refund_pending'] ?? false,
        stateDescription: json['state_description'],
        canCancel: json['can_cancel'] ?? false,
        canReschedule: json['can_reschedule'] ?? false,
        canReview: json['can_review'] ?? false,
        rescheduleMessage: json['reschedule_message'],
        paymentMethod: json['payment_method'] ?? 'card',
        isHomeService: json['is_home_service'] ?? false,
        homeAddress: json['home_address'] != null ? AddressModel.fromJson(json['home_address']) : null,
        appointmentServices: (json['appointment_services'] as List<dynamic>?)
                ?.map((e) => AppointmentServiceModel.fromJson(e))
                .toList() ??
            [],
        traceability: (json['traceability'] as List<dynamic>?)
                ?.map((e) => TraceabilityModel.fromJson(e))
                .toList() ??
            [],
        cancellationFeeInfo: json['cancellation_fee_info'] != null
            ? CancellationFeeInfo.fromJson(json['cancellation_fee_info'])
            : null,
        addons: (json['addons'] as List<dynamic>?)
                ?.map((e) => AppointmentAddonModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  String get statusLabel {
    if (stateDescription == 'En curso') {
      return 'En curso';
    }
    switch (status) {
      case 'active':
        return 'Activa';
      case 'pending':
        return paymentMethod == 'cash' ? 'Pendiente por confirmar' : 'Pendiente de pago';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return stateDescription ?? status;
    }
  }
}

class AppointmentServiceModel {
  final int id;
  final int serviceId;
  final int? headquarterServiceId;
  final String serviceName;
  final String servicePrice;
  final int? workerId;
  final String? workerName;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? serviceImage;

  AppointmentServiceModel({
    required this.id,
    required this.serviceId,
    this.headquarterServiceId,
    required this.serviceName,
    required this.servicePrice,
    this.workerId,
    this.workerName,
    this.startTime,
    this.endTime,
    this.serviceImage,
  });

  factory AppointmentServiceModel.fromJson(Map<String, dynamic> json) =>
      AppointmentServiceModel(
        id: json['id'] ?? 0,
        serviceId: json['service_id'] ?? 0,
        headquarterServiceId: json['headquarter_service_id'],
        serviceName: json['service_name'] ?? '',
        servicePrice: json['service_price']?.toString() ?? '0',
        workerId: json['worker_id'],
        workerName: json['worker_name'],
        startTime: json['start_time'] != null
            ? AppDateUtils.fromUtc(DateTime.parse(json['start_time']))
            : null,
        endTime: json['end_time'] != null
            ? AppDateUtils.fromUtc(DateTime.parse(json['end_time']))
            : null,
        serviceImage: json['service_image'],
      );
}

class TraceabilityModel {
  final int id;
  final String? previousState;
  final String newState;
  final String? changeReason;
  final DateTime createdAt;
  final String userName;

  TraceabilityModel({
    required this.id,
    this.previousState,
    required this.newState,
    this.changeReason,
    required this.createdAt,
    required this.userName,
  });

  factory TraceabilityModel.fromJson(Map<String, dynamic> json) =>
      TraceabilityModel(
        id: json['id'] ?? 0,
        previousState: json['previous_state'],
        newState: json['new_state'] ?? '',
        changeReason: json['change_reason'],
        createdAt: AppDateUtils.fromUtc(DateTime.parse(json['created_at'])),
        userName: json['user_name'] ?? '',
      );

  String get newStateLabel {
    switch (newState) {
      case 'active':
        return 'Activa';
      case 'pending':
      case 'pending_payment':
        return 'Pendiente';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      case 'rescheduled':
        return 'Reagendada';
      case 'in_progress':
      case 'En curso':
        return 'En curso';
      default:
        return newState;
    }
  }
}

class CancellationFeeInfo {
  final double feeAmount;
  final String? feeLevel;
  final String? message;
  final bool isProjected;

  CancellationFeeInfo({
    required this.feeAmount,
    this.feeLevel,
    this.message,
    required this.isProjected,
  });

  factory CancellationFeeInfo.fromJson(Map<String, dynamic> json) =>
      CancellationFeeInfo(
        feeAmount: (json['fee_amount'] as num?)?.toDouble() ?? 0.0,
        feeLevel: json['fee_level'],
        message: json['message'],
        isProjected: json['is_projected'] ?? false,
      );
}
