import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ibron/controller/profile_page_controller.dart';
import 'package:ibron/view/detail_pages/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:convert';

import '../../../models/favourite_model.dart';

class SavedPage extends StatefulWidget {
  static const String id = 'saved_page';

  SavedPage({Key? key,required this.userId});
  String userId = '';

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late Future<List<Service>> futureFavouriteServices;
  ProfilePageController controller = ProfilePageController();

  @override
  void initState() {
    super.initState();
    futureFavouriteServices = getId().then((userId) {
      return fetchFavouriteServices(userId);
    });
    getId();
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? 'no id';
    print('id is $userId');
    return userId;
  }

  Future<List<Service>> fetchFavouriteServices(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorites?user_id=$userId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final favouriteModel = FavouriteModel.fromJson(jsonData);

        // Filter out null services
        List<Service> services = favouriteModel.services.where((service) => service != null).cast<Service>().toList();

        return services;
      } else {
        throw Exception('Failed to load favourite services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load favourite services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Saqlanganlar',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Service>>(
          future: futureFavouriteServices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data!.isEmpty) {
                return Text('No saved services found.');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final service = snapshot.data![index];
                    return Column(
                      children: [
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  DetailPage(
                                    amenities: service.amenities,
                                    amenityName: service.amenities[index].name,
                                    amenityUrl: service.amenities[index].url,
                                    startTime: '',
                                    userId: 'a2bf4004-c316-4d61-8330-b63bd019772a',
                                    serviceId: '5f59e754-0eaf-40a9-b4a1-26b21ca4337a',
                                    description: service.description,
                                    address: service.address,
                                    name: service.name,
                                    image: service.urls[0],
                                    day: '',
                                    price: service.price.toString(),
                                    endTime: '',
                                    distanceMile: '',
                                    point: Point(latitude: service.latitude.toDouble(), longitude: service.longitude.toDouble()),
                                  )
                              ));
                            },
                            child: Container(
                              height: 350 ,
                              width: 380,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000), // This is #0000001A in ARGB format
                                    offset: Offset(0, 2),
                                    blurRadius: 27,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 180,
                                    width: screenWidth,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFF2F4F7),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          service.urls[0],
                                          fit: BoxFit.cover,
                                        )
                                    )
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      const Icon(Icons.calendar_month_sharp,color: Color(0xFF98A2B3),size: 16,),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Text('day*',maxLines: 1,style: GoogleFonts.roboto(
                                            textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                            )
                                        ),),
                                      ),
                                      SizedBox(width: 10,),
                                      const Icon(Icons.timer,color: Color(0xFF98A2B3),size: 16,),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Text('starttime',maxLines: 1,style: GoogleFonts.roboto(
                                            textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                            )
                                        ),),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text('${service.duration} daqiqa',maxLines: 1,style: GoogleFonts.roboto(
                                            textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                            )
                                        ),),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      const SizedBox(width: 10,),
                                      Image.asset('assets/images/loc.png', color: const Color(0xFF98A2B3)),
                                      const SizedBox(width: 5,),
                                      Text(service.address ??'',maxLines: 1,style: GoogleFonts.roboto(
                                          textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                          )
                                      ),)
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.deleteFavourite(context, widget.userId,"a72bfaf1-601e-4ca8-a599-ba9e82a01ec9");
                                        },
                                        icon: Icon(Icons.more_horiz),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
