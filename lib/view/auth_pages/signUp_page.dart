import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/signUp_controller.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signUpPage';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpPageController controller = SignUpPageController();
  bool checkbox = false;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    Color fabColor = controller.typedText.length < 13 ? Colors.blue.withOpacity(0.3) : Colors.blue;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenHeight / 20,),
          ListTile(
            title: Text(
              'Ваш номер телефона',
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 28,
                      fontWeight: FontWeight.w700
                  )
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Мы отправим код подтверждения на ваш номер',
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey
                  )
              ),
            ),
          ),
          SizedBox(height: screenHeight / 30,),
          ListTile(
            title: Text('Номер телефона',style: GoogleFonts.roboto(textStyle: TextStyle(
              fontSize: screenHeight / 50,fontWeight: FontWeight.w400
            )),),
          ),
          Container(
            margin: EdgeInsets.only(right: screenWidth / 30,left: screenWidth / 30),
            child: Column(
              children: [
                TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13)
                  ],
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45)),
                  autofocus: true,
                  controller: controller.phone,
                  onChanged: (value) {
                    setState(() {
                      controller.typedText = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(screenHeight / 40),
                      //prefixText: '+998 ',
                      hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45)),
                      prefixStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(height: screenHeight / 30), // Adjust as needed
                if (controller.typedText.length >= 13 )
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              checkbox = !checkbox; // Toggle checkbox state
                            });
                          },
                            child: Icon(
                              checkbox ? Icons.check_box : Icons.check_box_outline_blank,
                              color: checkbox ? Colors.green : Colors.grey,size: screenHeight / 30,
                            ),)
                      ),
                      Expanded(
                        flex: 9,
                        child: Text('Регистрируясь, вы соглашаетесь с нашими Условиями использования и Политикой конфиденциальности',
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                              fontWeight: FontWeight.w400,color: Colors.grey
                          )),),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: fabColor,
        onPressed: () {
          controller.registerUser(context, controller.phone.text);
        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Подтвердить номер телефона',style: GoogleFonts.roboto(textStyle: TextStyle(
              fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
