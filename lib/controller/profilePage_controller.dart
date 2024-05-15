import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../view/mainPages/profile_pages/edit_page.dart';

class ProfilePageController {
  void navigateToEditPage(BuildContext context,) {
    Navigator.pushNamed(context, EditProfilePage.id);
  }

  Future<User> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone');
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      try {
        final user = await fetchUserByPhoneNumber(phoneNumber);
        return user;
      } catch (e) {
        print('Error fetching user data: $e');
        throw Exception('Error fetching user data: $e');
      }
    } else {
      print('Phone number is empty');
      throw Exception('Phone number is empty');
    }
  }

  Future<User> fetchUserByPhoneNumber(String phoneNumber) async {
    try {
      final encodedPhoneNumber = Uri.encodeComponent(phoneNumber);
      final response = await http.get(Uri.parse("https://ibron.onrender.com/ibron/api/v1/user/by-phone-number?phone_number=$encodedPhoneNumber"));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        print(response.body);
        print(response.statusCode);
        print('Failed to fetch user data, HTTP status code: ${response.statusCode}');
        throw Exception('Failed to fetch user data, HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Error fetching user data: $e');
    }
  }

}
