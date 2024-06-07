// lib/models/request_model.dart
import 'dart:convert';
import 'amenety.dart';
class ServiceRequest {
  int count;
  List<Request> requests;

  ServiceRequest({
    required this.count,
    required this.requests,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) => ServiceRequest(
    count: json["count"],
    requests: List<Request>.from(json["requests"].map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class Request {
  String id;
  String serviceId;
  String userId;
  String? merchantId; // Make merchantId nullable
  String? clientId;   // Make clientId nullable
  String userName;
  String startTime;
  String endTime;
  int price;
  String status;
  DateTime date;
  String day;
  Service service;
  int duration;
  String createdAt;
  String updatedAt;

  Request({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.userName,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.date,
    required this.day,
    required this.service,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.merchantId, // Update constructor accordingly
    this.clientId,   // Update constructor accordingly
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    serviceId: json["service_id"],
    userId: json["user_id"],
    merchantId: json["merchant_id"], // Add null check
    clientId: json["client_id"],     // Add null check
    userName: json["user_name"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    price: json["price"],
    status: json["status"],
    date: DateTime.parse(json["date"]),
    day: json["day"],
    service: Service.fromJson(json["service"]),
    duration: json["duration"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "user_id": userId,
    "merchant_id": merchantId,
    "client_id": clientId,
    "user_name": userName,
    "start_time": startTime,
    "end_time": endTime,
    "price": price,
    "status": status,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "day": day,
    "service": service.toJson(),
    "duration": duration,
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
  String address;
  double latitude;
  double longitude;
  List<Url> url;
  List<Amenity> amenities;
  String createdAt;

  Service({
    required this.id,
    required this.categoryId,
    required this.businessMerchantId,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.url,
    required this.amenities,
    required this.createdAt,
  });
  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"] ?? '',
    categoryId: json["category_id"] ?? '',
    businessMerchantId: json["business_merchant_id"] ??'',
    name: json["name"]??'',
    description: json["description"]??'',
    duration: json["duration"] ?? 0,
    price: json["price"] ?? 0,
    address: json["address"]??'',
    latitude: json["latitude"] ?? 0.0, // Use ?? to provide a default value if null
    longitude: json["longitude"] ?? 0.0, // Use ?? to provide a default value if null
    url: List<Url>.from(json["url"].map((x) => Url.fromJson(x))),
    amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
    createdAt: json["created_at"]??'',
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "business_merchant_id": businessMerchantId,
    "name": name,
    "description": description,
    "duration": duration,
    "price": price,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
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
