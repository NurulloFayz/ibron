import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/record_page_controller.dart';
import '../../models/user_all_requests_model.dart';

class RecordPage extends StatefulWidget {
  static const String id = 'recordPage';
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordPageController _controller = RecordPageController();
  List<ServiceRequest> _serviceRequests = [];
  bool isFirstTextSelected = false;
  bool isSecondTextSelected = true;
  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    isSecondTextSelected = true;
    getUserIdAndFetchServiceRequests();
  }

  Future<void> getUserIdAndFetchServiceRequests() async {
    try {
      userId = await _controller.fetchUserID();
      print("user id is: $userId");
      await fetchServiceRequests(userId); // Pass the userId to fetchServiceRequests
    } catch (e) {
      print('Error fetching user ID and service requests: $e');
      // Handle error
    }
  }

  Future<String> _getUserIDFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  fetchServiceRequests(String userId) async {
    try {
      ServiceRequestData requestData = await _controller.fetchServiceRequestsByUserId(userId);
      setState(() {
        _serviceRequests = requestData.requests;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching service requests: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          children: [
            Container(
              height: screenHeight / 17,
              width: screenWidth / 1.1,
              decoration: BoxDecoration(
                color: Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTextSelected = true;
                          isSecondTextSelected = false;
                        });
                      },
                      child: Container(
                        height: screenHeight / 22,
                        width: screenWidth / 1.6,
                        margin: EdgeInsets.only(right: screenWidth / 80, left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isFirstTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Tarix',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTextSelected = false;
                          isSecondTextSelected = true;
                        });
                      },
                      child: Container(
                        height: screenHeight / 22,
                        margin: EdgeInsets.only(right: screenWidth / 80, left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isSecondTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Kelgusi',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            isSecondTextSelected ? Expanded(
              child: ListView.builder(
                itemCount: _serviceRequests.length,
                itemBuilder: (context, index) {
                  final request = _serviceRequests[index];
                  return Column(
                    children: [
                      Container(
                        height: screenHeight / 4,
                        width: screenWidth,
                        margin: EdgeInsets.only(right: screenWidth / 40,left: screenWidth / 40),
                        decoration: BoxDecoration(

                        ),
                      ),
                    ],
                  );
                },
              ),
            ): const Text('')
          ],
        ),
      ),
    );
  }
}
