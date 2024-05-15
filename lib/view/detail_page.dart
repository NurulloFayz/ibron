import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class DetailPage extends StatefulWidget {
  static const String id = 'detailPage';
  final String description;
  final String distanceMile;
  final String address;
  final List<MapObject> mapObjects; // Add this line

  const DetailPage({
    Key? key,
    required this.description,
    required this.distanceMile,
    required this.address,
    required this.mapObjects, // Add this line
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Image.asset(
                      'assets/homePage_images/fotball.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 10,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 1.4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 1.2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text('Футбольная поля',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: screenWidth / 40),
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 30, left: screenWidth / 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.address,
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '(${widget.distanceMile} от вас)',
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight / 40),
            Container(
              height: screenHeight / 10,
              width: screenWidth / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Row(

                children: [
                  SizedBox(width: screenWidth / 40,),
                  Icon(Icons.access_time_rounded,color: Colors.green,),
                  const Spacer(),
                  const Icon(Icons.navigate_next,color: Colors.grey,),
                  SizedBox(width: screenWidth / 20,)
                ],
              ),
            ),
            SizedBox(height: screenHeight / 40),
            ListTile(
              title: Text('Описание',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 20, left: screenWidth / 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.description,
                  maxLines: null,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight / 70,),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              endIndent: screenWidth / 20,
              indent: screenWidth / 20,
            ),
            SizedBox(height: screenHeight / 70,),
            ListTile(
              title: Text('Расположение',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              height: screenHeight / 2.5,
              width: screenWidth / 1.1,
              decoration:BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,3),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Colors.grey.withOpacity(0.2)
                  )
                ]
              ),
              child: Stack(
                children: [
                  YandexMap(
                    onMapCreated: (controller) {
                      // You can perform any map-related actions here
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: screenHeight / 8,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight / 100,),
                          Container(
                            margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.address,
                                maxLines: null,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: screenHeight / 50,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight / 80,),
                          Row(
                            children: [
                              SizedBox(width: screenWidth / 40,),
                              Icon(Icons.navigation_outlined,color: Colors.grey,),
                              SizedBox(width: screenWidth / 40,),
                              Text(
                                '${widget.distanceMile} км от вас',
                                maxLines: null,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            SizedBox(height: screenHeight / 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth / 20,),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: screenHeight / 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call_outlined,color: Colors.green,),
                          SizedBox(width: screenWidth / 30,),
                          Text('Позвонить',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w400
                          )),)
                        ],
                      )
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: screenHeight / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2)
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/detailPage/instagram (2).png',height: screenHeight / 28,),
                        SizedBox(width: screenWidth / 20,),
                        Icon(Icons.telegram,color: Colors.blue,size: screenHeight / 28,),
                        SizedBox(width: screenWidth / 30,),
                      ],
                    )
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight / 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Row(
                children: [
                  SizedBox(width: screenWidth / 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('100 000 сум',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 47)),),
                      Text('За час',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                      color: Colors.grey,fontWeight: FontWeight.w500
                      )),),
                    ],
                  )
                ],
              ),label: ''
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
              },
              child: Container(
                margin: EdgeInsets.only(right: screenWidth / 40,left: screenWidth / 40),
                height: screenHeight / 18,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('Забронировать',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                  color: Colors.white,fontWeight: FontWeight.w500
                  )),),
                ),
              ),
            ), label: ''
          ),
        ],
      ),
    );
  }
}

