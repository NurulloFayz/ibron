import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class HomePageController {
  Future<void> postData(double latitude, double longitude) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/closest-business');

    // Create a JSON object with latitude and longitude
    var data = {
      'latitude': latitude,
      'longitude': longitude,
    };

    // Encode the JSON object as a string
    var body = jsonEncode(data);

    // Make the POST request
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Decode the response body
      var responseData = jsonDecode(response.body);

      // Assuming responseData is a list and contains only one element
      if (responseData != null && responseData is List && responseData.isNotEmpty) {
        var businessInfo = responseData[0];

        // Extract data from the response
        var businessName = businessInfo['business_name'];
        var description = businessInfo['description'];
        var address = businessInfo['address'];
        var phone1 = businessInfo['phone_1'];
        var phone2 = businessInfo['phone_2'];
        var distance = businessInfo['distance'];

        // Save data to SharedPreferences
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('business_name', businessName);
        prefs.setString('description', description);
        prefs.setString('address', address);
        prefs.setString('phone_1', phone1);
        prefs.setString('phone_2', phone2);
        prefs.setDouble('distance', distance);

        print('Data posted successfully');
      } else {
        print('Response data is not in the expected format');
      }
    } else {
      // Failed POST request
      print('Failed to post data, HTTP status code: ${response.statusCode}');
    }
  }
}
