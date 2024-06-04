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
    bool isNearbySelected = true;
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
      final String searchText = _searchController.text.toLowerCase();
      _services.then((services) {
        _filteredServices = services.where((service) {
          // Filter by the first letter only
          return service.name.toLowerCase().startsWith(searchText.substring(0, 1));
        }).toList();
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
            margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
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
                  textStyle: TextStyle(fontSize: screenHeight / 45, color: const Color(0xFF98A2B3)),
                ),
                hintText: 'Qidiruv',
                prefixIcon: const Icon(Icons.search_outlined, color: Color(0xFF98A2B3)),
                suffixIcon: const Icon(Icons.tune_rounded, color: Color(0xFF98A2B3)),
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
                    color: isNearbySelected ? Colors.green : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Atrofdagilar',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500),
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
                    color: isRecommendedSelected ? Colors.green : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Tavsiya',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500),
                        color: isRecommendedSelected ? Colors.white : Colors.black,
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
                  textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              const Icon(Icons.navigate_next_outlined,color: Colors.grey,),
              SizedBox(width: screenWidth / 30,)
            ],
          ),
          SizedBox(height: screenHeight / 100),
          isNearbySelected ? FutureBuilder<List<ServiceModel>>(
            future: _services,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.green,));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<ServiceModel> services = snapshot.data!;
                return SizedBox(
                  height:  screenHeight / 4,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _searchController.text.isEmpty ? services.length : _filteredServices.length,
                    itemBuilder: (context, index) {
                      ServiceModel service = _searchController.text.isEmpty ? services[index] : _filteredServices[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              DetailPage(
                                distanceMile: service.distance.toString(),
                                address: service.address,
                                name: service.name,
                                price: service.price.toString(),point: Point(latitude: service.lat.toDouble(),longitude: service.long.toDouble()), amenities: [],
                              )
                          ));
                        },
                        child:
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: screenHeight / 100),
                          width: screenWidth / 2.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0,2),
                                blurRadius: 5,
                                color:
                                Color(0x1A000000),
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal
                              )
                            ]
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

                              SizedBox(height: screenHeight / 100),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/loc.png',color: const Color(0xFF98A2B3)),
                                    SizedBox(width: screenWidth / 40),
                                    Text(
                                      service.address,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF98A2B3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight / 100),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                                child: Row(
                                  children: [
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
          ) : Text('No Data Yet')
        ],
      ),
    );
  }
}
