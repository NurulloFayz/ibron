// To parse this JSON data, do
//
//     final serviceRequest = serviceRequestFromJson(jsonString);

import 'dart:convert';

import 'package:ibron/models/amenety.dart';

ServiceRequest serviceRequestFromJson(String str) => ServiceRequest.fromJson(json.decode(str));

String serviceRequestToJson(ServiceRequest data) => json.encode(data.toJson());

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
  String merchantId;
  String clientId;
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

  Request({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.merchantId,
    required this.clientId,
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
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    serviceId: json["service_id"],
    userId: json["user_id"],
    merchantId: json["merchant_id"],
    clientId: json["client_id"],
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
    id: json["id"],
    categoryId: json["category_id"],
    businessMerchantId: json["business_merchant_id"],
    name: json["name"],
    description: json["description"],
    duration: json["duration"],
    price: json["price"],
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    url: List<Url>.from(json["url"].map((x) => Url.fromJson(x))),
    amenities: (json['amenities'] != null) ? List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))) : [],
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
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "url": List<dynamic>.from(url.map((x) => x.toJson())),
    "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
    "created_at": createdAt,
  };
}


enum CreatedAt {
  THE_07062024133649,
  THE_18052024140815,
  THE_18052024140837
}

final createdAtValues = EnumValues({
  "07/06/2024 13:36:49": CreatedAt.THE_07062024133649,
  "18/05/2024 14:08:15": CreatedAt.THE_18052024140815,
  "18/05/2024 14:08:37": CreatedAt.THE_18052024140837
});

enum Name {
  EMPTY,
  PARKOVKA
}

final nameValues = EnumValues({
  "Раздевалка": Name.EMPTY,
  "Parkovka": Name.PARKOVKA
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
