


import 'package:shared_preferences/shared_preferences.dart';

class GetUserId {


  Future getId(String userId) async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ??'';
    return userId;
  }
}