

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/otp_page.dart';

class SignUpPageController {

  var phone = TextEditingController();
   String typedText = '';

  Future<void> registerUser(BuildContext context,String number) async {
    var url = Uri.parse('https://lms-back.nvrbckdown.uz/lms/api/v1/ib/registration');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String> {
          "phone_number": '+998${phone.text}',
        })
    );
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(number)));
    } else {
      print('Login failed: ${response.body}');
      return;
    }
  }
}