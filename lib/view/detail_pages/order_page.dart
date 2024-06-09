import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ibron/view/main_pages/main_pages.dart';

import '../../models/order_model.dart';

class OrderPage extends StatefulWidget {
  static const String id = 'order_page';
  final List<OrderData> requestDataList;

  const OrderPage({Key? key, required this.requestDataList}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = false;

  String calculateTimeRange() {
    String startTime = widget.requestDataList.first.startTime;
    String endTime = widget.requestDataList.last.endTime;
    return '$startTime - $endTime';
  }

  // order_page.dart

  Future<void> postOrder() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Constructing the request body
      Map<String, dynamic> requestBody = {
        'client_id': widget.requestDataList.first.clientId,
        'date': widget.requestDataList.first.date,
        'end_time': widget.requestDataList.last.endTime,
        'price': widget.requestDataList.first.price,
        'service_id': widget.requestDataList.first.serviceId,
        'start_time': widget.requestDataList.first.startTime,
        'status': widget.requestDataList.first.status,
        'user_id': widget.requestDataList.first.userId,
      };

      final response = await http.post(
        Uri.parse('https://ibron.onrender.com/ibron/api/v1/request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Handle successful response
        print(response.statusCode);
        print('Order posted successfully');
        Fluttertoast.showToast(
          msg: "Bro'n qilindi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: MediaQuery.of(context).size.height / 45,
        );
        Navigator.pushReplacementNamed(context, MainPages.id);
      } else {
        // Handle error response
        print('Failed to post order: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Failed to post order: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Buyurtmani tasdiqlang',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight / 30),
          Container(
            height: screenHeight / 5,
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF7F7F7),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: screenWidth / 40),
                    Container(
                      height: screenHeight / 10,
                      width: screenWidth / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF2F4F7),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          widget.requestDataList.first.date,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: screenHeight / 35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          calculateTimeRange(),
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: screenHeight / 35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight / 40),
                        Text(
                          widget.requestDataList.first.price.toString() +
                              " so'm 1 soat",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: screenHeight / 45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth / 40),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight / 20),
          Container(
            height: screenHeight / 16,
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF7F7F7),
            ),
            child: Row(
              children: [
                SizedBox(width: screenWidth / 30),
                Icon(Icons.wallet),
                SizedBox(width: screenWidth / 30),
                Text(
                  "Joyida to'lash",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: screenHeight / 45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          postOrder();
        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text(
              'Tasdiqlash',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: screenHeight / 45,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
