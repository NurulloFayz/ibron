import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final List<URL>? url;
  final String createdAt;

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
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      serviceId: json['service_id'],
      userId: json['user_id'],
      clientId: json['client_id'],
      userName: json['user_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      price: json['price'],
      status: json['status'],
      date: json['date'],
      day: json['day'],
      url: json['url'] != null ? List<URL>.from(json['url'].map((x) => URL.fromJson(x))) : null,
      createdAt: json['created_at'],
    );
  }
}

class URL {
  final String? url;

  URL({this.url});

  factory URL.fromJson(Map<String, dynamic> json) {
    return URL(
      url: json['url'],
    );
  }
}

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
      count: json['count'],
      requests: serviceRequests,
    );
  }
}

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
