class FavouriteModel {
  final String id;
  final String categoryId;
  final String businessMerchantId;
  final String name;
  final int duration;
  final int price;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final List<Url> url;
  final List<Amenity> amenities;
  final String createdAt;
  final String? updatedAt;

  FavouriteModel({
    required this.id,
    required this.categoryId,
    required this.businessMerchantId,
    required this.name,
    required this.duration,
    required this.price,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.url,
    required this.amenities,
    required this.createdAt,
    this.updatedAt,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      id: json['id'],
      categoryId: json['category_id'],
      businessMerchantId: json['business_merchant_id'],
      name: json['name'],
      duration: json['duration'],
      price: json['price'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: (json['distance'] ?? 0).toDouble(),
      url: (json['url'] as List).map((i) => Url.fromJson(i)).toList(),
      amenities: (json['amenities'] as List).map((i) => Amenity.fromJson(i)).toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Url {
  final String url;

  Url({required this.url});

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      url: json['url'],
    );
  }
}

class Amenity {
  final String id;
  final String name;
  final String url;
  final String createdAt;
  final String? updatedAt;

  Amenity({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    this.updatedAt,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
