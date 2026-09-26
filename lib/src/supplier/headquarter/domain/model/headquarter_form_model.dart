import 'package:equatable/equatable.dart';

class HeadquarterFormModel extends Equatable {
  final int companyId;
  final int? headquarterId;
  final String headquarterName;
  final String headquarterPhone;
  final String headquarterAddress;
  final String headquarterLatitude;
  final String headquarterLongitude;
  final int? cityId;
  final List<String> additionalImagesPaths;
  final String? existingImageUrl;

  final Map<String, String> workHours;

  final int currentStep;
  final int? createdHeadquarterId;

  const HeadquarterFormModel({
    required this.companyId,
    this.headquarterId,
    this.headquarterName = '',
    this.headquarterPhone = '',
    this.headquarterAddress = '',
    this.headquarterLatitude = '',
    this.headquarterLongitude = '',
    this.cityId,
    this.additionalImagesPaths = const [],
    this.existingImageUrl,
    this.workHours = const {},
    this.currentStep = 0,
    this.createdHeadquarterId,
  });

  factory HeadquarterFormModel.fromJson(Map<String, dynamic> json) {
    return HeadquarterFormModel(
      companyId: json['companyId'] ?? 0,
      headquarterId: json['headquarterId'],
      headquarterName: json['headquarterName'] ?? '',
      headquarterPhone: json['headquarterPhone'] ?? '',
      headquarterAddress: json['headquarterAddress'] ?? '',
      headquarterLatitude: json['headquarterLatitude'] ?? '',
      headquarterLongitude: json['headquarterLongitude'] ?? '',
      cityId: json['cityId'],
      additionalImagesPaths:
          List<String>.from(json['additionalImagesPaths'] ?? []),
      existingImageUrl: json['existingImageUrl'],
      workHours: Map<String, String>.from(json['workHours'] ?? {}),
      currentStep: json['currentStep'] ?? 0,
      createdHeadquarterId: json['createdHeadquarterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'headquarterId': headquarterId,
      'headquarterName': headquarterName,
      'headquarterPhone': headquarterPhone,
      'headquarterAddress': headquarterAddress,
      'headquarterLatitude': headquarterLatitude,
      'headquarterLongitude': headquarterLongitude,
      'cityId': cityId,
      'additionalImagesPaths': additionalImagesPaths,
      'existingImageUrl': existingImageUrl,
      'workHours': workHours,
      'currentStep': currentStep,
      'createdHeadquarterId': createdHeadquarterId,
    };
  }

  HeadquarterFormModel copyWith({
    int? companyId,
    int? headquarterId,
    String? headquarterName,
    String? headquarterPhone,
    String? headquarterAddress,
    String? headquarterLatitude,
    String? headquarterLongitude,
    int? cityId,
    List<String>? additionalImagesPaths,
    String? existingImageUrl,
    Map<String, String>? workHours,
    int? currentStep,
    int? createdHeadquarterId,
  }) {
    return HeadquarterFormModel(
      companyId: companyId ?? this.companyId,
      headquarterId: headquarterId ?? this.headquarterId,
      headquarterName: headquarterName ?? this.headquarterName,
      headquarterPhone: headquarterPhone ?? this.headquarterPhone,
      headquarterAddress: headquarterAddress ?? this.headquarterAddress,
      headquarterLatitude: headquarterLatitude ?? this.headquarterLatitude,
      headquarterLongitude: headquarterLongitude ?? this.headquarterLongitude,
      cityId: cityId ?? this.cityId,
      additionalImagesPaths:
          additionalImagesPaths ?? this.additionalImagesPaths,
      existingImageUrl: existingImageUrl ?? this.existingImageUrl,
      workHours: workHours ?? this.workHours,
      currentStep: currentStep ?? this.currentStep,
      createdHeadquarterId: createdHeadquarterId ?? this.createdHeadquarterId,
    );
  }

  @override
  List<Object?> get props => [
        companyId,
        headquarterId,
        headquarterName,
        headquarterPhone,
        headquarterAddress,
        headquarterLatitude,
        headquarterLongitude,
        cityId,
        additionalImagesPaths,
        existingImageUrl,
        workHours,
        currentStep,
        createdHeadquarterId,
      ];
}
