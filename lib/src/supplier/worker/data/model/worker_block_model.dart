class WorkerBlockModel {
  final int? id;
  final int workerId;
  final DateTime startTime;
  final DateTime endTime;
  final String? reason;

  WorkerBlockModel({
    this.id,
    required this.workerId,
    required this.startTime,
    required this.endTime,
    this.reason,
  });

  factory WorkerBlockModel.fromJson(Map<String, dynamic> json) {
    return WorkerBlockModel(
      id: json['id'],
      workerId: json['worker'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() => {
    'worker': workerId,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'reason': reason,
  };
}
