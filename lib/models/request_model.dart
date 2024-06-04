import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ibron/models/favourite_model.dart';

import '../controller/home_page_controller.dart';

// Url Model
class Url {
  final String url;

  Url({required this.url});

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

// Amenities Model
class Amenity {
  final String id;
  final String name;
  final String url;
  final String createdAt;
  final String updatedAt;

  Amenity({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}

// Service Model
class Service {
  final String id;
  final String categoryId;
  final String businessMerchantId;
  final String name;
  final int duration;
  final int price;
  final String address;
  final double latitude;
  final double longitude;
  final List<Url> url;
  final List<Amenity> amenities;
  final String createdAt;

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
    required this.url,
    required this.amenities,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    var urlList = json['url'] as List? ?? [];
    List<Url> urlObjs = urlList.map((urlJson) => Url.fromJson(urlJson)).toList();

    var amenitiesList = json['amenities'] as List? ?? [];
    List<Amenity> amenitiesObjs = amenitiesList.map((amenitiesJson) => Amenity.fromJson(amenitiesJson)).toList();

    return Service(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      businessMerchantId: json['business_merchant_id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      price: json['price'] ?? 0,
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      url: urlObjs,
      amenities: amenitiesObjs,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'business_merchant_id': businessMerchantId,
      'name': name,
      'duration': duration,
      'price': price,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'url': url.map((u) => u.toJson()).toList(),
      'amenities': amenities.map((a) => a.toJson()).toList(),
      'created_at': createdAt,
    };
  }
}

// ServiceRequest Model
class ServiceRequest {
  final String id;
  final String serviceId;
  final String userId;
  final String clientId;
  final String userName;
  final String startTime;
  final String endTime;
  final int price;
  final String status;
  final String date;
  final String day;
  final Service service;
  final List<Url>? url;
  final String createdAt;
  final Service serviceDetail;

  ServiceRequest({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.clientId,
    required this.userName,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.date,
    required this.day,
    this.url,
    required this.createdAt,
    required this.service,
    required this.serviceDetail,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] ?? '',
      serviceId: json['service_id'] ?? '',
      userId: json['user_id'] ?? '',
      clientId: json['client_id'] ?? '',
      userName: json['user_name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      url: json['url'] != null ? List<Url>.from(json['url'].map((x) => Url.fromJson(x))) : null,
      createdAt: json['created_at'] ?? '',
      service: Service.fromJson(json['service'] ?? {}),
      serviceDetail: Service.fromJson(json['service_detail'] ?? {}),
    );
  }
}

// ServiceRequestData Model
class ServiceRequestData {
  final int count;
  final List<ServiceRequest> requests;

  ServiceRequestData({
    required this.count,
    required this.requests,
  });

  factory ServiceRequestData.fromJson(Map<String, dynamic> json) {
    List<ServiceRequest> serviceRequests = [];
    if (json['requests'] != null) {
      serviceRequests = List<ServiceRequest>.from(json['requests'].map((x) => ServiceRequest.fromJson(x)));
    }
    return ServiceRequestData(
      count: json['count'] ?? 0,
      requests: serviceRequests,
    );
  }
}

// ServiceRequestAPI Class
class ServiceRequestAPI {
  static const String baseUrl = 'https://ibron.onrender.com/ibron/api/v1';

  static Future<ServiceRequestData> fetchApprovedRequests(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/approved-requests?user_id=$userId'));

    if (response.statusCode == 200) {
      return ServiceRequestData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load service requests');
    }
  }
}
