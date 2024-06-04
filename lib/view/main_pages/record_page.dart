import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/view/detail_pages/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../controller/record_page_controller.dart';
import '../../models/request_model.dart';

class RecordPage extends StatefulWidget {
  static const String id = 'recordPage';
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordPageController _controller = RecordPageController();
  List<ServiceRequest> _serviceRequests = [];
  bool isFirstTextSelected = false;
  bool isSecondTextSelected = true;
  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    isSecondTextSelected = true;
    getUserIdAndFetchServiceRequests();

  }

  Future<void> getUserIdAndFetchServiceRequests() async {
    try {
      userId = await _controller.fetchUserID();
      print("user id is: $userId");
      await fetchServiceRequests(
          userId);
    } catch (e) {
      print('Error fetching user ID and service requests: $e');
      // Handle error
    }
  }

  Future<String> getUserIDFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  fetchServiceRequests(String userId) async {
    try {
      ServiceRequestData requestData =
          await _controller.fetchServiceRequestsByUserId(userId);
      setState(() {
        _serviceRequests = requestData.requests;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching service requests: $e');
      // Handle error
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
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    height: screenHeight / 17,
                    width: screenWidth / 1.1,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
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
                              margin: EdgeInsets.only(
                                  right: screenWidth / 80,
                                  left: screenWidth / 80),
                              decoration: BoxDecoration(
                                color:
                                    isFirstTextSelected ? Colors.white : null,
                                borderRadius: BorderRadius.circular(10),
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
                              margin: EdgeInsets.only(
                                  right: screenWidth / 80,
                                  left: screenWidth / 80),
                              decoration: BoxDecoration(
                                color:
                                    isSecondTextSelected ? Colors.white : null,
                                borderRadius: BorderRadius.circular(10),
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
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                  isSecondTextSelected
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              itemCount: _serviceRequests.length,
                              itemBuilder: (context, index) {
                                final request = _serviceRequests[index];
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: screenHeight / 40,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              amenities: const [],
                                              point: Point(
                                                latitude: request.service.latitude,
                                                longitude: request.service.longitude,
                                              ),
                                              distanceMile:'', // Update this line if you have distance data
                                              endTime: request.endTime,
                                              startTime: request.startTime,
                                              price: request.price.toString(),
                                              day: request.day,
                                              userId: request.userId,
                                              serviceId: request.serviceId,
                                              image: request.service.url.isNotEmpty ? request.service.url[0].url : '',
                                              name: request.service.name,
                                              address: request.service.address,
                                            ),
                                          ),
                                        );
                                      },
                                       child: Container(
                                        height: screenHeight / 2.2,
                                        width: screenWidth / 1.1,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x1A000000),// This is #0000001A in ARGB format
                                                offset: Offset(0, 2),
                                                blurRadius: 27,
                                                spreadRadius: 0,
                                              ),
                                            ]),
                                        child: Center(
                                            child: Column(
                                          children: [
                                            Container(
                                              height: screenHeight / 6,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.grey.withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight / 40,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: screenWidth / 40,
                                                ),
                                                Text(
                                                  'Futbol',
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize:
                                                              screenHeight / 40,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: screenWidth / 40,
                                                ),
                                                _controller.requestTexts(context,
                                                    iconData: Icons
                                                        .calendar_month_rounded,
                                                    dataText: request.day),
                                                SizedBox(
                                                  width: screenWidth / 20,
                                                ),
                                                _controller.requestTexts(context,
                                                    iconData: Icons
                                                        .access_time_outlined,
                                                    dataText: request.startTime),
                                                SizedBox(
                                                  width: screenWidth / 20,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: screenHeight / 100,
                                            ),
                                            Divider(
                                              thickness: 2,
                                              color: const Color(0xFFF2F4F7),
                                              endIndent: screenWidth / 20,
                                              indent: screenWidth / 20,
                                            ),
                                            SizedBox(
                                              height: screenHeight / 50,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _controller.fetchData(request.id,context);                                            },
                                              child: Container(
                                                height: screenHeight / 20,
                                                width: screenWidth / 1.3,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(30),
                                                    color: Colors.green),
                                                child: Center(
                                                  child: Text(
                                                    "Mashg'ulotni tasdiqlash",
                                                    style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                screenHeight / 50,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: screenWidth / 40,
                                                        left: screenWidth / 40),
                                                    height: screenHeight / 20,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons.cancel,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenWidth / 40,
                                                          ),
                                                          Text(
                                                            'Bekor qilish',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize:
                                                                    screenHeight /
                                                                        50,
                                                                color:
                                                                    Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenHeight / 20,
                                                  child: const VerticalDivider(
                                                    color:
                                                        Color(0xFFF2F4F7),
                                                    thickness: 3,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: screenWidth / 40,
                                                        left: screenWidth / 40),
                                                    height: screenHeight / 20,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons.directions,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenWidth / 50,
                                                          ),
                                                          Text(
                                                            "yo'nalish",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize:
                                                                    screenHeight /
                                                                        50,
                                                                color:
                                                                    Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: screenHeight / 100,
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 30,),
                                  ],
                                );
                              },
                            )
                          ),
                        )
                      : const Text('')
                ],
              ),
      ),
    );
  }
}
