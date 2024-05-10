import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight / 15,),
            Row(
              children: [
                SizedBox(width: screenWidth / 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MyName',style: GoogleFonts.roboto(textStyle: TextStyle(
                        fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                    )),),
                    Text('Планируйте развлечения',style: GoogleFonts.roboto(textStyle: TextStyle(
                        fontSize: screenHeight / 45,fontWeight: FontWeight.w700
                    )),) ,
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {

                  },
                  child: Image.asset('assets/homePage_images/Frame 262.png',height: screenHeight / 25,),
                )
              ],
            ),
            SizedBox(height: screenHeight / 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth / 60,),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(right: screenWidth / 100,left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/free-icon-location-pin-4903621 1.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Поблизости',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(right: screenWidth / 100,left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/free-icon-time-and-calendar-8403154 1.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Выходные',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    margin: EdgeInsets.only(right: screenWidth / 120,left: screenWidth / 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/image 446.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Рекомендуем',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 60,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
