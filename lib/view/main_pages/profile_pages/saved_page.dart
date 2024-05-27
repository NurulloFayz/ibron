import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/detail_page_controller.dart';
import '../../../models/favourite_model.dart';

class SavedPage extends StatelessWidget {
  static const String id = 'saved_page';
  final DetailPageController _detailPageController = DetailPageController();

  SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<List<FavouriteModel>>(
        future: _detailPageController.getServicesByUserId(),
        builder: (BuildContext context, AsyncSnapshot<List<FavouriteModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching services: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No services available',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 50,
                    color: const Color(0xFF98A2B3),
                  ),
                ),
              ),
            );
          } else {
            List<FavouriteModel> services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                FavouriteModel service = services[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight / 50, horizontal: screenWidth / 40),
                  child: Container(
                    height: screenHeight / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                          height: screenHeight / 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(height: screenHeight / 50),
                        Row(
                          children: [
                            SizedBox(width: screenWidth / 40),
                            Text(
                              service.name,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: screenHeight / 45,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF98A2B3),
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
            );
          }
        },
      ),
    );
  }
}
