// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());
String userModelSingUpToJson(UserModel data) =>
    json.encode(data.toJsonSingUp());

class UserModel extends Equatable {
  final int? id;

  final String? email;
  final String? lastLogin;
  final bool? isSuperuser;
  final String? username;
  final String? firstName;
  final String? lastName;
  final bool? isStaff;
  final bool? isActive;
  final bool? emailVerified;
  final String? dateJoined;
  final String? fullName;
  final String? address;
  final String? phone;
  final String? dateOfBirth;
  final String? identification;
  final String? uuidGoogle;
  final String? googleAccessToken;
  final String? picture;
  final int? cityId;
  final int? genderId;
  final int? typeId;
  final int? stateId;
  final int? loginId;
  final String? token;
  final String? password;
  final String? registrationId;
  final String? typeDevice;
  final String? deviceId;
  final String? loginCode;
  final bool? hasPassword;
  final bool? hasAcceptedTerms;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.username,
    required this.fullName,
    this.deviceId,
    this.typeDevice,
    this.registrationId,
    this.emailVerified,
    this.lastLogin,
    this.isSuperuser,
    this.firstName,
    this.lastName,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.address,
    this.phone,
    this.dateOfBirth,
    this.identification,
    this.uuidGoogle,
    this.googleAccessToken,
    this.picture,
    this.cityId,
    this.genderId,
    this.typeId,
    this.stateId,
    this.loginId,
    this.loginCode,
    this.hasPassword,
    this.hasAcceptedTerms,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        lastLogin: json["last_login"],
        typeDevice: json["type_device"],
        isSuperuser: json["is_superuser"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: json["date_joined"],
        fullName: json["full_name"],
        address: json["address"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"],
        identification: json["identification"],
        uuidGoogle: json["uuid_google"],
        googleAccessToken: json["access_google_token"],
        picture: json["picture"],
        cityId: json["city"],
        genderId: json["gender"],
        typeId: json["type"],
        registrationId: json["registration_id"],
        deviceId: json["device_id"],
        stateId: json["state"],
        loginId: json["login"],
        emailVerified: json["email_verified"],
        token: json["token"],
        loginCode: json["login_code"],
        hasPassword: json["has_password"],
        hasAcceptedTerms: json["has_accepted_terms"],
      );

  factory UserModel.empty() => const UserModel(
        id: 0,
        email: '',
        password: '',
        token: '',
        username: '',
        fullName: '',
        typeDevice: '',
        registrationId: '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "last_login": lastLogin,
        "is_superuser": isSuperuser,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "is_staff": isStaff,
        "device_id": deviceId,
        "is_active": isActive,
        "date_joined": dateJoined,
        "full_name": fullName,
        "address": address,
        "type_device": typeDevice,
        "phone": phone,
        "registration_id": registrationId,
        "date_of_birth": dateOfBirth,
        "identification": identification,
        "uuid_google": uuidGoogle,
        "access_google_token": googleAccessToken,
        "picture": picture,
        "city": cityId,
        "gender": genderId,
        "type": typeId,
        "state": stateId,
        "password": password,
        "email_verified": emailVerified,
        "login": loginId,
        "token": token,
        "login_code": loginCode,
        "has_password": hasPassword,
        "has_accepted_terms": hasAcceptedTerms,
      };

  Map<String, dynamic> toJsonSingUp() => {
        "email": email,
        "full_name": fullName,
        "registration_id": registrationId,
        "type_device": typeDevice,
        "password": password,
        "picture": picture,
      };

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? lastLogin,
    bool? isSuperuser,
    String? username,
    String? firstName,
    String? lastName,
    bool? isStaff,
    bool? isActive,
    String? dateJoined,
    String? fullName,
    String? address,
    String? phone,
    String? dateOfBirth,
    String? identification,
    String? uuidGoogle,
    String? googleAccessToken,
    String? picture,
    String? registrationId,
    int? cityId,
    int? genderId,
    int? typeId,
    int? stateId,
    int? loginId,
    bool? emailVerified,
    String? token,
    String? typeDevice,
    String? deviceId,
    String? loginCode,
    bool? hasPassword,
    bool? hasAcceptedTerms,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        token: token ?? this.token,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        deviceId: deviceId ?? this.deviceId,
        typeDevice: typeDevice ?? this.typeDevice,
        registrationId: registrationId ?? this.registrationId,
        emailVerified: emailVerified ?? this.emailVerified,
        lastLogin: lastLogin ?? this.lastLogin,
        isSuperuser: isSuperuser ?? this.isSuperuser,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        isStaff: isStaff ?? this.isStaff,
        isActive: isActive ?? this.isActive,
        dateJoined: dateJoined ?? this.dateJoined,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        identification: identification ?? this.identification,
        uuidGoogle: uuidGoogle ?? this.uuidGoogle,
        googleAccessToken: googleAccessToken ?? this.googleAccessToken,
        picture: picture ?? this.picture,
        cityId: cityId ?? this.cityId,
        genderId: genderId ?? this.genderId,
        typeId: typeId ?? this.typeId,
        stateId: stateId ?? this.stateId,
        loginId: loginId ?? this.loginId,
        loginCode: loginCode ?? this.loginCode,
        hasPassword: hasPassword ?? this.hasPassword,
        hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      );

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        lastLogin,
        isSuperuser,
        username,
        firstName,
        lastName,
        isStaff,
        isActive,
        dateJoined,
        fullName,
        address,
        phone,
        dateOfBirth,
        identification,
        uuidGoogle,
        googleAccessToken,
        picture,
        cityId,
        genderId,
        typeId,
        stateId,
        loginId,
        emailVerified,
        token,
        loginCode,
        hasPassword,
        hasAcceptedTerms,
      ];
}
