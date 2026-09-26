import 'package:ponte_glam/core/utils/date_utils.dart';

class RatingModel {
  final int id;
  final int headquarterService;
  final int user;
  final String userName;
  final String? userPicture;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final SupplierReplyModel? response;

  RatingModel({
    required this.id,
    required this.headquarterService,
    required this.user,
    required this.userName,
    this.userPicture,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.response,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json['id'] ?? 0,
        headquarterService: json['headquarter_service'] ?? 0,
        user: json['user'] ?? 0,
        userName: json['user_name'] ?? '',
        userPicture: json['user_picture'],
        rating: json['rating'] ?? 0,
        comment: json['comment'] ?? '',
        createdAt: json['created_at'] != null
            ? AppDateUtils.fromUtc(DateTime.parse(json['created_at']))
            : AppDateUtils.now(),
        response: json['response'] != null
            ? SupplierReplyModel.fromJson(json['response'])
            : null,
      );
}

class SupplierReplyModel {
  final String message;
  final DateTime? repliedAt;
  final String headquarterName;
  final String? headquarterImage;

  SupplierReplyModel({
    required this.message,
    this.repliedAt,
    required this.headquarterName,
    this.headquarterImage,
  });

  factory SupplierReplyModel.fromJson(Map<String, dynamic> json) => SupplierReplyModel(
    message: json['message'] ?? '',
    repliedAt: json['replied_at'] != null ? AppDateUtils.fromUtc(DateTime.parse(json['replied_at'])) : null,
    headquarterName: json['headquarter_name'] ?? '',
    headquarterImage: json['headquarter_image'],
  );
}
