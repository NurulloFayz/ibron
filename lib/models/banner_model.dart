// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

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
  Service service;
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
    service: Service.fromJson(json["service"]),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "url": url,
    "service": service.toJson(),
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Service {
  String id;
  String categoryId;
  String businessMerchantId;
  String name;
  int duration;
  int price;
  String address;
  double latitude;
  double longitude;
  int distance;
  dynamic url;
  dynamic amenities;
  String createdAt;
  String updatedAt;

  Service({
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
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    categoryId: json["category_id"],
    businessMerchantId: json["business_merchant_id"],
    name: json["name"],
    duration: json["duration"],
    price: json["price"],
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    distance: json["distance"],
    url: json["url"],
    amenities: json["amenities"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "business_merchant_id": businessMerchantId,
    "name": name,
    "duration": duration,
    "price": price,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "distance": distance,
    "url": url,
    "amenities": amenities,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
