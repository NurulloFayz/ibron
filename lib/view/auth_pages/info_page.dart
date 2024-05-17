import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/infoPage_controller.dart';

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
                controller: controller.firstname,
                decoration: InputDecoration(
                    hintText: 'Введите имя',
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
                Text('Фамилия',style: GoogleFonts.roboto(textStyle: TextStyle(
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
                    hintText: 'Введите фамилию',
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
                Text('Дата рождения',style: GoogleFonts.roboto(textStyle: TextStyle(
                    fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                ))),
              ],
            ),
            SizedBox(height: screenHeight / 100,),
            Container(
              margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
              child: TextField(
                                controller: controller.birthday,
                decoration: InputDecoration(
                    hintText: 'Выберите дату рождения',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,fontWeight: FontWeight.w400)),
                    contentPadding: EdgeInsets.all(screenHeight / 60),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    // suffixIcon: IconButton(
                    //   onPressed: () async {
                    //     final DateTime? picked = await showDatePicker(
                    //       context: context,
                    //       initialDate: dateTime,
                    //       firstDate: DateTime(1900),
                    //       lastDate: DateTime.now(),
                    //     );
                    //     if (picked != null && picked != dateTime) {
                    //       setState(() {
                    //         dateTime = picked;
                    //         controller.birthday.text = "${picked.day}/${picked.month}/${picked.year}"; // Update the text field with the selected date
                    //       });
                    //     }
                    //   },
                    //   icon: const Icon(Icons.calendar_month, color: Colors.grey), // Calendar icon
                    // ),
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
                    setState(() {
                      controller.gender = 'Мужчина';
                      print(controller.gender);
                    });
                  },
                  icon: Icon(controller.gender == 'Мужчина' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: Colors.green,
                  ),
                ),
                Text('Мужчина', style: GoogleFonts.roboto(
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
                  icon: Icon(controller.gender == 'Женщина' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: Colors.green,
                  ),
                ),
                Text('Женщина', style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400
                  ),
                )),
              ],
            ),
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
            child: Text('Продолжить',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
