import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/request_controller.dart';

class RecordPage extends StatefulWidget {
  static const String id = 'recordPage';
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? _request;
  bool isFirstTextSelected = false;
  bool isSecondTextSelected = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    isSecondTextSelected = true;
  }

  void fetchData() async {
    try {
      Map<String, dynamic>? request = await apiService.fetchSavedRequest();
      if (request != null) {
        setState(() {
          _request = request;
          isLoading = false;
        });
      } else {
        print('No request data found.');
        isLoading = false;
      }
    } catch (e) {
      print('Error fetching data: $e');
      isLoading = false;
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
        child: Column(
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
            isSecondTextSelected
                ? isLoading
                ? CircularProgressIndicator(color: Colors.green,)
                : _request == null
                ? Text('No request data found.')
                : Column(
              children: [
                SizedBox(height: screenHeight / 50,),
                Container(
                  height: screenHeight / 3.8,
                  width: screenWidth,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        offset: Offset(0, 2),
                        blurRadius: 27,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight / 10,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      SizedBox(height: screenHeight / 60),
                      Row(
                        children: [
                          SizedBox(width: screenWidth / 40,),
                          const Icon(Icons.timer,color:Color(0xFF98A2B3),),
                          SizedBox(width: screenWidth / 40,),
                          Text(
                            '${_request!['start_time']} - ${ _request!['end_time']}',
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight / 100),
                      Row(
                        children: [
                          SizedBox(width: screenWidth / 40,),
                          const Icon(Icons.wallet,color: Color(0xFF98A2B3),),
                          SizedBox(width: screenWidth / 40,),
                          Text(
                            "${_request!['price']} so'm",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight / 100),
                      Row(
                        children: [
                          SizedBox(width: screenWidth / 40,),
                          const Icon(Icons.calendar_month,color: Color(0xFF98A2B3),),
                          SizedBox(width: screenWidth / 40,),
                          Text(
                            "${_request!['date']}",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(fontSize: screenHeight / 45, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Text('no date')
          ],
        ),
      ),
    );
  }
}
