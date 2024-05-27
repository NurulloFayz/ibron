import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/detail_page_controller.dart';
import 'package:ibron/view/detail_pages/select_time_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;


class DetailPage extends StatefulWidget {
  static String? id;
  final String? distanceMile;
  final Point? point;
  final String? address;
  final String? name;
  final String? price;
  final String? image;
  final String? serviceId;
  final String? userId;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? ameneties;
  const DetailPage({
    super.key,
    this.distanceMile,
    this.address,
    this.name,
    this.price,
    this.point,
    this.image,
    this.serviceId,
    this.userId,
    this.day,
    this.startTime,
    this.endTime,
    this.ameneties,
    // Add this line
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailPageController controller = DetailPageController();

  late List<MapObject> mapObjects = [];

  PlacemarkMapObject getPlaceMark() {
    final point0 = Point(
      latitude: widget.point!.latitude,
      longitude: widget.point!.longitude,
    );
    return PlacemarkMapObject(
      mapId: const MapObjectId('mapIdCurrent'),
      point: widget.point ?? point0,
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          scale: 3,
          image: BitmapDescriptor.fromAssetImage(
              'assets/images/ic_location.png'
          ),
        ),
      ),
    );
  }
  bool likeButton = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapObjects = [getPlaceMark()];
    print('userId is passed ${widget.userId}');
    print('serviceId is passed ${widget.serviceId}');
  }
  Future<void> showMapSelectionDialog(BuildContext context, double latitude, double longitude) async {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;
          return Container(
            height: screenHeight / 5,
            width: screenWidth,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Image.asset('assets/images/googlemaps.png', height: 24),
                  title: Text('Google xarita', style: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500)),
                  onTap: () async {
                    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                    if (await canLaunch(googleMapsUrl)) {
                      await launch(googleMapsUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Sizda Google xarita topilmadi',
                              style: TextStyle(fontSize: screenHeight / 50, fontWeight: FontWeight.w500)
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: '',
                            onPressed: () {
                              // Perform undo functionality here
                            },
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/yandexLogo.png', height: 24),
                  title: Text('Yandex xarita', style: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w500)),
                  onTap: () async {
                    final String yandexMapsUrl = 'yandexmaps://maps.yandex.ru/?pt=$longitude,$latitude&z=12&l=map';
                    if (await canLaunch(yandexMapsUrl)) {
                      await launch(yandexMapsUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Sizda Yandex xarita topilmadi',
                              style: TextStyle(fontSize: screenHeight / 50, fontWeight: FontWeight.w500)
                          ),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: '',
                            onPressed: () {
                              // Perform undo functionality here
                            },
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
    );
  }
  Future<void> addToFavorite(String serviceId) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id') ?? '';
      await controller.postFavorite(serviceId, userId);
      print('Service $serviceId added to favorites');
      // You can update UI here to reflect the favorite status
    } catch (e) {
      print('Error adding to favorite: $e');
      // Handle error
    }
  }
  List<dynamic> data = [];
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Image.network(
                      widget.image.toString() ?? 'no image',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 10,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 1.3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                        size: screenHeight / 30,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight / 15,
                  left: screenWidth / 1.1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                         setState(() {
                           controller.postFavorite(widget.serviceId ??'', widget.userId ??'');
                           //addToFavorite(widget.serviceId.toString());
                         //  likeButton = !likeButton;
                         });
                        },
                        child:  Icon(
                          likeButton  ? Icons.favorite :Icons.favorite_border,
                          color: Colors.white,
                          size: screenHeight / 30,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                'Futbol maydoni',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: screenWidth / 40),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  right: screenWidth / 30, left: screenWidth / 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.address ?? '',
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'sizdan (${widget.distanceMile}) km uzoqlikda',
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF667085)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 70,
                    ),
                    Divider(
                      thickness: 2,
                      color: const Color(0xFFF2F4F7),
                      endIndent: screenWidth / 20,
                      indent: screenWidth / 20,
                    ),
                    SizedBox(
                      height: screenHeight / 70,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight / 10,
              width: screenWidth / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  const Color(0xFFF2F4F7),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 40,
                  ),
                  const Icon(
                    Icons.access_time_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: screenWidth / 40,
                  ),
                  Text('${widget.day}',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500)),),
                  SizedBox(width: screenWidth / 40,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${widget.startTime}',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w400)),),
                      SizedBox(width: screenHeight / 40,),
                      Text('${widget.endTime}',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w400)),),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.navigate_next,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: screenWidth / 20,
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight / 30),
            Row(
              children: [
                SizedBox(width: screenWidth / 20,),
                Text(
                  'Qulayliklar',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: screenHeight / 45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight / 100, bottom: screenHeight / 80, left: screenWidth / 20, right: screenWidth / 20),
              child: GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth / 100,
                mainAxisSpacing: screenHeight / 100,
                childAspectRatio: 2.8,
                children: (widget.ameneties!.split(',')).map<Widget>((service) {
                  return ListTile(
                    title: Text(
                      service.trim(), // Trim to remove any leading or trailing spaces
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    leading: Icon(Icons.info, color: Colors.green), // You can assign icons based on amenity names
                  );
                }).toList(),

              ),
            ),
            SizedBox(height: screenHeight / 40),
            ListTile(
              title: Text(
                'Tavsif',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: screenWidth / 20, left: screenWidth / 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'null',
                  maxLines: null,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 70,
            ),
            Divider(
              thickness: 2,
              color: const Color(0xFFF2F4F7),
              endIndent: screenWidth / 20,
              indent: screenWidth / 20,
            ),
            SizedBox(
              height: screenHeight / 70,
            ),
            ListTile(
              title: Text(
                'Manzil',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              height: screenHeight / 1.7,
              width: screenWidth / 1.1,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // This is #0000001A in ARGB format
                    offset: Offset(0, 2),
                    blurRadius: 27,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: YandexMap(
                      mapObjects: mapObjects,
                      onMapCreated: (YandexMapController controller) async {
                        // await determinePosition(controller);
                        controller.moveCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: widget.point!,
                              // zoom: 12,
                            ),
                          ),
                          animation: const MapAnimation(
                            type: MapAnimationType.linear,
                            duration: 1,
                          ),
                        );

                      },
                      // rotateGesturesEnabled: false,
                      // tiltGesturesEnabled: false,
                      mode2DEnabled: true,
                      fastTapEnabled: true,
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: screenHeight / 5,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight / 100,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: screenWidth / 40,
                                left: screenWidth / 40),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.address ?? '',
                                maxLines: null,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: screenHeight / 50,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight / 80,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth / 40,
                              ),
                              Image.asset('assets/images/Icon.png',color: const Color(0xFF98A2B3)),
                              SizedBox(
                                width: screenWidth / 40,
                              ),
                              Text(
                                'Sizdan ${widget.distanceMile} km uzoqlikda',
                                maxLines: null,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: screenHeight / 50,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF667085)
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: screenHeight / 80,
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: const Color(0xFFF2F4F7),
                              endIndent: screenWidth / 20,
                              indent: screenWidth / 20,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              showMapSelectionDialog(context,widget.point!.latitude, widget.point!.longitude);
                              // final double latitude = widget.point!.latitude;
                              // final double longitude = widget.point!.longitude;
                              // final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                              // final String yandexMapsUrl = 'yandexmaps://maps.yandex.ru/?pt=$longitude,$latitude&z=12&l=map';
                              //
                              // if (await canLaunch(yandexMapsUrl)) {
                              //   await launch(yandexMapsUrl);
                              // } else if (await canLaunch(googleMapsUrl)) {
                              //   await launch(googleMapsUrl);
                              // } else {
                              //   throw 'Could not launch maps';
                              // }
                            },
                            title: Text('Построить маршрут',style: GoogleFonts.roboto(textStyle: TextStyle(
                                fontSize: screenHeight / 50,color: Colors.green,fontWeight: FontWeight.w500
                            )),),
                            trailing: const Icon(Icons.navigate_next_outlined,color: Colors.green,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth / 20,
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      const String phoneNumber = '+998941222233'; // replace with the actual phone number
                      const String telUrl = 'tel:$phoneNumber';

                      if (await canLaunch(telUrl)) {
                        await launch(telUrl);
                      } else {
                        throw 'Could not launch $telUrl';
                      }
                    },
                    child: Container(
                      height: screenHeight / 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFFF2F4F7)),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.call_outlined,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: screenWidth / 30,
                              ),
                              Text(
                                "Bog'lanish",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: screenHeight / 50,
                                        fontWeight: FontWeight.w400)),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: Container(
                      height: screenHeight / 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.2)),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/detailPage/instagram (2).png',
                            height: screenHeight / 28,
                          ),
                          SizedBox(
                            width: screenWidth / 20,
                          ),
                          Icon(
                            Icons.telegram,
                            color: Colors.blue,
                            size: screenHeight / 28,
                          ),
                          SizedBox(
                            width: screenWidth / 30,
                          ),
                        ],
                      )),
                )
              ],
            ),
            SizedBox(height: screenHeight / 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.price ?? '',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(fontSize: screenHeight / 47)),
                      ),
                      Text(
                        'Soatiga',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: screenHeight / 50,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  )
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  controller.navigateToSelectTimePage(context,widget.startTime.toString(),widget.endTime.toString(),widget.serviceId.toString(),
                    widget.userId.toString(),widget.price.toString()
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: screenWidth / 40, left: screenWidth / 40),
                  height: screenHeight / 18,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Bron qilish',
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: screenHeight / 50,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              label: ''),
        ],
      ),
    );
  }
}
