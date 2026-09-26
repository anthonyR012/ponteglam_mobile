import 'dart:convert';

import 'package:equatable/equatable.dart';

List<TypeModel> typeModelFromJson(String str) =>
    List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));

String typeModelToJson(List<TypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel extends Equatable {
  final int id;

  final String code;
  final String description;
  final String categoryTypeCode;

  const TypeModel({
    required this.id,
    required this.code,
    required this.description,
    required this.categoryTypeCode,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        categoryTypeCode: json["category_type_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "category_type_code": categoryTypeCode,
      };

  TypeModel copyWith({
    int? id,
    String? code,
    String? description,
    String? categoryTypeCode,
  }) =>
      TypeModel(
        id: id ?? this.id,
        code: code ?? this.code,
        description: description ?? this.description,
        categoryTypeCode: categoryTypeCode ?? this.categoryTypeCode,
      );

  @override
  List<Object?> get props => [
        id,
        code,
        description,
        categoryTypeCode,
      ];
}
