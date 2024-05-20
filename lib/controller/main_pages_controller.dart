

import 'package:flutter/cupertino.dart';

class MainPagesController extends ChangeNotifier{
  late PageController controller;
  int selected = 0;
}
// Future<void> updateUserInfo(BuildContext context, String id,) async {
//   if (pickedImage == null) {
//     print('No image selected.');
//     return;
//   }
//
//   var url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/user/$id');
//
//   // Read the image bytes from the file
//   List<int> imageBytes = await pickedImage!.readAsBytes();
//
//   // Encode the image bytes to base64
//   String base64Image = base64Encode(imageBytes);
//
//   var response = await http.put(
//     url,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, dynamic>{
//       "birthday": birthday.text,
//       "first_name": firstname.text,
//       "gender": gender, // Use selected gender here
//       "last_name": lastname.text,
//       "phone_number": phone.text,
//       "image": base64Image, // Include base64 image data in the request
//     }),
//   );
//   if (response.statusCode == 200) {
//     print('response code <<< ${response.statusCode} >>>');
//     print(response.body);
//     // Handle successful update, maybe show a success message to user
//   } else {
//     print(response.statusCode);
//     print('Updating user info failed: ${response.body}');
//     // Handle error here, show error message to user
//     // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user info')));
//   }
// }