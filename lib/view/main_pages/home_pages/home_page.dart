import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profile_page_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:ibron/controller/home_page_controller.dart';
import 'package:ibron/models/banner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late PageController _pageController;
  int _currentPage = 0;
  String token = '';

  getToken() async {
    var prefs = await SharedPreferences.getInstance();
    token = await FirebaseMessaging.instance.getToken() ?? '';
    prefs.setString('token', token);
    print('token is saved $token');
    print('your device token is $token');
  }

  @override
  void initState() {
    super.initState();
    _allDataFuture = fetchAllData();
    getToken();
    _pageController = PageController(viewportFraction: 0.9);  // Set viewportFraction here
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
            return const Center(child: CircularProgressIndicator(color: Colors.green));
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: screenWidth / 40),
                      Expanded(
                        child: Container(
                          height: screenHeight / 6,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth / 100),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              LocationModel location = locations[1];
                              return GestureDetector(
                                onTap: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      MapPage(
                                        point: Point(
                                            latitude: location.lat.toDouble(),
                                            longitude: location.long.toDouble()),
                                      )
                                  ));
                                },
                                child: Container(
                                  height: screenHeight / 6.5,
                                  width: screenWidth / 3.3,
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
                      ),
                      Expanded(
                        child: Container(
                          height: screenHeight / 6,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth / 100), // Uniform margins
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFF2F4F7),
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
                                  'Hafta oxiri',
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
                          height: screenHeight / 6,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth / 100), // Uniform margins
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
                      SizedBox(width: screenWidth / 40),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.banners.length,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        if (index == null) {
                          return const Center(
                            child: CircularProgressIndicator(),);
                        } else {
                          final banner = banners.banners[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      DetailPage(

                                        description: banner.service
                                            ?.description,
                                        serviceId: banner.serviceId,
                                        distanceMile: '',
                                        point: Point(latitude: 0, longitude: 0),
                                        address: '',
                                        name: banner.service?.name,
                                        price: banner.service?.price.toString(),
                                        image: banner.url,
                                        amenities: banner.service!.amenities,
                                      )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                width: 380,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                    banner.url, fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }
                      }
                    ),
                  ),
                  SizedBox(height: screenHeight / 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(banners.banners.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? Colors.green : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight / 40),
                  Row(
                    children: [
                      SizedBox(width: screenWidth / 30),
                      Text('Katalog', style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (context,index) {
                        ServiceModel service = services[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
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
                                    amenityName: service.amenities[index].name,
                                    amenityUrl: service.amenities[index].url, amenities: service.amenities,
                                  )
                              ));
                            },
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0,2),
                                      blurRadius: 5,
                                      color:
                                      Color(0x1A000000),
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.normal
                                  ),
                                ],
                              ),
                              child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 110,
                                    width: 180,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.network(service.thumbnail,fit: BoxFit.cover,),
                                  ),
                                  const SizedBox(height: 15,),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SizedBox(width: 10,),
                                          ),
                                          TextSpan(
                                              text: service.name,style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700),)
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SizedBox(width: 10,),
                                          ),
                                          WidgetSpan(
                                            child: Image.asset('assets/images/loc.png', color: const Color(0xFF98A2B3)),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5,),
                                          ),
                                          TextSpan(text: service.address,style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(fontSize: 15,color: Color(0xFF667085),fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis
                                            ),)
                                          )
                                        ]
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: SizedBox(width: 7,),
                                            ),
                                            WidgetSpan(
                                              child: Image.asset('assets/images/Icon.png', color: const Color(0xFF98A2B3)),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 7,),
                                            ),
                                            TextSpan(text: service.distance.toString(),style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(fontSize: 15,color: Color(0xFF667085),fontWeight: FontWeight.w400,
                                                  overflow: TextOverflow.ellipsis
                                              ),)
                                            )
                                          ]
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
