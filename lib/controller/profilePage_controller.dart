import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../view/mainPages/profile_pages/edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageController {
  void navigateToEditPage(BuildContext context,String number) {
    Navigator.pushNamed(context, EditProfilePage.id);
  }

  Future<User> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    if (userId != null && userId.isNotEmpty) {
      try {
        final user = await fetchUserById(userId);
        return user;
      } catch (e) {
        print('no data at all');
        // Handle error gracefully
        print('Error fetching user data: $e');
        throw Exception('Error fetching user data: $e');
      }
    } else {
      // Handle case where userId is empty
      print('User ID is empty');
      throw Exception('User ID is empty');
    }
  }

  Future<User> fetchUserById(String userId) async {
    try {
      final response = await http.get(Uri.parse("https://ibron.onrender.com/ibron/api/v1/user/$userId"));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to fetch user data, HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching user data: $e');
    }
  }
}
