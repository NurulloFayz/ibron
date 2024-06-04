import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ibron/view/auth_pages/info_page.dart';
import 'package:ibron/view/auth_pages/otp_page.dart';
import 'package:ibron/view/auth_pages/sign_up_page.dart';
import 'package:ibron/view/detail_pages/order_page.dart';
import 'package:ibron/view/main_pages/home_pages/home_page.dart';
import 'package:ibron/view/main_pages/home_pages/notification_page.dart';
import 'package:ibron/view/main_pages/main_pages.dart';
import 'package:ibron/view/main_pages/profile_pages/edit_page.dart';
import 'package:ibron/view/main_pages/profile_pages/language_page.dart';
import 'package:ibron/view/main_pages/profile_pages/saved_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool shouldUseFirebaseEmulator = false;
late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? phoneNumber = prefs.getString('phone_number');

  print('userId in main dart >>>>>>>>>> $phoneNumber');
  app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBynPVoOqIB52TqNKPV8i29dyOa-FQN01A',
        appId: '1:48103744420:android:e0daf73f5fc4244ca75731',
        projectId: 'ibronapp',
        messagingSenderId: '48103744420',
      )
    // DefaultFirebaseOptions.currentPlatform can be used if the above code doesn't work
  );

  auth = FirebaseAuth.instanceFor(app: app);

  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }

  runApp(MyApp(phoneNumber: phoneNumber,));
}

class MyApp extends StatelessWidget {
  final String? phoneNumber;
  final String? id;

  const MyApp({super.key, this.phoneNumber, this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const MainPages(),
      //phoneNumber != null && phoneNumber!.isNotEmpty ? const MainPages() : const SignUpPage(),
      routes: {
        MainPages.id: (context) => const MainPages(),
        SignUpPage.id: (context) => const SignUpPage(),
        InfoPage.id: (context) => const InfoPage(''),
        HomePage.id: (context) => const HomePage(),
        EditProfilePage.id: (context) => const EditProfilePage(),
        OtpPage.id: (context) => const OtpPage(''),
        NotificationPage.id: (context) => const NotificationPage(),
        LanguagePage.id: (context) => const LanguagePage(),
        SavedPage.id: (context) => SavedPage(),
      },
    );
  }
}
