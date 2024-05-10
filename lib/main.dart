import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/info_page.dart';
import 'package:ibron/view/auth_pages/signUp_page.dart';
import 'package:ibron/view/mainPages/home_page.dart';
import 'package:ibron/view/mainPages/main_pages.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUpPage(),
      routes: {
        MainPages.id:(context) => const MainPages(),
        SignUpPage.id:(context) => const SignUpPage(),
        InfoPage.id:(context) => const InfoPage(),
        HomePage.id:(context) => const HomePage(),
      },
    );
  }
}
