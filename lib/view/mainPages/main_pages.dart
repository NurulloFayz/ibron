import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/mainPages_controller.dart';
import 'package:ibron/view/mainPages/home_page.dart';
import 'package:ibron/view/mainPages/profile_page.dart';
import 'package:ibron/view/mainPages/record_page.dart';
import 'package:ibron/view/mainPages/search_page.dart';

class MainPages extends StatefulWidget {
  static const String id = 'mainPages';
  const MainPages({super.key});

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  MainPagesController controller = MainPagesController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.controller = PageController();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        controller: controller.controller,
        children: const [
          HomePage(),
          SearchPage(),
          RecordPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        elevation: 5,
        iconSize: screenHeight / 28,
        selectedColor: Colors.blue,
        strokeColor: Colors.white,
        unSelectedColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            title: Text("Главная",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400
            )),),
            selectedTitle: Text("Главная",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400,color: Colors.blue
            )),)
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            title: Text("Поиск",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400
            ))),
            selectedTitle: Text("Поиск",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400,color: Colors.blue
            ))),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            title: Text("Мои записи",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400
            ))),
            selectedTitle: Text("Мои записи",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400,color: Colors.blue
            ))),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.person_outline_outlined),
            title: Text("Профиль",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400
            ))),
            selectedTitle: Text("Профиль",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400,color: Colors.blue
            ))),
          ),
        ],
        currentIndex: controller.selected,
        onTap: (index) {
          setState(() {
            controller.selected = index;
            controller.controller.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
      ),
    );
  }
}
