import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibron/view/mainPages/main_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InfoPageController {
  var birthday = TextEditingController();
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  String? gender;

  Future<void> addUserInfo(BuildContext context, String phoneNumber) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/user');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "birthday": birthday.text,
        "first_name": firstname.text,
        "gender": gender, // Use selected gender here
        "last_name": lastname.text,
        "phone_number": phoneNumber,
      }),
    );
    if (response.statusCode == 201) {
      print(response.body);
      print(response.statusCode);
      // Save the phone number to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phoneNumber);

      // Navigate to the main pages
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainPages()), (route) => false);
    } else {
      print(response.statusCode);
      print('Adding user info failed: ${response.body}');
      // Handle error here, show error message to user
      // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user info')));
    }
  }
}
