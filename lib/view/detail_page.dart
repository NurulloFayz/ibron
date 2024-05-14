import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  static const String id = 'detailPage';
  final String description;
  final String address;

  const DetailPage({
    Key? key,
    required this.description,
    required this.address,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight / 3.4,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.grey], // Example colors
              ),
            ),
            child: Stack(
              children: [
                Image.asset('assets/homePage_images/fotball.jpg', fit: BoxFit.cover,width: screenWidth,),
                Positioned(
                  top: screenHeight / 30,
                  left: screenWidth / 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when the back button is pressed
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: screenHeight / 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight / 30,),
          Row(
            children: [
              SizedBox(width: screenWidth / 40,),
              Text('(${widget.address} от вас)',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
            ],
          ),
          SizedBox(height: screenHeight / 30,),
          Container(
            height: screenHeight / 10,
            width: screenWidth / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2)
            ),
          ),
          ListTile(
            title: Text('Описание',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,
            fontWeight: FontWeight.w400
            )),),
          ),
          Container(
            margin: EdgeInsets.only(right: screenWidth / 20,left: screenWidth / 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.description,style: GoogleFonts.roboto(textStyle:TextStyle(
                  fontSize: screenHeight / 45,fontWeight: FontWeight.w400
                )),),
              ],
            ),
          ),
          SizedBox(height: screenHeight / 40,),
          ListTile(
            title: Text('Расположение',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,
                fontWeight: FontWeight.w400
            )),),
          ),
        ],
      ),
    );
  }
}
