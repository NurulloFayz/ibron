import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/record_page_controller.dart';

class RecordPage extends StatefulWidget {
  static const String id = 'recordPage';
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordPageController controller = RecordPageController();

  bool isFirstTextSelected = false;
  bool isSecondTextSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSecondTextSelected = true;
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Jadval',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: screenWidth / 1.1,
              height: screenHeight / 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF2F4F7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTextSelected = true;
                          isSecondTextSelected = false;
                        });
                      },
                      child: Container(
                        height: screenHeight / 22,
                        width: screenWidth / 1.6,
                        margin: EdgeInsets.only(right: screenWidth / 80,left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isFirstTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Tarix',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTextSelected = false;
                          isSecondTextSelected = true;
                        });
                      },
                      child: Container(
                        height: screenHeight / 22,
                        margin: EdgeInsets.only(right: screenWidth / 80,left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isSecondTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Kelgusi',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight / 40,),
            isSecondTextSelected ?  Container(
              margin: EdgeInsets.only(right: screenWidth / 50,left: screenWidth / 50),
              height: screenHeight / 2.7,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight / 40,),
                  Row(
                    children: [
                      SizedBox(width: screenWidth / 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Football',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,fontWeight: FontWeight.w500)),),
                          Container(
                            height: screenHeight / 28,
                            width: screenWidth / 4,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.withOpacity(0.3)
                            ),
                            child: Center(
                              child: Text('Kutilmoqda',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 52,fontWeight: FontWeight.w500,
                              color: Colors.green
                              )),),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: screenHeight / 22,
                        width: screenWidth / 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey
                          )
                        ),
                        child: const Center(
                          child: Icon(Icons.more_horiz,color: Colors.grey,),
                        ),
                      ),
                      SizedBox(width: screenWidth / 50,),
                    ],
                  ),
                  SizedBox(height: screenHeight / 40,),
                  Row(
                    children: [
                      SizedBox(width: screenWidth / 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kun',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,color:const Color(0xFF98A2B3))),),
                          Text('Ertaga',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500
                          )),),
                        ],
                      ),
                      Container(
                        height: screenHeight / 20, // Adjust the height as needed
                        child: VerticalDivider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vaqt',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,color:const Color(0xFF98A2B3))),),
                          Text('17:00',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                              fontWeight: FontWeight.w500
                          )),),
                        ],
                      ),
                      Container(
                        height: screenHeight / 20, // Adjust the height as needed
                        child: VerticalDivider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Davomiylik',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,color: const Color(0xFF98A2B3))),),
                          Text('60 мин',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                              fontWeight: FontWeight.w500
                          )),),
                        ],
                      ),
                      Container(
                        height: screenHeight / 20, // Adjust the height as needed
                        child: VerticalDivider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Narxi',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,color:const Color(0xFF98A2B3))),),
                          Text('200 000 сум',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                              fontWeight: FontWeight.w500
                          )),),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: screenWidth / 40,left: screenWidth / 40),
                    height: screenHeight / 6.6,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  const Color(0xFFF2F4F7),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight / 80,),
                        Row(
                          children: [
                            SizedBox(width: screenWidth / 40,),
                            Text('Yunusobod football',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,fontWeight: FontWeight.w500)))
                          ],
                        ),
                        SizedBox(height: screenHeight / 100,),
                        Row(
                          children: [
                            SizedBox(width: screenWidth / 40,),
                            Image.asset('assets/images/loc.png',color: const Color(0xFF98A2B3)),
                            SizedBox(width: screenWidth / 45,),
                            Text('Amirsoy',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400,
                                color: Colors.grey
                            ))),
                          ],
                        ),
                        SizedBox(height: screenHeight / 100,),
                        Row(
                          children: [
                            SizedBox(width: screenWidth / 40,),
                            Image.asset('assets/images/Icon.png',color: const Color(0xFF98A2B3)),
                            SizedBox(width: screenWidth / 50,),
                            Text('sizdan 3.6 km uzoqlikda',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400,
                                color: Colors.grey
                            ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight / 80,)
                ],
              ),
            ):Text('no data')
          ],
        ),
      ),
    );
  }
}
