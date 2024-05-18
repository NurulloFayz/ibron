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
        backgroundColor: Colors.white,
        elevation: 2.5,
        shadowColor: Colors.grey.withOpacity(0.2),
        centerTitle: true,
        title: Text('Eslatmalar',style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: screenHeight / 40,
            fontWeight: FontWeight.w500,
          ),
        ),),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight / 40,),
          Row(
            children: [
              SizedBox(width: screenWidth / 30,),
              Text('Дилором Алиева отменила заказ😔',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,fontWeight: FontWeight.w500
              )),),
            ],
          ),
          SizedBox(height: screenHeight / 70,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: screenHeight / 12,
                  child: const VerticalDivider(thickness: 6,color: Colors.red,),
                ),
              ),
              Expanded(
                flex: 9,
                child: Text('Заявка на бронирование услуги "укладка" в (2 декабря 16:00) отменено. ',maxLines: null,
                  style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                  fontWeight: FontWeight.w500
                  )),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight / 70,),
          Row(
            children: [
              SizedBox(width: screenWidth / 15,),
              Text('Сегодня в 9:42',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 50,color: Colors.grey
              )),)
            ],
          ),
          SizedBox(height: screenHeight / 70,),
          Divider(color: Colors.grey.withOpacity(0.3),thickness: 1,),
          SizedBox(height: screenHeight / 70,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: screenHeight / 12,
                  child: const VerticalDivider(thickness: 6,color: Colors.red,),
                ),
              ),
              Expanded(
                flex: 9,
                child: Text('Заявка на бронирование услуги "укладка" в (2 декабря 16:00) отменено. ',maxLines: null,
                  style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                      fontWeight: FontWeight.w500
                  )),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight / 70,),
          Row(
            children: [
              SizedBox(width: screenWidth / 15,),
              Text('Сегодня в 9:42',style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: screenHeight / 50,color: Colors.grey
              )),)
            ],
          ),
          SizedBox(height: screenHeight / 70,),
          Divider(color: Colors.grey.withOpacity(0.3),thickness: 1,),
        ],
      ),
    );
  }
}
