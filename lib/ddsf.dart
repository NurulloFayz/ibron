// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class OtpPage extends StatefulWidget {
//   static const String id = 'otp_page';
//   const OtpPage({Key? key, required this.number,}) : super(key: key);
//   final String number;
//
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State<OtpPage> {
//   int decrement = 59;
//   late Timer timer;
//
//   void countDown() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (decrement > 0) {
//         setState(() {
//           decrement--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     countDown();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//   OtpPageController controller = OtpPageController();
//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     final defaultTheme = PinTheme(
//         width: screenWidth / 3,
//         height: screenHeight / 15,
//         textStyle: GoogleFonts.roboto(
//           textStyle: TextStyle(
//             fontSize: screenHeight / 45,
//           ),
//         ),
//         decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10)));
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.keyboard_backspace),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: screenHeight / 50),
//             ListTile(
//               title: Text(
//                 'Код подтверждения',
//                 style: GoogleFonts.roboto(
//                   textStyle: TextStyle(
//                     fontSize: screenHeight / 35,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight / 30),
//             Container(
//               margin: EdgeInsets.only(
//                   right: screenWidth / 40, left: screenWidth / 40),
//               child: Pinput(
//                 autofocus: true,
//                 controller: controller.verifyCode,
//                 length: 6,
//                 defaultPinTheme: defaultTheme,
//                 focusedPinTheme: defaultTheme.copyWith(
//                     decoration: defaultTheme.decoration!.copyWith(
//                         border: Border.all(color: Colors.green))),
//                 onCompleted: (pin) => debugPrint(pin),
//               ),
//             ),
//             const Spacer(),
//             Text('0:${decrement.toString()}',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 38,fontWeight: FontWeight.w400)),),
//             SizedBox(height: screenHeight / 50,),
//             GestureDetector(
//               onTap: () {
//                 if(decrement == 0) {
//                   print('time is up');
//                   return;
//                 } else {
//                   controller.verifyUser(context,widget.number);
//                 }
//               },
//               child: Container(
//                 height: screenHeight / 14,
//                 width: screenWidth / 1.1,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(7),
//                     color: Colors.purple
//                 ),
//                 child: Center(
//                   child: Text('Продолжить',style: GoogleFonts.roboto(textStyle: TextStyle(
//                       fontSize: screenHeight / 45,fontWeight: FontWeight.w500,color: Colors.white
//                   )),),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight / 30,)
//           ],
//         ),
//       ),
//     );
//   }
// }
