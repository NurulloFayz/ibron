import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../view/mainPages/home_pages/notification_page.dart';

class ServiceModel {
  final String name;
  final String address;
  final int price;
  final double distance;
  final num lat;
  final num long;

  ServiceModel({
    required this.name,
    required this.address,
    required this.price,
    required this.distance,
    required this.lat,
    required this.long,
  });
}

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
      print(responseData);
      print(responseData);
      List<ServiceModel> services = [];
      for (var item in responseData) {
        ServiceModel service = ServiceModel(
          name: item['name'],
          address: item['address'],
          price: item['price'],
          distance: item['distance'],
          lat: item['latitude'],
          long: item['longitude']
        );
        services.add(service);
      }
      return services;
    } else {
      print('Failed to post data, HTTP status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  }

  void navigateToNotificationPage(BuildContext context) {
    Navigator.pushNamed(context, NotificationPage.id);
  }

}
