// To parse this JSON data, do
//
//     final paginatorModel = paginatorModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';

PaginatorServiceModel paginatorServiceModelFromJson(String str) =>
    PaginatorServiceModel.fromJson(json.decode(str));

String paginatorServiceModelToJson(PaginatorServiceModel data) =>
    json.encode(data.toJson());

class MyRatingModel extends Equatable {
  final int id;
  final int rating;
  final String comment;

  const MyRatingModel({
    required this.id,
    required this.rating,
    required this.comment,
  });

  factory MyRatingModel.fromJson(Map<String, dynamic> json) => MyRatingModel(
        id: json["id"],
        rating: json["rating"] ?? 0,
        comment: json["comment"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "comment": comment,
      };

  @override
  List<Object?> get props => [id, rating, comment];
}

class PaginatorServiceModel extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<HeadquarterModel> headquarters;

  const PaginatorServiceModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.headquarters,
  });

  factory PaginatorServiceModel.fromJson(Map<String, dynamic> json) =>
      PaginatorServiceModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        headquarters: List<HeadquarterModel>.from(
            json["results"].map((x) => HeadquarterModel.fromJson(x))),
      );

  factory PaginatorServiceModel.empty() => const PaginatorServiceModel(
        count: 0,
        next: '',
        previous: '',
        headquarters: [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(headquarters.map((x) => x.toJson())),
      };

  PaginatorServiceModel copyWith({
    int? count,
    String? next,
    String? previous,
    List<HeadquarterModel>? headquarters,
  }) =>
      PaginatorServiceModel(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        headquarters: headquarters ?? this.headquarters,
      );

  @override
  List<Object?> get props => [
        count,
        next,
        previous,
        headquarters,
      ];
}

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final int confirmationIn;
  final int rememberIn;
  final bool onlyHomeService;
  final double? homeServicePrice;
  final double price;
  final int? stateId;
  final int? genderId;
  final int? typeId;
  final int serviceDuration;
  final int? categoryServiceId;
  final List<String> images;
  final List<int> amenities;
  final double rating;
  final int ratingCount;
  final bool canRate;
  final MyRatingModel? myRating;

  const ServiceModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.confirmationIn,
      required this.rememberIn,
      required this.onlyHomeService,
      this.homeServicePrice,
      required this.price,
      required this.stateId,
      required this.genderId,
      required this.typeId,
      required this.categoryServiceId,
      required this.images,
      required this.amenities,
      required this.serviceDuration,
      this.rating = 0.0,
      this.ratingCount = 0,
      this.canRate = false,
      this.myRating});

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        confirmationIn: json["confirmation_in"],
        rememberIn: json["remember_in"],
        onlyHomeService: json["only_home_service"],
        homeServicePrice: json["home_service_price"] != null
            ? double.tryParse(json["home_service_price"].toString())
            : null,
        price: json["price"],
        stateId: json["state"],
        genderId: json["gender"],
        typeId: json["type"],
        serviceDuration: json["service_duration"],
        categoryServiceId: json["service_category"],
        images: List<String>.from(json["images"].map((x) => x)),
        amenities: List<int>.from(json["amenities"].map((x) => x)),
        rating: json["rating"] != null ? double.tryParse(json["rating"].toString()) ?? 0.0 : 0.0,
        ratingCount: json["rating_count"] ?? 0,
        canRate: json["can_rate"] ?? false,
        myRating: json["my_rating"] != null ? MyRatingModel.fromJson(json["my_rating"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "confirmation_in": confirmationIn,
        "remember_in": rememberIn,
        "only_home_service": onlyHomeService,
        if (homeServicePrice != null) "home_service_price": homeServicePrice,
        "price": price,
        "service_duration": serviceDuration,
        "state": stateId,
        "gender": genderId,
        "type": typeId,
        "service_category": categoryServiceId,
        "images": List<String>.from(images.map((x) => x)),
        "amenities": List<int>.from(amenities.map((x) => x)),
        "rating": rating,
        "rating_count": ratingCount,
        "can_rate": canRate,
        if (myRating != null) "my_rating": myRating!.toJson(),
      };

  ServiceModel copyWith({
    int? id,
    String? name,
    String? description,
    int? confirmationIn,
    int? rememberIn,
    bool? onlyHomeService,
    double? homeServicePrice,
    double? price,
    int? stateId,
    int? genderId,
    int? typeId,
    int? serviceDuration,
    int? categoryServiceId,
    List<String>? images,
    List<int>? amenities,
    double? rating,
    int? ratingCount,
    bool? canRate,
    MyRatingModel? myRating,
  }) =>
      ServiceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        confirmationIn: confirmationIn ?? this.confirmationIn,
        rememberIn: rememberIn ?? this.rememberIn,
        onlyHomeService: onlyHomeService ?? this.onlyHomeService,
        homeServicePrice: homeServicePrice ?? this.homeServicePrice,
        price: price ?? this.price,
        stateId: stateId ?? this.stateId,
        genderId: genderId ?? this.genderId,
        typeId: typeId ?? this.typeId,
        serviceDuration: serviceDuration ?? this.serviceDuration,
        categoryServiceId: categoryServiceId ?? this.categoryServiceId,
        images: images ?? this.images,
        amenities: amenities ?? this.amenities,
        rating: rating ?? this.rating,
        ratingCount: ratingCount ?? this.ratingCount,
        canRate: canRate ?? this.canRate,
        myRating: myRating ?? this.myRating,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        confirmationIn,
        rememberIn,
        onlyHomeService,
        homeServicePrice,
        price,
        stateId,
        genderId,
        typeId,
        serviceDuration,
        categoryServiceId,
        images,
        amenities,
        rating,
        ratingCount,
        canRate,
        myRating,
      ];
}

