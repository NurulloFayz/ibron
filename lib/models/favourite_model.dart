

import 'package:ibron/models/amenety.dart';

class FavouriteModel {
  int count;
  List<Service?> services;

  FavouriteModel({
    required this.count,
    required this.services,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      count: json["count"],
      services: json["services"] == null
          ? []
          : List<Service?>.from(json["services"].map((x) => x == null ? null : Service.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "count": count,
    "services": List<dynamic>.from(services.map((x) => x?.toJson())),
  };
}

class Service {
  final String id;
  final String name;
  final String description;
  final int duration;
  final int price;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> urls;
  final List<Amenity> amenities;
  final String createdAt;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.urls,
    required this.amenities,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      duration: json['duration'],
      price: json['price'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      urls: json['url'] == null ? [] : List<String>.from(json['url'].map((x) => x['url'])),
      amenities: json['amenities'] == null ? [] : List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))),
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'duration': duration,
    'price': price,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'url': List<dynamic>.from(urls.map((x) => {'url': x})),
    'amenities': List<dynamic>.from(amenities.map((x) => x.toJson())),
    'created_at': createdAt,
  };
}

