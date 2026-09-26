import 'dart:convert';

import 'package:equatable/equatable.dart';

List<AmenityModel> amenitiesModelFromJson(String str) =>
    List<AmenityModel>.from(
        json.decode(str).map((x) => AmenityModel.fromJson(x)));

String amenitiesModelToJson(List<AmenityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AmenityModel extends Equatable {
  final int id;

  final String iconName;
  final String createdAt;
  final String updatedAt;
  final int? createdByUserId;
  final int? modifiedByUserId;
  final String code;
  final String description;
  final String color;

  const AmenityModel({
    required this.id,
    required this.iconName,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUserId,
    required this.modifiedByUserId,
    required this.code,
    required this.description,
    required this.color,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) => AmenityModel(
        id: json["id"],
        iconName: json["icon_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        createdByUserId: json["created_by_user_id"],
        modifiedByUserId: json["modified_by_user_id"],
        code: json["code"],
        description: json["description"],
        color: json["color"],
      );

  factory AmenityModel.empty() => const AmenityModel(
        id: 0,
        iconName: "",
        createdAt: "",
        updatedAt: "",
        createdByUserId: 0,
        modifiedByUserId: 0,
        code: "",
        description: "",
        color: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon_name": iconName,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "created_by_user_id": createdByUserId,
        "modified_by_user_id": modifiedByUserId,
        "code": code,
        "description": description,
        "color": color,
      };

  AmenityModel copyWith({
    int? id,
    String? iconName,
    String? createdAt,
    String? updatedAt,
    int? createdByUserId,
    int? modifiedByUserId,
    String? code,
    String? description,
    String? color,
  }) {
    return AmenityModel(
      id: id ?? this.id,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      modifiedByUserId: modifiedByUserId ?? this.modifiedByUserId,
      code: code ?? this.code,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        iconName,
        createdAt,
        updatedAt,
        createdByUserId,
        modifiedByUserId,
        code,
        description,
        color,
      ];
}
