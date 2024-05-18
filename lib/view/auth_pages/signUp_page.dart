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
    Color fabColor = controller.typedText.length < 9 ? Colors.green.withOpacity(0.3) : Colors.green;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenHeight / 20,),
          ListTile(
            title: Text(
              "Telefo'n raqamingiz",
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
              "Raqamingizga tasdiqlovchi sms ko'd yuboramiz",
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
            title: Text("Telefon raqamingiz",style: GoogleFonts.roboto(textStyle: TextStyle(
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
                      prefixText: '+998',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(height: screenHeight / 30), // Adjust as needed
                if (controller.typedText.length >= 9 )
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
                        child: Text("Ro'yxatdan o'tish orqali siz Foydalanish shartlari va Maxfiylik siyosatimizga rozilik bildirasizmi",
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
          if(!checkbox) {
            return;
          } else {
            controller.registerUser(context, controller.phone.text);
          }
        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Raqamni tasdiqlash',style: GoogleFonts.roboto(textStyle: TextStyle(
              fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
