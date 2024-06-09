
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/view/detail_pages/detail_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../controller/record_page_controller.dart';
import '../../models/request_model.dart';
import 'package:contacts_service/contacts_service.dart';



class RecordPage extends StatefulWidget {
  static const String id = 'record_page';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordPageController _controller = RecordPageController();
  ServiceRequest? serviceRequest;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _controller.secondButton = true;
  }

  Future<void> _fetchData() async {
    try {
      final String? userId = await _controller.fetchUserID();
      if (userId != null) {
        final ServiceRequest fetchedServiceRequest =
        await _controller.fetchServiceRequestsByUserId(userId);
        setState(() {
          serviceRequest = fetchedServiceRequest;
          isLoading = false;
        });
      } else {
        // Handle the case where the user ID is null
        throw Exception('User ID is null');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
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

  void showContactsBottomSheet(BuildContext context, String serviceId) async {
    // Request permission to access contacts
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      // Fetch contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();

      // Convert contacts to list of names
      List<String> contactNames = contacts.map((contact) => contact.displayName ?? '').toList();

      // Show bottom modal sheet
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Display list of contacts
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: contactNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(contactNames[index]),
                      onTap: () {
                        // Handle contact selection here
                        // You can send the selected contact and service ID to your app or service
                        sendContactToApp(contactNames[index], serviceId); // Sending both contact and service ID
                        Navigator.pop(context); // Close the bottom modal sheet
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Handle the case where permission is not granted
      print('Permission to access contacts not granted');
    }
  }

  void sendContactToApp(String contact, String serviceId) {
    // Your logic to send contact and service ID to your app or service goes here
    print('Sending contact: $contact, Service ID: $serviceId');

    // Example: You can use a platform channel to send this data to native code or an API
  }

  Future<void> requestContactsPermission() async {
    // Request permission to access contacts
    final PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      // Permission granted, proceed with accessing contacts
      // You can call your function to show the contacts bottom sheet here
    } else {
      // Permission denied, handle accordingly (e.g., show a message to the user)
      print('Permission to access contacts not granted');
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
          'Jadval',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.firstButton = true;
                  _controller.secondButton = false;
                });
              },
              child:
              Container(
                height: screenHeight / 18,
                width: screenWidth / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF2F4F7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: _controller.firstButton ? Container(
                          height: screenHeight / 21,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text('Tarix',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 50,fontWeight: FontWeight.w500
                            )),),
                          ),
                        ):Center(
                          child: Text('Tarix',style: GoogleFonts.roboto(textStyle: TextStyle(
                              fontSize: screenHeight / 50,fontWeight: FontWeight.w500
                          )),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.firstButton = false;
                              _controller.secondButton = true;
                            });
                          },
                          child: _controller.secondButton ? Container(
                            height: screenHeight / 21,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text('Kelgusi',style:  GoogleFonts.roboto(textStyle: TextStyle(
                                  fontSize: screenHeight / 50,fontWeight: FontWeight.w500
                              )),),
                            ),
                          ):Center(
                            child: Text('Kelgusi',style:  GoogleFonts.roboto(textStyle: TextStyle(
                                fontSize: screenHeight / 50,fontWeight: FontWeight.w500
                            )),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: screenHeight / 80,),
            _controller.secondButton ?
            Expanded(
              child:
              ListView.builder(
                itemCount: serviceRequest?.requests.length ?? 0,
                itemBuilder: (context, index) {
                  final request = serviceRequest?.requests[index];
                  final service = request?.service;
                  if (request == null || service == null) {
                    // Handle the case where serviceRequest is null
                    return SizedBox.shrink(); // Return an empty widget or a loading indicator
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenHeight / 100),
                        child: GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                DetailPage(
                                  amenityName: serviceRequest!.requests[index].service.amenities[index].name,
                                  amenityUrl: serviceRequest!.requests[index].service.amenities[index].url,
                                  amenities:serviceRequest!.requests[index].service.amenities,
                                  description: serviceRequest!.requests[index].service.description,
                                  address: serviceRequest!.requests[index].service.address,
                                  startTime: serviceRequest!.requests[index].startTime,
                                  endTime: serviceRequest!.requests[index].endTime,
                                  day: serviceRequest!.requests[index].day,
                                  name: serviceRequest!.requests[index].service.name,
                                  image: serviceRequest!.requests[index].service.url[0].url,
                                  userId: serviceRequest!.requests[index].userId,
                                  price: serviceRequest!.requests[index].price.toString(),
                                  serviceId: serviceRequest!.requests[index].serviceId,
                                  point: Point(
                                      latitude: serviceRequest!.requests[index].service.latitude.toDouble(),
                                      longitude:  serviceRequest!.requests[index].service.longitude.toDouble(),
                                  ),
                                  distanceMile: '',
                                )
                            ));
                          },
                          child: Container(
                            height: screenHeight / 2.2,
                            width: screenWidth / 1.1,
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
                                  height: 150,
                                  width: screenWidth,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF2F4F7),
                                  ),
                                  child: Image.network(serviceRequest!.requests[index].service.url[0].url,fit: BoxFit.cover,),
                                ),
                                 ListTile(
                                   title: Text(serviceRequest!.requests[index].service.name ??'',maxLines: 1,style: GoogleFonts.roboto(
                                       textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w600,
                                         overflow: TextOverflow.ellipsis
                                       )
                                   ),),
                                 ),
                                SizedBox(height: 10,),
                                 Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    const Icon(Icons.calendar_month_sharp,color: Color(0xFF98A2B3),size: 16,),
                                    const SizedBox(width: 5,),
                                    Expanded(
                                      child: Text(serviceRequest!.requests[index].day,maxLines: 1,style: GoogleFonts.roboto(
                                          textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                          )
                                      ),),
                                    ),
                                    SizedBox(width: 10,),
                                    const Icon(Icons.timer,color: Color(0xFF98A2B3),size: 16,),
                                    const SizedBox(width: 5,),
                                    Expanded(
                                      child: Text(serviceRequest!.requests[index].startTime,maxLines: 1,style: GoogleFonts.roboto(
                                          textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                          )
                                      ),),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('${serviceRequest!.requests[index].duration.toString()} daqiqa',maxLines: 1,style: GoogleFonts.roboto(
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
                                    Text(serviceRequest!.requests[index].service.address ??'',maxLines: 1,style: GoogleFonts.roboto(
                                        textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,color:const Color(0xFF98A2B3)
                                        )
                                    ),)
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap:(){
                                    _controller.openQr(serviceRequest!.requests[index].id, context);
                                  },
                                  child: Container(
                                    height: screenHeight / 18,
                                    width: screenWidth / 1.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green
                                    ),
                                    child: Center(
                                      child: Text("Mashg'ulotni tasdiqlash",style: GoogleFonts.roboto(
                                        textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w500,
                                        color: Colors.white
                                        )
                                      ),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_add,color: Colors.green,),
                                          SizedBox(width: 5,),
                                          GestureDetector(
                                            onTap:() async {
                                              await requestContactsPermission();
                                              showContactsBottomSheet(context, request.serviceId);
                                            },
                                            child: Text('Taklif qilish',style: GoogleFonts.roboto(textStyle:TextStyle(
                                              fontSize: screenHeight  /50,fontWeight: FontWeight.w500,color: Colors.green
                                            )),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color:  const Color(0xFFF2F4F7),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions,color: Colors.green,),
                                          SizedBox(width: 5,),
                                          GestureDetector(
                                            onTap:(){
                                              showMapSelectionDialog(context, serviceRequest!.requests[index].service.latitude,
                                                  serviceRequest!.requests[index].service.longitude
                                              );
                                            },
                                            child: Text("Yo'nalish",style: GoogleFonts.roboto(textStyle:TextStyle(
                                              fontSize: screenHeight  /50,fontWeight: FontWeight.w500,color: Colors.green
                                            )),),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ):Expanded(
              child: Center(
                child: Text('Mavjud emas',style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: screenHeight / 45,fontWeight: FontWeight.w600,
                )),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
