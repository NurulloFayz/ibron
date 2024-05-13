import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/recordPage_controller.dart';

class RecordPage extends StatefulWidget {
  static const String id = 'recordPage';
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordPageController controller = RecordPageController();

  bool isFirstTextSelected = false;
  bool isSecondTextSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFirstTextSelected = true;
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
          'Мои записи',
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
              width: screenWidth / 1.1,
              height: screenHeight / 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.2),
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
                        margin: EdgeInsets.only(right: screenWidth / 80,left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isFirstTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'История',
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
                        margin: EdgeInsets.only(right: screenWidth / 80,left: screenWidth / 80),
                        decoration: BoxDecoration(
                          color: isSecondTextSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Предстоящие',
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
          ],
        ),
      ),
    );
  }
}
