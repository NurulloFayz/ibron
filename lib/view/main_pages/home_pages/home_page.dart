import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profile_page_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:ibron/controller/home_page_controller.dart';
import 'package:ibron/view/detail_pages/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../models/banner_model.dart';
import '../../map_page/map_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfilePageController _profilePageController = ProfilePageController();
  final HomePageController homePageController = HomePageController();
  Future<User>? _userData;
  late Future<BannerModel> _banners;
  late Future<List<ServiceModel>> services;
  late Future<List<Map<String, dynamic>>> scheduleData;

  @override
  void initState() {
    super.initState();
    services = homePageController.postData(41.333787, 69.301298);
    _banners = HomePageController.getBanner();
    scheduleData = fetchScheduleData();
    fetchUserData();
    //getUserid();
  }

  Future<List<Map<String, dynamic>>> fetchScheduleData() async {
    final url = Uri.parse('https://ibron.onrender.com/ibron/api/v1/schedules');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['schedule'];
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load schedule data');
      }
    } catch (e) {
      throw Exception('Failed to load schedule data: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      final user = await _profilePageController.fetchUserData();
      setState(() {
        _userData = Future.value(user);
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight / 15),
            FutureBuilder<User>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text(''));
                } else {
                  final user = snapshot.data!;
                  return Row(
                    children: [
                      SizedBox(width: screenWidth / 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "O'yin-kulgi rejalashtiryapsizmi",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          homePageController.navigateToNotificationPage(context);
                        },
                        child: Image.asset(
                          'assets/images/Frame 262.png',
                          height: screenHeight / 25,
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            SizedBox(height: screenHeight / 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth / 60),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage(
                          point:Point(latitude:41.333787,longitude:  69.301298))));
                    },
                    child: Container(
                      height: screenHeight / 6.5,
                      width: screenWidth / 3.2,
                      margin: EdgeInsets.only(
                          right: screenWidth / 100, left: screenWidth / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF2F4F7),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/circle.png',
                              height: screenHeight / 20,
                            ),
                            SizedBox(height: screenHeight / 50),
                            Text(
                              'Xarita',
                              maxLines: null,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: screenHeight / 50,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(
                        right: screenWidth / 100, left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF2F4F7),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/calendar (2).png',
                            height: screenHeight / 20,
                          ),
                          SizedBox(height: screenHeight / 50),
                          Text(
                            'Hafta Oxiri',
                            maxLines: null,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: screenHeight / 50,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    margin: EdgeInsets.only(
                        right: screenWidth / 120, left: screenWidth / 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF2F4F7),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/image 446.png',
                            height: screenHeight / 20,
                          ),
                          SizedBox(height: screenHeight / 50),
                          Text(
                            'Tavsiya',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: screenHeight / 50,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 60),
              ],
            ),
            SizedBox(height: screenHeight / 40),
            FutureBuilder<BannerModel>(
              future: _banners,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.banners.isEmpty) {
                  return Text('No banners available');
                } else {
                  return SizedBox(
                    height: screenHeight / 4.5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.banners.length,
                      itemBuilder: (context, index) {
                        final banner = snapshot.data!.banners[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
                              distanceMile: banner.service.distance.toString(),
                              point: Point(latitude: banner.service.latitude, longitude: banner.service.longitude),
                              address: banner.service.address,
                              name: banner.service.name,
                              price: banner.service.price.toString(),
                              image: banner.url,
                            ) ));
                          },
                          child: Container(
                            width: screenWidth / 1.2,
                            margin: EdgeInsets.only(right: screenWidth / 100,left: screenWidth / 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(banner.url,fit: BoxFit.cover,),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: screenHeight / 40),
            Row(
              children: [
                SizedBox(width: screenWidth / 30,),
                Text('Katalog',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500
                )),),
              ],
            ),
            SizedBox(height: screenHeight / 80),
        FutureBuilder<List<ServiceModel>>(
          future: services,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<ServiceModel> services = snapshot.data!;
              return Container(
                height: screenHeight / 4,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    ServiceModel service = services[index];

                    return GestureDetector(
                      onTap: () async {
                        final List<Map<String, dynamic>> schedule = await scheduleData;
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            DetailPage(
                              distanceMile: service.distance.toString(),
                              address: service.address,
                              name: service.name,
                              price: service.price.toString(),
                              point: Point(latitude: service.lat.toDouble(), longitude: service.long.toDouble()),
                              userId: _profilePageController.id,
                              serviceId: service.id,
                              day: schedule[index]['day'] ?? '',
                              startTime: schedule[index]['start_time'] ?? '',
                              endTime: schedule[index]['end_time'] ?? '',
                              image: service.urls[0].url,
                              ameneties: service.amenities.join(', '),
                            )
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                        width: screenWidth / 2.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000), // This is #0000001A in ARGB format
                              offset: Offset(0, 2),
                              blurRadius: 27,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight / 7,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(service.urls[0].url),
                            ),
                            SizedBox(height: screenHeight / 80),
                            Row(
                              children: [
                                SizedBox(width: screenWidth / 40),
                                Image.asset('assets/images/loc.png', color: const Color(0xFF98A2B3)),
                                SizedBox(width: screenWidth / 40),
                                Text(
                                  service.name,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: screenHeight / 50,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight / 100),
                            Row(
                              children: [
                                SizedBox(width: screenWidth / 40),
                                Image.asset('assets/images/Icon.png', color: const Color(0xFF98A2B3)),
                                SizedBox(width: screenWidth / 25),
                                Text(
                                  service.distance.toString(),
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: screenHeight / 50,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        )
        ],
        ),
      ),
    );
  }
}
