import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/request_model.dart';
import '../view/main_pages/qr_page.dart';

class RecordPageController {
  Future<String?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  Future<String> fetchUserID() async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        return userId;
      } else {
        throw Exception('User ID not available');
      }
    } catch (e) {
      throw Exception('Failed to fetch user ID');
    }
  }


  Future<ServiceRequest> fetchServiceRequestsByUserId(String userId) async {
    final Uri url = Uri.parse(
        'https://ibron.onrender.com/ibron/api/v1/approved-requests?user_id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return ServiceRequest.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load service requests');
    }
  }



  Future<void> fetchDataByUserId(BuildContext context) async {
    try {
      String? userId = await fetchUserID();
      if (userId != null) {
        ServiceRequest serviceRequest =
        await fetchServiceRequestsByUserId(userId);
        // Handle the fetched data
      } else {
        throw Exception('User ID not available');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, show error message, etc.
    }
  }

  Future<void> openQr(String id, BuildContext context) async {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    // Replace {id} with the actual ID
    // Replace the query parameters with actual values
    String requestId = 'e5ea669a-378a-4bfa-b62b-ddd43473bb89'; // Replace with your request ID
    double longitude = 69.301298; // Replace with your longitude
    double latitude = 41.333787; // Replace with your latitude

    // Construct the URL
    String url = 'https://ibron.onrender.com/ibron/api/v1/approve-request/$id?request_id=$requestId&longitude=$longitude&latitude=$latitude';

    // Make the GET request
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'accept': 'application/json',
      });

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        String responseBody = response.body; // Get the response body directly
        await prefs.setString('response', responseBody);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRDisplayPage(url: url),
          ),
        );
        print('Response: $responseBody');
      } else {
        final snackdemo = SnackBar(
          content: Text(
            'Sizning vaqtingiz boshlanmadi',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: screenHeight / 45,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.green,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      // If an error occurred during the request, print the error message
      print('Error: $error');
    }
  }


  bool firstButton = false;
  bool secondButton = false;
}
