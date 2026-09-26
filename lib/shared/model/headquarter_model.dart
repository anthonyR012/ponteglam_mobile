import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/shared/model/company_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

HeadquarterModel headquarterModelFromJson(String str) =>
    HeadquarterModel.fromJson(json.decode(str));

String headquarterModelToJson(HeadquarterModel data) =>
    json.encode(data.toJson());

class HeadquarterModel extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdByUserId;
  final int? modifiedByUserId;
  final String name;
  final CompanyModel? companyInfo;
  final String? phoneNumber;
  final String latitude;
  final String longitude;
  final int? cityId;
  final int? typeId;
  final int? companyId;
  final int? countryId;
  final String? address;
  final String? imageUrl;
  final int ratingCount;
  final double rating;
  final bool like;
  final List<ServiceModel> services;

  const HeadquarterModel({
    required this.id,
    required this.address,
    required this.ratingCount,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUserId,
    required this.modifiedByUserId,
    required this.name,
    this.companyInfo,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.typeId,
    required this.companyId,
    required this.countryId,
    required this.imageUrl,
    required this.services,
    required this.like,
  });

  factory HeadquarterModel.empty() {
    return HeadquarterModel(
      createdByUserId: null,
      modifiedByUserId: null,
      updatedAt: AppDateUtils.now(),
      id: 0,
      name: '',
      companyInfo: null,
      ratingCount: 0,
      rating: 0.0,
      phoneNumber: '',
      address: '',
      latitude: '',
      longitude: '',
      cityId: 0,
      typeId: 0,
      companyId: 0,
      countryId: 0,
      imageUrl: '',
      createdAt: AppDateUtils.now(),
      like: false,
      services: const [],
    );
  }

  factory HeadquarterModel.fromJson(Map<String, dynamic> json) =>
      HeadquarterModel(
        id: json["id"],
        createdAt: AppDateUtils.fromUtc(DateTime.parse(json["created_at"])),
        updatedAt: AppDateUtils.fromUtc(DateTime.parse(json["updated_at"])),
        createdByUserId: json["created_by_user_id"],
        address: json["address"],
        modifiedByUserId: json["modified_by_user_id"],
        ratingCount: json["rating_count"],
        rating: json["rating"],
        name: json["name"],
        companyInfo: json["company_info"] != null ? CompanyModel.fromJson(json["company_info"]) : null,
        phoneNumber: json["phone_number"],
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        cityId: json["geo_reference_city"],
        typeId: json["type"],
        companyId: json["company"],
        countryId: json["country"],
        imageUrl: json["image_url"],
        like: json["like"],
        services: List<ServiceModel>.from(
            json["services"].map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by_user_id": createdByUserId,
        "modified_by_user_id": modifiedByUserId,
        "name": name,
        "company_info": companyInfo?.toJson(),
        "rating_count": ratingCount,
        "rating": rating,
        "phone_number": phoneNumber,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "geo_reference_city": cityId,
        "type": typeId,
        "company": companyId,
        "country": countryId,
        "like": like,
        "image_url": imageUrl,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };

  HeadquarterModel copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdByUserId,
    int? modifiedByUserId,
    String? name,
    CompanyModel? companyInfo,
    int? ratingCount,
    double? rating,
    String? phoneNumber,
    String? latitude,
    String? longitude,
    String? distanceKm,
    int? cityId,
    int? typeId,
    int? companyId,
    int? countryId,
    String? address,
    String? imageUrl,
    bool? like,
    List<ServiceModel>? services,
  }) {
    return HeadquarterModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      modifiedByUserId: modifiedByUserId ?? this.modifiedByUserId,
      name: name ?? this.name,
      companyInfo: companyInfo ?? this.companyInfo,
      ratingCount: ratingCount ?? this.ratingCount,
      rating: rating ?? this.rating,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityId: cityId ?? this.cityId,
      typeId: typeId ?? this.typeId,
      companyId: companyId ?? this.companyId,
      countryId: countryId ?? this.countryId,
      address: address ?? this.address,
      like: like ?? this.like,
      imageUrl: imageUrl ?? this.imageUrl,
      services: services ?? this.services,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        createdByUserId,
        modifiedByUserId,
        name,
        companyInfo,
        ratingCount,
        rating,
        phoneNumber,
        latitude,
        longitude,
        address,
        cityId,
        typeId,
        companyId,
        countryId,
        imageUrl,
        like,
        services,
      ];
}
