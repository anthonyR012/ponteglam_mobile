import 'package:equatable/equatable.dart';

class CompanyModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? nequiNumber;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.nequiNumber,
  });

  factory CompanyModel.empty() {
    return const CompanyModel(
      id: 0,
      name: '',
      description: '',
      imageUrl: null,
      nequiNumber: null,
    );
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      nequiNumber: json['nequi_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'nequi_number': nequiNumber,
    };
  }

  CompanyModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? nequiNumber,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      nequiNumber: nequiNumber ?? this.nequiNumber,
    );
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl, nequiNumber];
}