class FilterServiceModel extends Equatable {
  final int? category;
  final double? rating;
  final String? query;
  final String? nextUrl;
  final bool onlyOffers;
  final bool onlyVerified;
  final bool nearMe;
  final double minPrice;
  final double maxPrice;
  final bool isRefresh;
  final bool isFirstLoad;
  final bool mine;
  final bool onlyHomeService;
  final List<String> availableFor;

  const FilterServiceModel(
      {this.rating,
      this.minPrice = 1000,
      this.maxPrice = 1000000,
      this.category,
      this.nextUrl,
      this.query,
      this.mine = false,
      this.onlyHomeService = false,
      this.availableFor = const [],
      this.onlyOffers = false,
      this.isRefresh = false,
      this.isFirstLoad = false,
      this.onlyVerified = false,
      this.nearMe = true});

  FilterServiceModel copyWith({
    int? category,
    double? rating,
    String? query,
    bool? onlyOffers,
    bool? onlyVerified,
    String? nextUrl,
    bool? nearMe,
    bool? isRefresh,
    bool? isFirstLoad,
    bool? mine,
    bool? onlyHomeService,
    double? minPrice,
    double? maxPrice,
    List<String>? availableFor,
  }) =>
      FilterServiceModel(
        category: category ?? this.category,
        rating: rating ?? this.rating,
        query: query ?? this.query,
        nextUrl: nextUrl ?? this.nextUrl,
        onlyOffers: onlyOffers ?? this.onlyOffers,
        onlyVerified: onlyVerified ?? this.onlyVerified,
        isRefresh: isRefresh ?? this.isRefresh,
        isFirstLoad: isFirstLoad ?? this.isFirstLoad,
        mine: mine ?? this.mine,
        onlyHomeService: onlyHomeService ?? this.onlyHomeService,
        nearMe: nearMe ?? this.nearMe,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        availableFor: availableFor ?? this.availableFor,
      );

  factory FilterServiceModel.empty() => const FilterServiceModel();

  @override
  List<Object?> get props => [
        rating,
        minPrice,
        maxPrice,
        category,
        query,
        isRefresh,
        nextUrl,
        isFirstLoad,
        mine,
        onlyHomeService,
        availableFor,
        onlyOffers,
        onlyVerified,
        nearMe,
      ];

  bool get isFiltering =>
      (rating != null && rating! > 0) ||
      minPrice > 1000 ||
      maxPrice < 1000000 ||
      onlyHomeService ||
      availableFor.isNotEmpty ||
      !nearMe ||
      (query != null && query!.isNotEmpty);

  int get filterCount {
    int count = 0;
    if (rating != null && rating! > 0) count++;
    if (minPrice > 1000 || maxPrice < 1000000) count++;
    if (onlyHomeService) count++;
    if (!nearMe) count++;
    if (availableFor.isNotEmpty) count++;
    if (query != null && query!.isNotEmpty) count++;
    return count;
  }
}
