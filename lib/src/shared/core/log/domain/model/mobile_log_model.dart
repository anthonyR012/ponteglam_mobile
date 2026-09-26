import 'dart:convert';
import 'package:equatable/equatable.dart';

List<MobileLogModel> mobileLogsModelFromJson(String str) =>
    List<MobileLogModel>.from(
        json.decode(str).map((x) => MobileLogModel.fromJson(x)));

String mobileLogsModelToJson(List<MobileLogModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MobileLogModel extends Equatable {
  final String deviceInfo;
  final String description;
  final String source;

  const MobileLogModel({
    required this.deviceInfo,
    required this.description,
    required this.source,
  });

  factory MobileLogModel.fromJson(Map<String, dynamic> json) => MobileLogModel(
        deviceInfo: json["device_info"] ?? "",
        description: json["description"] ?? "",
        source: json["source"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "device_info": deviceInfo,
        "description": description,
        "source": source,
      };

  @override
  List<Object?> get props => [deviceInfo, description, source];
}
