import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/signUp_page.dart';
import 'package:ibron/view/mainPages/main_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class InfoPageController {
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  String? gender;
  String id ='';
  DateTime? birthday;

  Future<void> addUserInfo(BuildContext context, String phoneNumber) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/user');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "birthday": birthday != null ? DateFormat('yyyy-MM-dd').format(birthday!) : null,
        "first_name": firstname.text,
        "gender": gender,
        "last_name": lastname.text,
        "phone_number": '+998$phoneNumber',
      }),
    );
    if (response.statusCode == 201) {
      print(response.body);
      print(response.statusCode);
      var responseData = jsonDecode(response.body);
      var userId = responseData['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone_number', phoneNumber);
      print('phone saved $phoneNumber');
      prefs.setString('id', userId);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainPages()), (route) => false);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phoneNumber);
      print(response.body);
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error'),
          backgroundColor: Colors.red,
        ),
      );
      print('<<<${response.statusCode}');
      print('Adding user info failed: ${response.body}');
    }
  }
}
