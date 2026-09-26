import 'dart:convert';

import 'package:equatable/equatable.dart';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) =>
    json.encode(data.toJson());

class NotificationListModel extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationModel> results;

  const NotificationListModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory NotificationListModel.empty() => NotificationListModel(
        count: 0,
        next: null,
        previous: null,
        results: List<NotificationModel>.empty(),
      );

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<NotificationModel>.from(
            json["results"].map((x) => NotificationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [results];

  NotificationListModel copyWith({
    int? count,
    String? next,
    String? previous,
    List<NotificationModel>? results,
  }) =>
      NotificationListModel(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        results: results ?? this.results,
      );
}

List<NotificationModel> notificationsFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationsToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String createdAt;
  final String body;
  final bool isRead;
  final String? image;
  final String? goTo;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.body,
    required this.isRead,
    this.image,
    this.goTo,
    this.data,
  });

  factory NotificationModel.empty() {
    return const NotificationModel(
      id: 0,
      title: '',
      subtitle: '',
      createdAt: '',
      body: '',
      isRead: false,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"] ?? '',
        createdAt: json["created_at"] ?? '',
        body: json["body"],
        image: json["image"],
        isRead: json["is_read"] ?? false,
        goTo: json["go_to"],
        data: json["data"],
      );

  NotificationModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? createdAt,
    String? body,
    bool? isRead,
    String? image,
    String? goTo,
    Map<String, dynamic>? data,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        createdAt: createdAt ?? this.createdAt,
        body: body ?? this.body,
        isRead: isRead ?? this.isRead,
        image: image ?? this.image,
        goTo: goTo ?? this.goTo,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "created_at": createdAt,
        "body": body,
        "is_read": isRead,
        "go_to": goTo,
        "data": data,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        createdAt,
        body,
        isRead,
        goTo,
        data,
      ];
}
