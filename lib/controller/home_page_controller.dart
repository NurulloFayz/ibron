import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ibron/models/banner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/amenety.dart';
import '../view/main_pages/home_pages/notification_page.dart';

// lib/controller/home_page_controller.dart

class ServiceModel {
  final String name;
  final String thumbnail;
  final String id;
  final String address;
  final String description;
  final int price;
  final double distance;
  final double lat;
  final double long;
  final List<Url> urls;
  final List<Amenity> amenities;

  ServiceModel({
    required this.name,
    required this.thumbnail,
    required this.id,
    required this.address,
    required this.price,
    required this.distance,
    required this.lat,
    required this.long,
    required this.urls,
    required this.amenities,
    required this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json['name'] ?? '', // Provide default value if null
      id: json['id'] ?? '', // Provide default value if null
      address: json['address'] ?? '', // Provide default value if null
      price: json['price'] ?? 0, // Provide default value if null
      distance: (json['distance'] ?? 0).toDouble(),
      lat: (json['latitude'] ?? 0).toDouble(),
      long: (json['longitude'] ?? 0).toDouble(),
      urls: (json['url'] != null) ? List<Url>.from(json['url'].map((x) => Url.fromJson(x))) : [],
      amenities: (json['amenities'] != null) ? List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))) : [],
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ??'',
    );
  }
}

class LocationModel {
  final double lat;
  final double long;

  LocationModel({
    required this.lat,
    required this.long,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['latitude'] ?? 0).toDouble(),
      long: (json['longitude'] ?? 0).toDouble(),
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



String serviceId = '';

class HomePageController {
  Future<List<ServiceModel>> postData(double latitude, double longitude) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/closest-service');
    var data = {
      'latitude': latitude,
      'longitude': longitude,
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('service post method $responseData');
      List<ServiceModel> services = [];
      for (var item in responseData) {
        ServiceModel service = ServiceModel.fromJson(item);
        services.add(service);
      }
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('id', serviceId);
      print('the service values are $services');
      return services;
    } else {
      print('Failed to post data, HTTP status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  }

  void navigateToNotificationPage(BuildContext context) {
    Navigator.pushNamed(context, NotificationPage.id);
  }

  static Future<BannerModel> getBanner() async {
    final url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/banner');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final BannerModel bannerModel = BannerModel.fromJson(data);
        return bannerModel;
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load banners: $e');
    }
  }

  Future<List<LocationModel>> postLocations(double latitude, double longitude) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/closest-service');
    var data = {
      'latitude': latitude,
      'longitude': longitude,
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('service post method $responseData');
      List<LocationModel> services = [];
      for (var item in responseData) {
        LocationModel service = LocationModel.fromJson(item);
        LocationModel locationModel = LocationModel(lat: service.lat, long: service.long);
        services.add(locationModel);
      }
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('id', serviceId);
      print('the service values are $services');
      return services;
    } else {
      print('Failed to post data, HTTP status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  }
}
