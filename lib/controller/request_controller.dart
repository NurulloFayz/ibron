import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<FreeTime>> fetchFreeTimes(String serviceId, String date) async {
    final Uri uri = Uri.parse('https://ibron.onrender.com/ibron/api/v1/requests/free-times');
    final Map<String, String> queryParameters = {
      'service_id': serviceId,
      'date': date,
    };

    final response = await http.get(uri.replace(queryParameters: queryParameters));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response contains 'free_times' key
      if (jsonResponse.containsKey('free_times')) {
        // Extract the 'free_times' list from the response
        final List<dynamic> freeTimesJson = jsonResponse['free_times'];

        // Map each JSON object in the 'free_times' list to a FreeTime object
        List<FreeTime> freeTimes = freeTimesJson.map((json) => FreeTime.fromJson(json)).toList();
        return freeTimes;
      } else {
        throw Exception('Unexpected response format: $jsonResponse');
      }
    } else {
      throw Exception('Failed to fetch free times. Status code: ${response.statusCode}');
    }
  }
  Future<void> postRequest(Map<String, dynamic> requestData) async {
    final Uri uri = Uri.parse('https://ibron.onrender.com/ibron/api/v1/request');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create request. Status code: ${response.statusCode}');
    }
  }
}

class FreeTime {
  late String startTime;
  late String endTime;

  FreeTime({
    required this.startTime,
    required this.endTime,
  });

  factory FreeTime.fromJson(Map<String, dynamic> json) {
    return FreeTime(
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
