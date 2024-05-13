import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/profilePage_controller.dart';
import 'package:ibron/models/user_model.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfilePageController _profilePageController = ProfilePageController();
  late Future<User> _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
            SizedBox(height: screenHeight / 15,),
            FutureBuilder<User>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final user = snapshot.data!;
                  return Row(
                    children: [
                      SizedBox(width: screenWidth / 40,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${user.firstName}',
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500,
                            )),
                          ),
                          Text('Планируйте развлечения',
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w700,
                            )),
                          ) ,
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/homePage_images/Frame 262.png',height: screenHeight / 25,),
                      )
                    ],
                  );
                }
              },
            ),
            SizedBox(height: screenHeight / 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth / 60,),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(right: screenWidth / 100,left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/free-icon-location-pin-4903621 1.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Поблизости',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 3.2,
                    margin: EdgeInsets.only(right: screenWidth / 100,left: screenWidth / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/free-icon-time-and-calendar-8403154 1.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Выходные',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight / 6.5,
                    margin: EdgeInsets.only(right: screenWidth / 120,left: screenWidth / 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/homePage_images/image 446.png',height: screenHeight / 20,),
                          SizedBox(height: screenHeight / 50,),
                          Text('Рекомендуем',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 60,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
