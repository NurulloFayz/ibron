import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_all_requests_model.dart'; // Import your model here

class RecordPageController {
  Future<String> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  Future<String> fetchUserID() async {
    try {
      return await getUserId();
    } catch (e) {
      throw Exception('Failed to fetch user ID');
    }
  }

  Future<ServiceRequestData> fetchServiceRequestsByUserId(String userId) async {
    final Uri url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/approved-requests?user_id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return ServiceRequestData.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load service requests');
    }
  }
}
