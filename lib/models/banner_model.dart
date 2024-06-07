import 'dart:convert';

import 'amenety.dart'; // Import the Amenity class from the correct file

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  int count;
  List<Banner> banners;

  BannerModel({
    required this.count,
    required this.banners,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    count: json["count"],
    banners: List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
  };
}

class Banner {
  String id;
  String serviceId;
  String url;
  Service? service;
  String createdAt;
  String updatedAt;

  Banner({
    required this.id,
    required this.serviceId,
    required this.url,
    required this.service,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    serviceId: json["service_id"],
    url: json["url"],
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "url": url,
    "service": service?.toJson(),
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Service {
  String id;
  String categoryId;
  String businessMerchantId;
  String name;
  String description;
  int duration;
  int price;
  List<Url> url;
  List<Amenity> amenities; // Use the imported Amenity class here
  String createdAt;

  Service({
    required this.id,
    required this.categoryId,
    required this.businessMerchantId,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.url,
    required this.amenities,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    categoryId: json["category_id"],
    businessMerchantId: json["business_merchant_id"],
    name: json["name"],
    description: json["description"],
    duration: json["duration"],
    price: json["price"],
    url: List<Url>.from(json["url"].map((x) => Url.fromJson(x))),
    amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "business_merchant_id": businessMerchantId,
    "name": name,
    "description": description,
    "duration": duration,
    "price": price,
    "url": List<dynamic>.from(url.map((x) => x.toJson())),
    "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
    "created_at": createdAt,
  };
}

class Url {
  String url;

  Url({
    required this.url,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
