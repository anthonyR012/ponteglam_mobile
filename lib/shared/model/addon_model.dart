class AddonModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int durationMinutes;

  AddonModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.durationMinutes,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else {
        parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
      }
    }
    return AddonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: parsedPrice,
      durationMinutes: json['duration_minutes'] as int? ?? 10,
    );
  }

  bool get isFree => price == 0;
}
