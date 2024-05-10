

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ibron/view/auth_pages/info_page.dart';

import '../view/auth_pages/otp_page.dart';

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
          "phone_number": number,
        })
    );
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.pushNamed(context, InfoPage.id);
    } else {
      print('Login failed: ${response.body}');
      return;
    }
  }
}