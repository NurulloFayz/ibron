import 'dart:convert';

import '../models/request_model.dart';
import 'package:http/http.dart' as http;
class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Request?> fetchRequests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ibron/api/v1/requests'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Request.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch requests');
      }
    } catch (e) {
      print('Error fetching requests: $e');
      rethrow; // Rethrow the exception to handle it in the calling code
    }
  }
}
