import 'package:equatable/equatable.dart';

class AvailableSlotModel extends Equatable {
  const AvailableSlotModel({
    required this.workerId,
    required this.workerName,
    required this.startTime,
    required this.endTime,
    this.date,
    this.onlyHomeService = false,
    this.homeServicePrice,
  });

  final int workerId;
  final String workerName;
  final String startTime;
  final String endTime;
  // Present in the legacy flat response; absent in the new grouped response.
  final String? date;
  final bool onlyHomeService;
  final double? homeServicePrice;

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) =>
      AvailableSlotModel(
        workerId: json['worker_id'] as int? ?? 0,
        workerName: json['worker_name'] as String? ?? '',
        startTime: json['start_time'] as String? ?? '',
        endTime: json['end_time'] as String? ?? '',
        date: json['date'] as String?,
        onlyHomeService: json['only_home_service'] as bool? ?? false,
        homeServicePrice: json['home_service_price'] != null
            ? double.tryParse(json['home_service_price'].toString())
            : null,
      );

  @override
  List<Object?> get props => [
        workerId,
        workerName,
        startTime,
        endTime,
        date,
        onlyHomeService,
        homeServicePrice,
      ];
}
