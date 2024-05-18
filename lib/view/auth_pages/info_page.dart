import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/infoPage_controller.dart';
import 'package:intl/intl.dart';  // Import the intl package for date formatting

class InfoPage extends StatefulWidget {
  static const String id = 'infoPage';
  final String number;

  const InfoPage(this.number, {Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  InfoPageController controller = InfoPageController();
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    print(widget.number);
    controller.gender = 'Мужчина';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
        controller.birthday = picked;
      });
    }
  }

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
                "Malumotlarni kiriting",
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
                Text('Ism',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                controller: controller.firstname,
                decoration: InputDecoration(
                    hintText: 'Ismingizni kiriting',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,fontWeight: FontWeight.w400)),
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
                Text('Familiya',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                controller: controller.lastname,
                decoration: InputDecoration(
                    hintText: 'Familiyangizni kiritng',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,fontWeight: FontWeight.w400)),
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
                Text("Tug'ilgan sana",style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
                margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                child: Container(
                  height: screenHeight / 15,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth / 30,),
                      Text(
                        controller.birthday == null
                            ? "Tug'ilgan sana kiriting"
                            : DateFormat('yyyy-MM-dd').format(controller.birthday!),
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400)),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_month, color: Colors.grey),
                      ),
                    ],
                  ),
                )
            ),
            SizedBox(height: screenHeight / 40,),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text("Jins",style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
              ],
            ),
            SizedBox(height: screenHeight / 70,),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      controller.gender = 'Мужчина';
                      print(controller.gender);
                    });
                  },
                  icon: Icon(controller.gender == 'Мужчина' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: Colors.green,
                  ),
                ),
                Text('Erkak', style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400
                  ),
                )),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      controller.gender = 'Женщина';
                      print(controller.gender);
                    });
                  },
                  icon: Icon(controller.gender == 'Ayol' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: Colors.green,
                  ),
                ),
                Text('Ayol', style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400
                  ),
                )),
              ],
            ),
            SizedBox(height: screenHeight / 10,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          controller.addUserInfo(context, widget.number);
          print(controller.gender);
          print(controller.birthday);
          print(controller.lastname);
          print(controller.firstname);
          print(widget.number);
        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Davom Ettirish',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
