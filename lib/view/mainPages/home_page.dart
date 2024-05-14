import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profilePage_controller.dart';
import 'package:ibron/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/homePage_controller.dart';
import '../detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    homePageController.postData(41.333787, 69.301298);
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
                            'Поблизости',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: screenHeight / 45,
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
                                  fontSize: screenHeight / 45,
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
                                  fontSize: screenHeight / 45,
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
            SizedBox(height: screenHeight / 50),
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
                  return GestureDetector(
                    onTap: () {
                      // Fetch the necessary data from SharedPreferences
                      var prefs = snapshot.data!;
                      var description = prefs.getString('description') ?? '';
                      var distance = prefs.getDouble('distance') ?? '';

                      // Navigate to the DetailPage and pass the data as arguments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            description: description, address: distance.toString()
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth / 10),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: screenHeight / 5,
                                width: screenWidth / 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined),
                                    SizedBox(height: screenHeight / 50),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on_outlined,color: Colors.grey,),
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: screenWidth / 60,
                                            left: screenWidth / 60,
                                          ),
                                          child: Text(
                                            business_name,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: screenHeight / 55,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight / 100),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: screenWidth / 20),
                                        Icon(Icons.navigation_rounded, color: Colors.grey),
                                        SizedBox(width: screenWidth / 100),
                                        Text(
                                          distance.toString(),
                                          style: TextStyle(
                                            fontSize: screenHeight / 55,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
