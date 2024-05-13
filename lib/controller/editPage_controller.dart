import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibron/view/mainPages/main_pages.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPageController {
  void openGallery() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  }
  var birthday = TextEditingController();
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var phone = TextEditingController();
  String? gender;


  Future<void> updateUserInfo(BuildContext context, String id,) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/user/$id');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "birthday": birthday.text,
        "first_name": firstname.text,
        "gender": gender, // Use selected gender here
        "last_name": lastname.text,
        "phone_number": phone.text,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      // Handle successful update, maybe show a success message to user
    } else {
      print(response.statusCode);
      print('Updating user info failed: ${response.body}');
      // Handle error here, show error message to user
      // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user info')));
    }
  }
}
