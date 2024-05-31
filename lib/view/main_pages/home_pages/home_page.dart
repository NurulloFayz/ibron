import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profile_page_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:ibron/controller/home_page_controller.dart';
import 'package:ibron/models/banner_model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../detail_pages/detail_page.dart';
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
  late Future<Map<String, dynamic>> _allDataFuture;

  @override
  void initState() {
    super.initState();
    _allDataFuture = fetchAllData();
  }

  Future<Map<String, dynamic>> fetchAllData() async {
    try {
      final userData = _profilePageController.fetchUserData();
      final banners = HomePageController.getBanner();
      final services = homePageController.postData(41.333787, 69.301298);
      final locations = homePageController.postLocations(41.333787, 69.301298);
      final scheduleData = fetchScheduleData();

      final results = await Future.wait([userData, banners, services, locations, scheduleData]);

      return {
        'userData': results[0] as User,
        'banners': results[1] as BannerModel,
        'services': results[2] as List<ServiceModel>,
        'locations': results[3] as List<LocationModel>,
        'scheduleData': results[4] as List<Map<String, dynamic>>,
      };
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _allDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final user = data['userData'] as User;
            final banners = data['banners'] as BannerModel;
            final services = data['services'] as List<ServiceModel>;
            final locations = data['locations'] as List<LocationModel>;
            final scheduleData = data['scheduleData'] as List<Map<String, dynamic>>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight / 15),
                  Row(
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
                  ),
                  SizedBox(height: screenHeight / 30),
                  Container(
                    height: screenHeight / 6,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        LocationModel location = locations[index];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                MapPage(
                                  point: Point(latitude: location.lat.toDouble(), longitude: location.long.toDouble()),
                                )
                            ));
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
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight / 40),
                  SizedBox(
                    height: screenHeight / 4.5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: banners.banners.length,
                      itemBuilder: (context, index) {
                        final banner = banners.banners[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
                              distanceMile: banner.service.distance.toString(),
                              point: Point(latitude: banner.service.latitude, longitude: banner.service.longitude),
                              address: banner.service.address,
                              name: banner.service.name,
                              price: banner.service.price.toString(),
                              image: banner.url,
                              amenities: [],
                            )));
                          },
                          child: Container(
                            width: screenWidth / 1.2,
                            margin: EdgeInsets.only(right: screenWidth / 100, left: screenWidth / 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(banner.url, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight / 40),
                  Row(
                    children: [
                      SizedBox(width: screenWidth / 30,),
                      Text('Katalog', style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: screenHeight / 80),
                  Container(
                    height: screenHeight / 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        ServiceModel service = services[index];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                DetailPage(
                                  distanceMile: service.distance.toString(),
                                  address: service.address,
                                  name: service.name,
                                  price: service.price.toString(),
                                  point: Point(latitude: service.lat.toDouble(), longitude: service.long.toDouble()),
                                  userId: _profilePageController.id,
                                  serviceId: service.id,
                                  day: scheduleData[index]['day'] ?? '',
                                  startTime: scheduleData[index]['start_time'] ?? '',
                                  endTime: scheduleData[index]['end_time'] ?? '',
                                  image: service.urls[0].url,
                                  amenities: service.amenities,
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
                                    SizedBox(width: screenWidth / 40),
                                    Text(
                                      service.distance.toString(),
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: screenHeight / 55,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF98A2B3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight / 100),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

