import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguagePage extends StatefulWidget {
  static const String id = 'languagePage';
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool firstButton =  false;
  bool secondButton =  false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstButton = true;
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        shadowColor: Colors.grey.withOpacity(0.3),
        centerTitle: true,
        title: Text(
          'Til',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: Center(
        child:Column(
          children: [
            SizedBox(height: screenHeight / 40,),
            ListTile(
              onTap: () {
                setState(() {
                  firstButton = true;
                  secondButton = false;
                });
              },
              trailing: !firstButton ?  null : const Icon(Icons.done,color: Colors.green,) ,
              title: Text('Русский',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  secondButton = true;
                  firstButton = false;
                });
              },
              trailing: !secondButton ?  null : const Icon(Icons.done,color: Colors.green,),
              title: Text("O'zbekcha",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
            ),
          ],
        ),
      ),
    );
  }
}
