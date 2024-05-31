// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
//
// class OrderPage extends StatefulWidget {
//   static const String id = 'order_page';
//   const OrderPage({
//     Key? key,
//     required this.startTime,
//     required this.endTime,
//     required this.date,
//   }) : super(key: key);
//
//   final String startTime;
//   final String endTime;
//   final String date;
//
//   @override
//   State<OrderPage> createState() => _OrderPageState();
// }
//
// class _OrderPageState extends State<OrderPage> {
//   Future<void> _postOrder() async {
//     final String apiUrl = 'https://ibron.onrender.com/ibron/api/v1/request';
//     final Map<String, dynamic> requestData = {
//       'start_time': widget.startTime,
//       'end_time': widget.endTime,
//       'date': widget.date,
//
//       {
//         "date": "dfsf",
//         "end_time": "dsfds",
//         "price": 0,
//         "service_id": "fsd",
//         "start_time": "sdf",
//         "status": "sdf",
//         "user_id": "sdf"
//       }
//       // Add other necessary fields
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order.')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text("Buyurtmani tasdiqlang", style: GoogleFonts.roboto(
//           textStyle: TextStyle(
//             fontSize: screenHeight / 40,
//             fontWeight: FontWeight.w500,
//           ),
//         )),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: screenHeight / 3,
//             width: screenWidth / 1.1,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: const Color(0xFFF2F4F7),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(width: screenWidth / 40,),
//                     Container(
//                       height: screenHeight / 10,
//                       width: screenWidth / 6,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: const Color(0xFFF2F4F7),
//                       ),
//                     ),
//                     const Spacer(),
//                     Column(
//                       children: [
//                         Text(widget.date),
//                         Row(
//                           children: [
//                             Text('${widget.startTime} - ${widget.endTime}', style: GoogleFonts.roboto(
//                               textStyle: TextStyle(fontSize: screenHeight / 47, fontWeight: FontWeight.w500),
//                             )),
//                           ],
//                         ),
//                         SizedBox(width: screenWidth / 40,),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _postOrder,
//             child: Text('Confirm Order', style: GoogleFonts.roboto(
//               textStyle: TextStyle(
//                 fontSize: screenHeight / 45,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w400,
//               ),
//             )),
//           ),
//         ],
//       ),
//     );
//   }
// }
