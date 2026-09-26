import 'dart:convert';
import 'package:equatable/equatable.dart';

CreateAppointmentResponse createAppointmentResponseFromJson(String str) =>
    CreateAppointmentResponse.fromJson(json.decode(str));

class CreateAppointmentResponse extends Equatable {
  final int appointmentId;
  final String detail;

  const CreateAppointmentResponse({
    required this.appointmentId,
    required this.detail,
  });

  factory CreateAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      CreateAppointmentResponse(
        appointmentId: json["appointment_id"],
        detail: json["detail"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "appointment_id": appointmentId,
        "detail": detail,
      };

  @override
  List<Object?> get props => [appointmentId, detail];
}
