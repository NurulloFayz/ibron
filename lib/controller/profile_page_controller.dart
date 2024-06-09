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
      final encodedPhoneNumber = Uri.encodeComponent('+998$phoneNumber');
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
  Future<List<Service>> getFavByUserId() async {
    try {
      final response = await http.get(
          Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorites?user_id=$id')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load services: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      // Ensure the 'services' key exists and is not null
      if (data['services'] == null) {
        return [];
      }

      List<Service?> services = List<Service?>.from(
          data['services'].map((x) => x == null ? null : Service.fromJson(x))
      );

      // Filter out null services
      List<Service> nonNullServices = services.where((service) => service != null).cast<Service>().toList();

      return nonNullServices;
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }
  Future<void> deleteFavCache(String userId, String serviceId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'favorite_$serviceId';
    bool result = await prefs.remove(key);

    if (result) {
      print('Favorite deleted successfully');
    } else {
      print('Failed to delete favorite');
      throw Exception('Failed to delete favorite');
    }
  }
  Future<void> deleteFavorite(String userId, String serviceId) async {
    final url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorite?user_id=$userId&service_id=$serviceId');

    final response = await http.delete(url);

    if (response.statusCode == 204) {
      // Successful deletion
      deleteFavCache(userId, serviceId);
      print('Favorite deleted successfully');
    } else {
      // Error handling
      print('Failed to delete favorite: ${response.reasonPhrase}');
      print('Failed to delete favorite: ${response.statusCode}');
      deleteFavCache(userId, serviceId);
      throw Exception('Failed to delete favorite ${response.statusCode} ${response.body}');

    }
  }
  deleteFavourite(BuildContext context,String userId,String serviceId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
            color: Colors.white
          ),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  deleteFavorite(userId, serviceId);
                },
                child: Text("O'chirish",style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500
                )),),
              )
            ],
          ),
        );
      }
    );
  }
}
