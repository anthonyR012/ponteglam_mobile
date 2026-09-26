import 'package:ponte_glam/shared/model/user_model.dart';

class StaffMemberModel {
  final int workerId;
  final String? name;
  final UserModel? userDetails;
  final List<StaffServiceLinkModel> services;
  final String status; // 'active', 'pending_removal', 'invitation_pending'

  StaffMemberModel({
    required this.workerId,
    this.name,
    this.userDetails,
    required this.services,
    required this.status,
  });

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    // Inferring status
    String inferredStatus = 'active';

    // Check if any service is pending removal
    final servicesJson = json['services'] as List? ?? [];
    final services =
        servicesJson.map((e) => StaffServiceLinkModel.fromJson(e)).toList();

    if (services.any((s) => s.isPendingRemoval)) {
      inferredStatus = 'pending_removal';
    }

    return StaffMemberModel(
      workerId: json['worker_id'],
      name: json['name'],
      userDetails: json['user_details'] != null
          ? UserModel.fromJson(json['user_details'])
          : null,
      services: services,
      status: inferredStatus,
    );
  }

  String get displayName => name ?? userDetails?.fullName ?? 'Sin nombre';
  String get displayPicture => userDetails?.picture ?? '';
}

class StaffServiceLinkModel {
  final int id;
  final String name;
  final bool isPendingRemoval;
  final DateTime? removalDate;

  StaffServiceLinkModel({
    required this.id,
    required this.name,
    this.isPendingRemoval = false,
    this.removalDate,
  });

  factory StaffServiceLinkModel.fromJson(Map<String, dynamic> json) {
    return StaffServiceLinkModel(
      id: json['id'],
      name: json['name'],
      isPendingRemoval: json['is_pending_removal'] ?? false,
      removalDate: json['removal_date'] != null
          ? DateTime.parse(json['removal_date'])
          : null,
    );
  }
}
