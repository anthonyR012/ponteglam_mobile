import 'dart:convert';

import 'package:equatable/equatable.dart';

WorkerModel workerModelFromJson(String str) =>
    WorkerModel.fromJson(json.decode(str));

String workerModelToJson(WorkerModel data) => json.encode(data.toJson());

class WorkerModel extends Equatable {
  final int id;
  final int? workerId;
  final String email;
  final String fullName;
  final String phone;
  final String? address;
  final int? gender;
  final int? city;
  final String? dateOfBirth;
  final String? uuidGoogle;
  final String picture;

  const WorkerModel({
    required this.id,
    this.workerId,
    required this.email,
    required this.fullName,
    required this.phone,
    this.address,
    this.gender,
    this.city,
    this.dateOfBirth,
    this.uuidGoogle,
    required this.picture,
  });

  factory WorkerModel.empty() {
    return const WorkerModel(
      id: 0,
      email: '',
      fullName: '',
      phone: '',
      picture: '',
    );
  }

  factory WorkerModel.fromJson(Map<String, dynamic> json) => WorkerModel(
        id: json["pk"] ?? json["id"] ?? 0,
        workerId: json["worker_id"],
        email: json["email"] ?? "",
        fullName: json["full_name"] ?? "",
        phone: json["phone"] ?? "",
        address: json["address"],
        gender: json["gender"],
        city: json["city"],
        dateOfBirth: json["date_of_birth"],
        uuidGoogle: json["uuid_google"],
        picture: json["picture"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "worker_id": workerId,
        "email": email,
        "full_name": fullName,
        "phone": phone,
        "address": address,
        "gender": gender,
        "city": city,
        "date_of_birth": dateOfBirth,
        "uuid_google": uuidGoogle,
        "picture": picture,
      };

  @override
  List<Object?> get props => [
        id,
        workerId,
        email,
        fullName,
        phone,
        address,
        gender,
        city,
        dateOfBirth,
        uuidGoogle,
        picture,
      ];
}
