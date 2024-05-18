
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../controller/homePage_controller.dart';
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

  @override
  void initState() {
    super.initState();
    bool isNearbySelected = true;
    _services = homePageController.postData(41.333787, 69.301298);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Qidiruv',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
            child: TextField(
              style: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: screenHeight / 45),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(screenHeight / 90),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                hintStyle: GoogleFonts.roboto(
                  textStyle: TextStyle(fontSize: screenHeight / 45, color: Colors.grey),
                ),
                hintText: 'Qidiruv',
                prefixIcon: const Icon(Icons.search_outlined, color: Colors.grey),
                suffixIcon: const Icon(Icons.tune_rounded, color: Colors.grey),
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
                    color: isNearbySelected ? Colors.green : Colors.grey.withOpacity(0.2),
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
                    color: isRecommendedSelected ? Colors.green : Colors.grey.withOpacity(0.2),
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
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<ServiceModel> services = snapshot.data!;
                return Container(
                  height: screenHeight / 4,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      ServiceModel service = services[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              DetailPage(
                                distanceMile: service.distance.toString(),
                                address: service.address,
                                name: service.name,
                                price: service.price.toString(),point: Point(latitude: service.lat.toDouble(),longitude: service.long.toDouble()),
                              )
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          width: screenWidth / 2.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                              ),
                            ],
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
                                child: Image.asset(
                                  'assets/images/fotball.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: screenHeight / 80),
                              Row(
                                children: [
                                  SizedBox(width: screenWidth / 40),
                                  const Icon(Icons.location_on_outlined, color: Colors.grey),
                                  SizedBox(width: screenWidth / 40),
                                  Text(
                                    service.name,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: screenHeight / 50,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight / 100),
                              Row(
                                children: [
                                  SizedBox(width: screenWidth / 40),
                                  const Icon(Icons.navigation_outlined, color: Colors.grey),
                                  SizedBox(width: screenWidth / 40),
                                  Text(
                                    service.distance.toString(),
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: screenHeight / 50,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
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
