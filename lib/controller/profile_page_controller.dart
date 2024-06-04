import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ibron/view/auth_pages/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favourite_model.dart';
import '../models/user_model.dart';
import '../view/main_pages/profile_pages/edit_page.dart';

class ProfilePageController {
  void navigateToEditPage(BuildContext context) {
    Navigator.pushNamed(context, EditProfilePage.id);
  }
  String id = '';

  getUserid() async {
    var prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    print('user id is $id');
  }
  Future<User> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone_number');
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      try {
        final user = await fetchUserByPhoneNumber(phoneNumber);
        var prefs = await SharedPreferences.getInstance();
        id = prefs.getString('id') ?? '';
        print(user);
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
      final encodedPhoneNumber = Uri.encodeComponent('+998948850677');
      final response = await http.get(Uri.parse("https://ibron.onrender.com/ibron/api/v1/user/by-phone-number?phone_number=$encodedPhoneNumber"));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        var prefs = await SharedPreferences.getInstance();
        // Extract the user ID and save it
        String userId = userData['id'];
        prefs.setString('id', userId);
        print(response.body);
        print(userData);
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

  /// Deleting user
  Future<void> removeValue(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('phone_number');
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  void logout(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Chiqish',
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500)),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
          content: Text(
            'Chiqishni xohlaysizmi',
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50, fontWeight: FontWeight.w500, color: Colors.grey)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: screenHeight / 15,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Yo'q",
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 100),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      removeValue(context);
                    },
                    child: Container(
                      height: screenHeight / 15,
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Ha',
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50, fontWeight: FontWeight.w500, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
  Future<void> postFavorite(String serviceId, String userId) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorite');
    var data = {
      'serviceId': serviceId,
      'userId': userId,
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Favorite added successfully');
    } else {
      print('Failed to add favorite, HTTP status code: ${response.statusCode}');
      throw Exception('Failed to add favorite');
    }
  }
  Future<List<FavouriteModel>> getFavByUserId() async {
    try {
      final response = await http.get(Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorites?user_id=$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load services: ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body)['services'];

      List<FavouriteModel> services = data.map((json) => FavouriteModel.fromJson(json)).toList();

      return services;
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }

}
