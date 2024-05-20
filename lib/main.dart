import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/info_page.dart';
import 'package:ibron/view/auth_pages/otp_page.dart';
import 'package:ibron/view/auth_pages/sign_up_page.dart';
import 'package:ibron/view/detail_pages/select_time_page.dart';
import 'package:ibron/view/main_pages/home_pages/home_page.dart';
import 'package:ibron/view/main_pages/home_pages/notification_page.dart';
import 'package:ibron/view/main_pages/main_pages.dart';
import 'package:ibron/view/main_pages/profile_pages/edit_page.dart';
import 'package:ibron/view/main_pages/profile_pages/language_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('phone_number');

  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final String? userId;

  const MyApp({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Check if userId is available
      home:
      userId != null && userId!.isNotEmpty ? const MainPages() :
      const SignUpPage(),
      routes: {
        MainPages.id: (context) => const MainPages(),
        SignUpPage.id: (context) => const SignUpPage(),
        InfoPage.id: (context) => const InfoPage(''),
        HomePage.id: (context) => const HomePage(),
        EditProfilePage.id: (context) => const EditProfilePage(),
        OtpPage.id: (context) => const OtpPage(''),
        SelectTimePage.id: (context) => const SelectTimePage(),
        NotificationPage.id: (context) => const NotificationPage(),
        LanguagePage.id: (context) => const LanguagePage(),
      },
    );
  }
}