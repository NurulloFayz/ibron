class FavouriteModel {
  final String name;
  final String id;
  final String address;
  final int price;
  final double distance;
  final double lat;
  final double long;
  final List<Url> urls;
  final List<Amenity> amenities;

  FavouriteModel({
    required this.name,
    required this.id,
    required this.address,
    required this.price,
    required this.distance,
    required this.lat,
    required this.long,
    required this.urls,
    required this.amenities,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      name: json['name'] ?? '', // Provide default value if null
      id: json['id'] ?? '', // Provide default value if null
      address: json['address'] ?? '', // Provide default value if null
      price: json['price'] ?? 0, // Provide default value if null
      distance: (json['distance'] ?? 0).toDouble(),
      lat: (json['latitude'] ?? 0).toDouble(),
      long: (json['longitude'] ?? 0).toDouble(),
      urls: (json['url'] != null) ? List<Url>.from(json['url'].map((x) => Url.fromJson(x))) : [],
      amenities: (json['amenities'] != null) ? List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))) : [],
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

  @override
  String toString() {
    return name;
  }
}

class Response {
  final int count;
  final List<FavouriteModel> services;

  Response({required this.count, required this.services});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      count: json['count'],
      services: List<FavouriteModel>.from(json['services'].map((x) => FavouriteModel.fromJson(x))),
    );
  }
}
