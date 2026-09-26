import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';

class AvailableDateModel extends Equatable {
  const AvailableDateModel({
    required this.date,
    required this.slots,
  });

  final String date;
  final List<AvailableSlotModel> slots;

  factory AvailableDateModel.fromJson(Map<String, dynamic> json) =>
      AvailableDateModel(
        date: json['date'] as String,
        slots: (json['slots'] as List<dynamic>)
            .map((e) => AvailableSlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [date, slots];
}
