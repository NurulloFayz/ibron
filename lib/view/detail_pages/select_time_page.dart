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

    // List of days in Uzbek
    final daysOfWeek = ['Bugun','Dushanba 1', 'Seshanba 2', 'Chorshanba 3', 'Payshanba 4', 'Juma 5', 'Shanba 6', 'Yakshanba 7'];

    return DefaultTabController(
      length: daysOfWeek.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Kun va Vaqtni tanlang',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: screenHeight / 40,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.green,
            labelStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w400,
            color: Colors.green
            )),
            isScrollable: true,
            padding: EdgeInsets.zero,
            tabs: daysOfWeek.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: daysOfWeek.map((day) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bo'sh joylar mavjud emas",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: screenHeight / 45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight / 100,),
                  Text(
                    "Boshqa kunni tanlang",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: screenHeight / 50,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.green,
          onPressed: () {

          },
          label: SizedBox(
            width: screenWidth * .8,
            child: Center(
              child: Text('Tasdiqlash',style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
              )),),
            ),
          ),
        ),
      ),
    );
  }
}
