

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ibron/view/auth_pages/info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/main_pages/main_pages.dart';

class OtpPageController extends ChangeNotifier {
  String typedText = '';
  var verifyCode = TextEditingController();
  var number = TextEditingController();
  int decrement = 120;
  int get minutes => decrement ~/ 60;
  int get seconds => decrement % 60;
  late Timer timer;

  void countDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (decrement > 0) {
        decrement--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }
  void navigateToInfoPage(BuildContext context) {
    Navigator.pushNamed(context, InfoPage.id);
  }
  Future<void> verifyUser(BuildContext context,String number) async {
    var url = Uri.parse('https://lms-back.nvrbckdown.uz/lms/api/v1/ib/verification');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String> {
          "code": verifyCode.text,
          "phone_number": '+998$number',
        })
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(number)));
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('phone_number', number);
      prefs.setString('id', number);
      print('OTP response ${response.body}');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainPages()), (route) => false);
    } else if(response.statusCode == 400){
      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(number)));
      print('need to sign up: ${response.body}');
      return;
    } else {
      print('login failed ${response.statusCode}');
    }
  }
}