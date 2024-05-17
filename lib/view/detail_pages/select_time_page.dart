import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectTimePage extends StatefulWidget {
  static const String id = 'selectTimePage';
  const SelectTimePage({super.key});

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Выберите дату и время',style: GoogleFonts.roboto(
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
