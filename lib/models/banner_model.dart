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
  dynamic service;
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
    service: json["service"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "url": url,
    "service": service,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
