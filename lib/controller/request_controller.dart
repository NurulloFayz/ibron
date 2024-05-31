import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  List<String> requestIds = []; // List to store multiple request IDs

  Future<List<FreeTime>> fetchFreeTimes(String serviceId, String date) async {
    final Uri uri = Uri.parse(
        'https://ibron.onrender.com/ibron/api/v1/requests/free-times');
    final Map<String, String> queryParameters = {
      'service_id': serviceId,
      'date': date,
    };

    final response = await http.get(
        uri.replace(queryParameters: queryParameters));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response contains 'free_times' key
      if (jsonResponse.containsKey('free_times')) {
        // Extract the 'free_times' list from the response
        final List<dynamic> freeTimesJson = jsonResponse['free_times'];

        // Map each JSON object in the 'free_times' list to a FreeTime object
        List<FreeTime> freeTimes = freeTimesJson.map((json) =>
            FreeTime.fromJson(json)).toList();
        return freeTimes;
      } else {
        throw Exception('Unexpected response format: $jsonResponse');
      }
    } else {
      throw Exception(
          'Failed to fetch free times. Status code: ${response.statusCode}');
    }
  }

  // Future<void> postRequest(Map<String, dynamic> requestData) async {
  //   final Uri uri = Uri.parse('https://ibron.onrender.com/ibron/api/v1/request');
  //
  //   final response = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(requestData),
  //   );
  //
  //   if (response.statusCode == 201) {
  //     print('broned >>>>> ${response.statusCode}');
  //
  //     // Assuming 'id' is part of the response body
  //     final dynamic jsonResponse = jsonDecode(response.body);
  //     if (jsonResponse.containsKey('id')) {
  //       String requestId = jsonResponse['id'];
  //       requestIds.add(requestId); // Add the new request ID to the list
  //       print('id is saved $requestId');
  //     } else {
  //       print('response does not contain request_id');
  //     }
  //   } else {
  //     print('error ${response.statusCode}');
  //   }
  // }

  Future<Map<String, dynamic>> fetchRequestById(String requestId) async {
    final Uri uri = Uri.parse(
        'https://ibron.onrender.com/ibron/api/v1/request/$requestId');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch request. Status code: ${response.statusCode}');
    }
  }

  Future<void> postRequest(Map<String, dynamic> requestData) async {
    final Uri uri = Uri.parse(
        'https://ibron.onrender.com/ibron/api/v1/request');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      print('broned >>>>> ${response.statusCode}');

      // Assuming 'id' is part of the response body
      final dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('id')) {
        String requestId = jsonResponse['id'];
        var prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'id', requestId); // Save the request ID to shared preferences
        print('id is saved $requestId');
      } else {
        print('response does not contain request_id');
      }
    } else {
      print('error ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> fetchSavedRequest() async {
    var prefs = await SharedPreferences.getInstance();
    String? requestId = prefs.getString('id');
    if (requestId != null) {
      return fetchRequestById(requestId);
    }
    return null;
  }
}
class FreeTime {
  final String startTime;
  final String endTime;
  final bool status;

  FreeTime({
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory FreeTime.fromJson(Map<String, dynamic> json) {
    return FreeTime(
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
    );
  }
}

Future<List<String>> fetchAllRequestIds() async {
  final Uri uri = Uri.parse('https://ibron.onrender.com/ibron/api/v1/requests');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse.containsKey('id') && jsonResponse['id'] != null) {
      final List<dynamic> requestIdsJson = jsonResponse['id'];
      List<String> requestIds = requestIdsJson.map((id) => id.toString()).toList();
      return requestIds;
    } else {
      throw Exception('Response does not contain request_ids or request_ids is null: $jsonResponse');
    }
  } else {
    throw Exception('Failed to fetch request IDs. Status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> fetchRequestById(String requestId) async {
  final Uri uri = Uri.parse('https://ibron.onrender.com/ibron/api/v1/request/$requestId');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch request. Status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> fetchSavedRequest() async {
  var prefs = await SharedPreferences.getInstance();
  String? requestId = prefs.getString('id');
  if (requestId != null) {
    return fetchRequestById(requestId);
  }
  return null;
}

Future<List<Map<String, dynamic>>> fetchAllRequests() async {
  final List<String> requestIds = await fetchAllRequestIds();
  final List<Map<String, dynamic>> requests = [];
  for (String id in requestIds) {
    final request = await fetchRequestById(id);
    requests.add(request);
  }
  return requests;
}