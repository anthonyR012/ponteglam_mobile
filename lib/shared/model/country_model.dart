// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(
    json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel extends Equatable {
  final int id;
  final String code3;
  final String name;
  final String phone;

  const CountryModel({
    required this.id,
    required this.code3,
    required this.name,
    required this.phone,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"],
        code3: json["code3"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code3": code3,
        "name": name,
        "phone": phone,
      };

  CountryModel copyWith({
    int? id,
    String? code3,
    String? name,
    String? phone,
  }) =>
      CountryModel(
        id: id ?? this.id,
        code3: code3 ?? this.code3,
        name: name ?? this.name,
        phone: phone ?? this.phone,
      );

  @override
  List<Object?> get props => [
        id,
        code3,
        name,
        phone,
      ];
}
