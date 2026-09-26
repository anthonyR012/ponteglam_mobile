import 'package:equatable/equatable.dart';

class CompanyFormModel extends Equatable {
  final String companyName;
  final String companyDescription;
  final String? companyProfileImagePath;
  final String? companyCoverImagePath;
  final String? nequiNumber;

  final String headquarterName;
  final String headquarterPhone;
  final String headquarterAddress;
  final String headquarterLatitude;
  final String headquarterLongitude;
  final int? cityId;
  final List<String> additionalImagesPaths;

  final Map<String, String> workHours; // e.g., {"monday": "08:00:00-18:00:00"}

  final int currentStep;
  final int? createdCompanyId;
  final int? createdHeadquarterId;

  const CompanyFormModel({
    this.companyName = '',
    this.companyDescription = '',
    this.companyProfileImagePath,
    this.companyCoverImagePath,
    this.nequiNumber,
    this.headquarterName = '',
    this.headquarterPhone = '',
    this.headquarterAddress = '',
    this.headquarterLatitude = '',
    this.headquarterLongitude = '',
    this.cityId,
    this.additionalImagesPaths = const [],
    this.workHours = const {},
    this.currentStep = 0,
    this.createdCompanyId,
    this.createdHeadquarterId,
  });

  factory CompanyFormModel.fromJson(Map<String, dynamic> json) {
    return CompanyFormModel(
      companyName: json['companyName'] ?? '',
      companyDescription: json['companyDescription'] ?? '',
      companyProfileImagePath: json['companyProfileImagePath'],
      companyCoverImagePath: json['companyCoverImagePath'],
      nequiNumber: json['nequiNumber'],
      headquarterName: json['headquarterName'] ?? '',
      headquarterPhone: json['headquarterPhone'] ?? '',
      headquarterAddress: json['headquarterAddress'] ?? '',
      headquarterLatitude: json['headquarterLatitude'] ?? '',
      headquarterLongitude: json['headquarterLongitude'] ?? '',
      cityId: json['cityId'],
      additionalImagesPaths:
          List<String>.from(json['additionalImagesPaths'] ?? []),
      workHours: Map<String, String>.from(json['workHours'] ?? {}),
      currentStep: json['currentStep'] ?? 0,
      createdCompanyId: json['createdCompanyId'],
      createdHeadquarterId: json['createdHeadquarterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companyDescription': companyDescription,
      'companyProfileImagePath': companyProfileImagePath,
      'companyCoverImagePath': companyCoverImagePath,
      'nequiNumber': nequiNumber,
      'headquarterName': headquarterName,
      'headquarterPhone': headquarterPhone,
      'headquarterAddress': headquarterAddress,
      'headquarterLatitude': headquarterLatitude,
      'headquarterLongitude': headquarterLongitude,
      'cityId': cityId,
      'additionalImagesPaths': additionalImagesPaths,
      'workHours': workHours,
      'currentStep': currentStep,
      'createdCompanyId': createdCompanyId,
      'createdHeadquarterId': createdHeadquarterId,
    };
  }

  CompanyFormModel copyWith({
    String? companyName,
    String? companyDescription,
    String? companyProfileImagePath,
    String? companyCoverImagePath,
    String? nequiNumber,
    String? headquarterName,
    String? headquarterPhone,
    String? headquarterAddress,
    String? headquarterLatitude,
    String? headquarterLongitude,
    int? cityId,
    List<String>? additionalImagesPaths,
    Map<String, String>? workHours,
    int? currentStep,
    int? createdCompanyId,
    int? createdHeadquarterId,
  }) {
    return CompanyFormModel(
      companyName: companyName ?? this.companyName,
      companyDescription: companyDescription ?? this.companyDescription,
      companyProfileImagePath:
          companyProfileImagePath ?? this.companyProfileImagePath,
      companyCoverImagePath:
          companyCoverImagePath ?? this.companyCoverImagePath,
      nequiNumber: nequiNumber ?? this.nequiNumber,
      headquarterName: headquarterName ?? this.headquarterName,
      headquarterPhone: headquarterPhone ?? this.headquarterPhone,
      headquarterAddress: headquarterAddress ?? this.headquarterAddress,
      headquarterLatitude: headquarterLatitude ?? this.headquarterLatitude,
      headquarterLongitude: headquarterLongitude ?? this.headquarterLongitude,
      cityId: cityId ?? this.cityId,
      additionalImagesPaths:
          additionalImagesPaths ?? this.additionalImagesPaths,
      workHours: workHours ?? this.workHours,
      currentStep: currentStep ?? this.currentStep,
      createdCompanyId: createdCompanyId ?? this.createdCompanyId,
      createdHeadquarterId: createdHeadquarterId ?? this.createdHeadquarterId,
    );
  }

  @override
  List<Object?> get props => [
        companyName,
        companyDescription,
        companyProfileImagePath,
        companyCoverImagePath,
        nequiNumber,
        headquarterName,
        headquarterPhone,
        headquarterAddress,
        headquarterLatitude,
        headquarterLongitude,
        cityId,
        additionalImagesPaths,
        workHours,
        currentStep,
        createdCompanyId,
        createdHeadquarterId,
      ];
}
