import 'dart:convert';

import 'package:equatable/equatable.dart';

List<CategoryModel> categoriesModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(jsonDecode(str));
String categoriesModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel extends Equatable {
  final int id;

  final String description;
  final String color;
  final String picture;
  final int stateOf;

  const CategoryModel({
    required this.id,
    required this.description,
    required this.color,
    required this.picture,
    required this.stateOf,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? 0,
        description: json["description"] ?? "",
        color: json["color"] ?? "",
        picture: json["picture"] ?? "",
        stateOf: json["state_of"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "color": color,
        "picture": picture,
        "state_of": stateOf,
      };

  @override
  List<Object?> get props => [
        id,
        description,
        color,
        picture,
        stateOf,
      ];

  CategoryModel copyWith({
    int? id,
    String? description,
    String? color,
    String? picture,
    int? stateOf,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      description: description ?? this.description,
      color: color ?? this.color,
      picture: picture ?? this.picture,
      stateOf: stateOf ?? this.stateOf,
    );
  }
}
