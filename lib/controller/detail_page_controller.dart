import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibron/models/favourite_model.dart';
import '../view/detail_pages/select_time_page.dart';

class DetailPageController {
  void pop(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToSelectTimePage(BuildContext context,String startTime,String endTime,String serviceId,String userId,
      String price
      ) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => SelectTimePage(
      startTime: startTime, endTime: endTime,serviceId: serviceId,
      userId: userId,price: price,
    )));
  }

  Future<List<FavouriteModel>> getServicesByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? '';

    if (userId.isEmpty) {
      throw Exception('User ID not found');
    }

    try {
      final response = await http.get(Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorite?user_id=$userId'));

      if (response.statusCode != 200) {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load services: ${response.statusCode}');
      }

      final responseBody = response.body;
      print('API response body: $responseBody');

      final decodedJson = jsonDecode(responseBody);

      if (decodedJson is! Map<String, dynamic>) {
        throw Exception('Invalid JSON structure');
      }

      if (!decodedJson.containsKey('services') || decodedJson['services'] is! List) {
        throw Exception('Invalid or missing "services" key in JSON');
      }

      final List<dynamic> data = decodedJson['services'];
      print('Type of data: ${data.runtimeType}');

      List<FavouriteModel> services = data.map((json) {
        if (json is Map<String, dynamic>) {
          return FavouriteModel.fromJson(json);
        } else {
          throw Exception('Invalid item in "services" list');
        }
      }).toList();

      return services;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load services: $e');
    }
  }
  ///
  ///
  ///


  Future<void> postFavorite(String serviceId, String userId) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorite');
    var data = {
      'service_id': serviceId,
      'user_id': userId,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      print('Favorite added successfully');
      print('Add to favourites >>>>>>>>>>>>>>> ${response.body}');
    } else if(response.statusCode == 400) {
      Fluttertoast.showToast(
        msg: "Saqlanganlarda mavjud",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 20,
      );
    }
    else {
      print('Failed to add favorite, HTTP status code: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to add favorite');
    }
  }


  // Future<void> registerUser(String serviceId, String userId) async {
  //   var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorite');
  //   var response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String,String> {
  //         '':
  //       })
  //   );
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(number)));
  //   } else {
  //     print('Login failed: ${response.body}');
  //     return;
  //   }
  // }
  Future<List<Map<String, dynamic>>> fetchScheduleData() async {
    final url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/schedules');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['schedule'];
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load schedule data');
      }
    } catch (e) {
      throw Exception('Failed to load schedule data: $e');
    }
  }

}
