import 'dart:convert';

import 'package:equatable/equatable.dart';

List<AddressModel> addressesModelFromJson(String str) =>
    List<AddressModel>.from(
        json.decode(str).map((x) => AddressModel.fromJson(x)));

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressesModelToJson(List<AddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel extends Equatable {
  final int? id;
  final String address;
  final String latitude;
  final String longitude;

  const AddressModel({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.id,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"] ?? json["pk"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  factory AddressModel.empty() => const AddressModel(
        address: "",
        id: 0,
        latitude: "",
        longitude: "",
      );

  AddressModel copyWith({
    String? address,
    int? id,
    String? latitude,
    String? longitude,
  }) {
    return AddressModel(
      id: id ?? this.id,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "id": id,
      };

  Map<String, dynamic> toMapUpdate() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "user_address_id": id,
      };

  @override
  List<Object?> get props => [address, latitude, id, longitude];
}
