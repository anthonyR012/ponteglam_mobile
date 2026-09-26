import 'package:equatable/equatable.dart';

class ServiceCreationFormModel extends Equatable {
  final String name;
  final String description;
  final int confirmationIn;
  final int rememberIn;
  final bool onlyHomeService;
  final double? homeServicePrice;
  final double price;
  final int? stateId;
  final int? genderId;
  final int? serviceCategoryId;
  final List<String> imagePaths;
  final List<int> amenityIds;

  const ServiceCreationFormModel({
    this.name = '',
    this.description = '',
    this.confirmationIn = 30,
    this.rememberIn = 60,
    this.onlyHomeService = false,
    this.homeServicePrice,
    this.price = 0.0,
    this.stateId,
    this.genderId,
    this.serviceCategoryId,
    this.imagePaths = const [],
    this.amenityIds = const [],
  });

  ServiceCreationFormModel copyWith({
    String? name,
    String? description,
    int? confirmationIn,
    int? rememberIn,
    bool? onlyHomeService,
    double? homeServicePrice,
    double? price,
    int? stateId,
    int? genderId,
    int? serviceCategoryId,
    List<String>? imagePaths,
    List<int>? amenityIds,
  }) {
    return ServiceCreationFormModel(
      name: name ?? this.name,
      description: description ?? this.description,
      confirmationIn: confirmationIn ?? this.confirmationIn,
      rememberIn: rememberIn ?? this.rememberIn,
      onlyHomeService: onlyHomeService ?? this.onlyHomeService,
      homeServicePrice: homeServicePrice ?? this.homeServicePrice,
      price: price ?? this.price,
      stateId: stateId ?? this.stateId,
      genderId: genderId ?? this.genderId,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      imagePaths: imagePaths ?? this.imagePaths,
      amenityIds: amenityIds ?? this.amenityIds,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        confirmationIn,
        rememberIn,
        onlyHomeService,
        homeServicePrice,
        price,
        stateId,
        genderId,
        serviceCategoryId,
        imagePaths,
        amenityIds,
      ];
}
