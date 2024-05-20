
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class EditPageController {

  var birthday = TextEditingController();
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var phone = TextEditingController();
  String? gender;

  Future<void> uploadImage(File imageFile) async {
    var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/upload');
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'webp'),
      ),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print(response.statusCode);
        print('Response: $responseData');

        if (responseData is Map && responseData.containsKey('url')) {
          var imageUrl = responseData['url'] as String;
          print('Response URL: $imageUrl');
          print('Image uploaded successfully.');
          // Handle success
        } else {
          print('Invalid response format: Missing or invalid URL');
          // Handle invalid response
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        // Handle failure
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }
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
  }}
