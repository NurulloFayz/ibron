import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'searchPage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Поиск',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 40,fontWeight: FontWeight.w400)),),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: screenWidth / 40,left: screenWidth / 40),
            child: TextField(
              style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45)),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(screenHeight / 90),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey)),
                hintText: 'Поиск',
                prefixIcon: const Icon(Icons.search_outlined,color: Colors.grey,),
                suffixIcon: const Icon(Icons.sort,color: Colors.grey,),
                  border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
          ),
          SizedBox(height: screenHeight / 40,),
          Row(
            children: [
              SizedBox(width: screenWidth / 30,),
              Container(
                width: screenWidth / 2.4,
                height: screenHeight / 20,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text('Поблизости',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w500)),),
                ),
              ),
              SizedBox(width: screenWidth / 50,),
              Container(
                width: screenWidth / 2.4,
                height: screenHeight / 20,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text('Рекомендуем',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w500)),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
