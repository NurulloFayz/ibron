import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatefulWidget {
  static const String id = 'infoPage';
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight / 40,),
            ListTile(
              title: Text(
                'Введите свои данные',
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: screenHeight / 28,
                        fontWeight: FontWeight.w700
                    )
                ),
              ),
            ),
            SizedBox(height: screenHeight / 30,),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text('Имя',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Введите имя',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                        fontWeight: FontWeight.w400
                    )),
                    contentPadding: EdgeInsets.all(screenHeight / 60),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            SizedBox(height: screenHeight / 50,),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text('Фамилия',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Введите фамилию',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                        fontWeight: FontWeight.w400
                    )),
                    contentPadding: EdgeInsets.all(screenHeight / 60),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            SizedBox(height: screenHeight / 50,),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text('Дата рождения',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Выберите дата рождения ',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                        fontWeight: FontWeight.w400
                    )),
                    contentPadding: EdgeInsets.all(screenHeight / 60),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    suffixIcon: IconButton(
                      onPressed: () {
                      },
                      icon: const Icon(Icons.calendar_month,color: Colors.grey,),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            SizedBox(height: screenHeight / 40,),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text("Пол",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
              ],
            ),
            SizedBox(height: screenHeight / 70,),
            Row(
              children: [
        
                IconButton(
                  onPressed: () {
        
                  },
                  icon: const Icon(Icons.radio_button_unchecked),
                ),
                Text('Мужчина',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400
                )),)
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
        
                  },
                  icon: const Icon(Icons.radio_button_unchecked),
                ),
                Text('Женщина',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                    fontWeight: FontWeight.w400
                )),)
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.blue,
        onPressed: () {

        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Продолжить',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
