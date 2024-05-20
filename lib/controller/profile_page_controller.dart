import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../view/main_pages/profile_pages/edit_page.dart';

class ProfilePageController {
  void navigateToEditPage(BuildContext context,) {
    Navigator.pushNamed(context, EditProfilePage.id);
  }

  Future<User> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone_number');
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
      final encodedPhoneNumber = Uri.encodeComponent('+998$phoneNumber');
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
  /// deleting user
  Future<void> deleteData(String id) async {
    // Construct the URL with the ID parameter
    final url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/user/$id');

    try {
      // Make the DELETE request
      final response = await http.delete(url);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Data with ID $id deleted successfully');
      } else {
        print('Failed to delete data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  logout(BuildContext context,) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chiqish',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w500 )),),
          backgroundColor: Colors.white,
          elevation: 5,
          content: Text(
              'Chiqshni xohlaysizmi',
              style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                  color: Colors.grey
              ))
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child:  Text("Yo'q",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500 ,
                          
                        ))),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 100,),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //deleteData(id);
                    },
                    child: Container(
                      height: screenHeight / 15,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text('Ha',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                        color: Colors.white
                        ))),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }
    );
  }
}
