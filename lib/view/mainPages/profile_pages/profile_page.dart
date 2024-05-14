import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/profilePage_controller.dart';
import '../../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfilePageController controller = ProfilePageController();
  Future<User>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = await controller.fetchUserData();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Профиль',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Column(
              children: [
                SizedBox(height: screenHeight / 30),
                GestureDetector(
                  onTap: () {
                    controller.navigateToEditPage(context,user.phoneNumber);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth / 30),
                      CircleAvatar(
                        radius: screenHeight / 20,
                        backgroundColor: Colors.grey.withOpacity(0.2),
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth / 70),
                          Text(
                            user.phoneNumber ?? '',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
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
                SizedBox(height: screenHeight / 20),
                ListTile(
                  leading: CircleAvatar(
                    radius: screenHeight / 30,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    child: Icon(Icons.bookmark_outline_rounded, color: Colors.green),
                  ),
                  title: Text(
                    'Избранные',
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
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    child: Icon(Icons.headphones, color: Colors.green),
                  ),
                  title: Text(
                    'Обратная связь',
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
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    child: Icon(Icons.language, color: Colors.green),
                  ),
                  title: Text(
                    'Язык',
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
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    child: Icon(Icons.logout, color: Colors.green),
                  ),
                  title: Text(
                    'Выйти',
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
            );
          }
        },
      ),
    );
  }
}
