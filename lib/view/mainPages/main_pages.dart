import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/mainPages_controller.dart';
import 'package:ibron/view/mainPages/home_page.dart';
import 'package:ibron/view/mainPages/profile_pages/profile_page.dart';
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
        onPageChanged: (index) {
          setState(() {
            controller.selected = index;
          });
        },
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
        selectedColor: Colors.green,
        strokeColor: Colors.white,
        unSelectedColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            title: Text("Главная",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500
            )),),
            selectedTitle: Text("Главная",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500,color: Colors.green
            )),)
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            title: Text("Поиск",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500
            ))),
            selectedTitle: Text("Поиск",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500,color: Colors.green
            ))),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            title: Text("Мои записи",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500
            ))),
            selectedTitle: Text("Мои записи",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500,color: Colors.green
            ))),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.person_outline_outlined),
            title: Text("Профиль",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500
            ))),
            selectedTitle: Text("Профиль",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,
                fontWeight: FontWeight.w500,color: Colors.green
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
