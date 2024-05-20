import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profilePage_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:ibron/controller/homePage_controller.dart';
import 'package:ibron/view/detail_pages/detail_page.dart';
import 'package:ibron/view/map_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
  late Future<List<ServiceModel>> _services;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _services = homePageController.postData(41.333787, 69.301298);
  }

  Future<void> _fetchUserData() async {
    try {
      final user = await _profilePageController.fetchUserData();
      setState(() {
        _userData = Future.value(user);
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage(Point(latitude: 41.333787, longitude:  69.301298))));
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
                      color: Color(0xFFF2F4F7),
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
            Container(
              height: screenHeight / 5,
              width: screenWidth,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: screenWidth / 30,left: screenWidth / 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/fotball.jpg',fit: BoxFit.cover,),
            ),
            SizedBox(height: screenHeight / 20),
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
              future: _services,
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
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            DetailPage(
                                distanceMile: service.distance.toString(),
                                address: service.address,
                                name: service.name,
                                price: service.price.toString(),point: Point(latitude: service.lat.toDouble(),longitude: service.long.toDouble()),
                            )
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            width: screenWidth / 2.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.normal,
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
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
                                  child: Image.asset('assets/images/fotball.jpg',fit: BoxFit.cover,),
                                ),
                                SizedBox(height: screenHeight / 80),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth / 40),
                                    const Icon(Icons.location_on_outlined, color: Color(0xFF98A2B3),),
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
                                    Image.asset('assets/images/Icon.png',color: const Color(0xFF98A2B3),
                                    ),
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
            ),

          ],
        ),
      ),
    );
  }
}
