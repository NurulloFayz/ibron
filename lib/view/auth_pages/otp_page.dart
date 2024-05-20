import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/otpPage_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  static const String id = 'otpPage';
  const OtpPage(this.number,{super.key});
  final String number;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  OtpPageController controller = OtpPageController();
  @override
  void initState() {
    controller.countDown();
    super.initState();
  }
  @override
  void dispose() {
    controller.timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    Color fabColor = controller.typedText.length < 4 ? Colors.green.withOpacity(0.3) : Colors.green;
    final defaultTheme = PinTheme(
        width: screenWidth / 3,
        height: screenHeight / 15,
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: screenHeight / 45,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body:ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<OtpPageController>(
          builder: (context,controller,index) {
            return Column(
              children: [
                SizedBox(height: screenHeight / 40,),
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
                Row(
                  children: [
                    SizedBox(width: screenWidth / 25,),
                    Text(
                      "4 xonali ko'dni kiriting",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: screenHeight / 40,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight / 70,),
                Row(
                  children: [
                    SizedBox(width: screenWidth / 25,),
                    Text('+998 ${widget.number}',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,fontWeight: FontWeight.w400)),),
                  ],
                ),
                SizedBox(height: screenHeight / 30,),
                Container(
                  margin: EdgeInsets.only(
                      right: screenWidth / 20, left: screenWidth / 20),
                  child: Pinput(

                    autofocus: true,
                    controller: controller.verifyCode,
                    length: 4,
                    defaultPinTheme: defaultTheme,
                    focusedPinTheme: defaultTheme.copyWith(
                        decoration: defaultTheme.decoration!.copyWith(
                            border: Border.all(color: Colors.green))),
                    onCompleted: (pin) => debugPrint(pin),
                    onChanged: (value) {
                      setState(() {
                        controller.typedText = value;
                      });
                    },
                  ),

                ),
                Spacer(),
                GestureDetector(
                  onTap: () {

                  },
                  child: Text(
                    '${controller.decrement == 0 ? "Qayta yuborish" :
                    '${controller.minutes.toString().padLeft(2, '0')}:${controller.seconds.toString().padLeft(2, '0')}'}',
                    style: GoogleFonts.roboto(
                      textStyle: controller.decrement != 0 ?TextStyle(
                        fontSize: screenHeight / 38,
                        fontWeight: FontWeight.w400,
                      ) : TextStyle(fontSize: screenHeight / 45,color: Colors.green,fontWeight: FontWeight.w400)
                    )
                  ),
                ),
                SizedBox(height: screenHeight / 8,),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: fabColor,
        onPressed: () {
          if(controller.decrement == 0) {
            return;
          } else {
            controller.verifyUser(context,widget.number);
          }
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
