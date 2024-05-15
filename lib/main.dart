import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/info_page.dart';
import 'package:ibron/view/auth_pages/otp_page.dart';
import 'package:ibron/view/auth_pages/signUp_page.dart';
import 'package:ibron/view/detail_page.dart';
import 'package:ibron/view/mainPages/home_page.dart';
import 'package:ibron/view/mainPages/main_pages.dart';
import 'package:ibron/view/mainPages/profile_pages/edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('phone');

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
      home: userId != null && userId!.isNotEmpty ? const MainPages() : const SignUpPage(),
      routes: {
        MainPages.id: (context) => const MainPages(),
        SignUpPage.id: (context) => const SignUpPage(),
        DetailPage.id: (context) => const DetailPage( description: '', distanceMile: '',address: '', mapObjects: [],),
        InfoPage.id: (context) => const InfoPage(''),
        HomePage.id: (context) => const HomePage(),
        EditProfilePage.id: (context) => const EditProfilePage(),
        OtpPage.id: (context) => const OtpPage(''),
      },
    );
  }
}