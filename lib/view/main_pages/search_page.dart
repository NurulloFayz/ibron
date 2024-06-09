import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../controller/home_page_controller.dart';
import '../detail_pages/detail_page.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'searchPage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<ServiceModel>> _services;
  final HomePageController homePageController = HomePageController();
  bool isNearbySelected = true; // Track if "Поблизости" is selected
  bool isRecommendedSelected = false; // Track if "Рекомендуем" is selected
  TextEditingController _searchController = TextEditingController();
  List<ServiceModel> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _services = homePageController.postData(41.333787, 69.301298);
    _searchController.addListener(_filterServices);
    Timer(Duration(seconds: 3), () {
      CircularProgressIndicator();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    super.dispose();
  }
  void _filterServices() {
    setState(() {
      final String searchText = _searchController.text.isNotEmpty
          ? _searchController.text[0].toUpperCase()
          : '';
      _services.then((services) {
        _filteredServices = services.where((service) {
          return service.name.toUpperCase().startsWith(searchText) ||
              service.name.toUpperCase().startsWith(searchText);
        }).toList();
      }).catchError((error) {
        print("Error: $error");
        _filteredServices = []; // Reset filtered services on error
      });
    });
  }









  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Qidiruv',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 40),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: screenHeight / 45),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(screenHeight / 90),
                filled: true,
                fillColor: const Color(0xFFF2F4F7),
                hintStyle: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 45,
                      color: const Color(0xFF98A2B3)),
                ),
                hintText: 'Qidiruv',
                prefixIcon:
                    const Icon(Icons.search_outlined, color: Color(0xFF98A2B3)),
                suffixIcon:
                    const Icon(Icons.tune_rounded, color: Color(0xFF98A2B3)),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight / 40),
          Row(
            children: [
              SizedBox(width: screenWidth / 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNearbySelected = true;
                    isRecommendedSelected = false;
                  });
                },
                child: Container(
                  width: screenWidth / 2.4,
                  height: screenHeight / 20,
                  decoration: BoxDecoration(
                    color: isNearbySelected
                        ? Colors.green
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Atrofdagilar',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: screenHeight / 45,
                            fontWeight: FontWeight.w500),
                        color: isNearbySelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth / 50),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNearbySelected = false;
                    isRecommendedSelected = true;
                  });
                },
                child: Container(
                  width: screenWidth / 2.4,
                  height: screenHeight / 20,
                  decoration: BoxDecoration(
                    color: isRecommendedSelected
                        ? Colors.green
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Tavsiya',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: screenHeight / 45,
                            fontWeight: FontWeight.w500),
                        color:
                            isRecommendedSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight / 20),
          Row(
            children: [
              SizedBox(width: screenWidth / 30),
              Text(
                'Tavsiya',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: screenHeight / 45, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.navigate_next_outlined,
                color: Colors.grey,
              ),
              SizedBox(
                width: screenWidth / 30,
              )
            ],
          ),
          SizedBox(height: screenHeight / 100),
          isNearbySelected
              ? FutureBuilder<List<ServiceModel>>(
                  future: _services,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.green,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<ServiceModel> services =
                          _searchController.text.isEmpty
                              ? snapshot.data!
                              : _filteredServices;
                      return SizedBox(
                        height: screenHeight / 3.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            ServiceModel service = services[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                              distanceMile:
                                                  service.distance.toString(),
                                              address: service.address,
                                              name: service.name,
                                              price: service.price.toString(),
                                              point: Point(
                                                  latitude:
                                                      service.lat.toDouble(),
                                                  longitude:
                                                      service.long.toDouble()),
                                              amenities: service.amenities,
                                          description: service.description,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenHeight / 100),
                                width: screenWidth / 2.4,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                          color: Color(0x1A000000),
                                          spreadRadius: 2,
                                          blurStyle: BlurStyle.normal)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:110,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        service.urls[0].url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ListTile(
                                      title:  Text(service.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:  GoogleFonts.roboto(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth / 40),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/images/loc.png',
                                              color: const Color(0xFF98A2B3)),
                                          SizedBox(width: screenWidth / 40),

                                          Expanded(
                                            child: Text(
                                              service.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF98A2B3),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 100),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth / 40),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/Icon.png',
                                            color: const Color(0xFF98A2B3),
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
                                          )
                                        ],
                                      ),
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
                )
              : Text('No Data Yet')
        ],
      ),
    );
  }
}
