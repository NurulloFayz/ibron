import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MyMapObject {
  final double latitude;
  final double longitude;

  MyMapObject({
    required this.latitude,
    required this.longitude,
  });

  factory MyMapObject.fromJson(Map<String, dynamic> json) {
    return MyMapObject(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class HomePageController {
  List<MyMapObject> mapObjects = [];

  Future<void> postData(double latitude, double longitude) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/closest-business');

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
      if (responseData != null && responseData is List && responseData.isNotEmpty) {
        for (var businessInfo in responseData) {
          mapObjects.add(MyMapObject.fromJson(businessInfo)); // Use MyMapObject instead of MapObject
        }
        print('Data posted successfully');
        print(mapObjects);
      } else {
        print('Response data is not in the expected format');
      }
    } else {
      print('Failed to post data, HTTP status code: ${response.statusCode}');
    }
  }
}
