import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profilePage_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../controller/homePage_controller.dart';
import '../detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfilePageController _profilePageController = ProfilePageController();
  final HomePageController homePageController = HomePageController();
  Future<User>? _userData;
  late List<MapObject<dynamic>> mapObjects = []; // Changed type to MapObject<dynamic>

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    homePageController.postData(41.333787, 69.301298).then((value) {
      setState(() {
        mapObjects = homePageController.mapObjects
            .map((obj) => obj as MapObject<dynamic>)
            .toList(); // Casting each element
      });
    });
  }


  Future<void> _fetchUserData() async {
    try {
      final user = await _profilePageController.fetchUserData();
      setState(() {
        _userData = Future.value(user);
      });
    } catch (e) {
      // Handle error gracefully
      print('Error fetching user data: $e');
      // Show error message to user if needed
    }
  }

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
                  return const Center(child: Text('Error fetching user data'));
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
                            'Планируйте развлечения',
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
                        onTap: () {},
                        child: Image.asset(
                          'assets/homePage_images/Frame 262.png',
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
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(
                        right: screenWidth / 100, left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/homePage_images/circle.png',
                            height: screenHeight / 20,
                          ),
                          SizedBox(height: screenHeight / 50),
                          Text(
                            'На карте',
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
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(
                        right: screenWidth / 100, left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/homePage_images/calendar (2).png',
                            height: screenHeight / 20,
                          ),
                          SizedBox(height: screenHeight / 50),
                          Text(
                            'Выходные',
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
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/homePage_images/image 446.png',
                            height: screenHeight / 20,
                          ),
                          SizedBox(height: screenHeight / 50),
                          Text(
                            'Рекомендуем',
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
            SizedBox(height: screenHeight / 20),
            Container(
              height: screenHeight / 5,
              width: screenWidth,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: screenWidth / 30,left: screenWidth / 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/homePage_images/fotball.jpg',fit: BoxFit.cover,),
            ),
            SizedBox(height: screenHeight / 50),
            ListTile(
              title: Text('Активный отдых',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,
                  fontWeight: FontWeight.w500
              )),),
            ),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  var prefs = snapshot.data!;
                  var business_name = prefs.getString('business_name') ?? '';
                  var distance = prefs.getDouble('distance') ?? '';
                  var address = prefs.getString('address') ?? '';
                  return GestureDetector(
                    onTap: () {
                      // Fetch the necessary data from SharedPreferences
                      var prefs = snapshot.data!;
                      var description = prefs.getString('description') ?? '';
                      var distance = prefs.getDouble('distance') ?? '';
                      var address = prefs.getString('address') ?? '';

                      // Convert mapObjects to the desired type
                      List<MapObject<dynamic>> convertedMapObjects =
                      mapObjects.map((obj) => obj as MapObject<dynamic>).toList();

                      // Navigate to the DetailPage and pass the data as arguments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            description: description,
                            distanceMile: distance.toString(),
                            address: address,
                            mapObjects: convertedMapObjects,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: screenHeight / 4,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: screenWidth / 30,),
                          Container(
                            height: screenHeight / 5,
                            width: screenWidth / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0,3),
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.normal
                                )
                              ]
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight / 8,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset('assets/homePage_images/fotball.jpg',fit: BoxFit.cover,),
                                ),
                                SizedBox(height: screenHeight / 50,),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth / 50,),
                                    const Icon(Icons.location_on_outlined,color: Colors.grey,),
                                    SizedBox(width: screenWidth / 100,),
                                    Text(business_name,style: GoogleFonts.roboto(textStyle: TextStyle(
                                      fontSize: screenHeight / 50,fontWeight: FontWeight.w500,color: Colors.grey,
                                    )),)
                                  ],
                                ),
                                SizedBox(height: screenHeight / 80,),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth / 50,),
                                    const Icon(Icons.navigation_outlined,color: Colors.grey,),
                                    SizedBox(width: screenWidth / 100,),
                                    Text(distance.toString(),style: GoogleFonts.roboto(textStyle: TextStyle(
                                        fontSize: screenHeight / 50,fontWeight: FontWeight.w500,color: Colors.grey,
                                    )),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
