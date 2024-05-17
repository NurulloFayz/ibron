import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  static const String id = '';
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Уведомления',style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: screenHeight / 40,
            fontWeight: FontWeight.w400,
          ),
        ),),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
