import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/view/main_pages/profile_pages/saved_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/profile_page_controller.dart';
import '../../../models/user_model.dart';
import 'language_page.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfilePageController controller = ProfilePageController();
  late Future<User> _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _userData = controller.fetchUserData();
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profil',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green,));
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight / 30),
                  GestureDetector(
                    onTap: () {
                      controller.navigateToEditPage(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth / 30),
                        CircleAvatar(
                          radius: screenHeight / 20,
                          backgroundColor: const Color(0xFFF2F4F7),
                          child: Icon(Icons.person,color: const Color(0xFF98A2B3),size: screenHeight / 20,),
                          // Display user's profile image here
                          // backgroundImage: NetworkImage(user.profileImageUrl),
                        ),
                        SizedBox(width: screenWidth / 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: screenHeight / 45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth / 70),
                            Text(
                              '${user.phoneNumber}' ?? '',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: screenHeight / 45,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF667085)
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.navigate_next),
                        SizedBox(width: screenWidth / 18),
                      ],
                    ),
                  ),
                  // Other ListTile items...
                  SizedBox(height: screenHeight / 20),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, SavedPage.id);
                    },
                    leading: CircleAvatar(
                      radius: screenHeight / 30,
                      backgroundColor: const Color(0xFFF2F4F7),
                      child: Icon(Icons.bookmark_outline_rounded, color: Colors.green),
                    ),
                    title: Text(
                      'Saqlanganlar',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  SizedBox(height: screenHeight / 100),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    indent: screenWidth / 20,
                  ),
                  SizedBox(height: screenHeight / 60),
                  ListTile(
                    leading: CircleAvatar(
                      radius: screenHeight / 30,
                      backgroundColor: const Color(0xFFF2F4F7),
                      child: Icon(Icons.headphones, color: Colors.green),
                    ),
                    title: Text(
                      "Biz bilan bog'lanish",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  SizedBox(height: screenHeight / 100),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    indent: screenWidth / 20,
                  ),
                  SizedBox(height: screenHeight / 60),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, LanguagePage.id);
                    },
                    leading: CircleAvatar(
                      radius: screenHeight / 30,
                      backgroundColor: const Color(0xFFF2F4F7),
                      child: Icon(Icons.language, color: Colors.green),
                    ),
                    title: Text(
                      'Til',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  SizedBox(height: screenHeight / 100),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    indent: screenWidth / 20,
                  ),
                  SizedBox(height: screenHeight / 60),
                  ListTile(
                    onTap: () {
                      controller.logout(context,);
                    },
                    leading: CircleAvatar(
                      radius: screenHeight / 30,
                      backgroundColor: const Color(0xFFF2F4F7),
                      child: Icon(Icons.logout, color: Colors.green),
                    ),
                    title: Text(
                      'Chiqish',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  SizedBox(height: screenHeight / 100),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    indent: screenWidth / 20,
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
