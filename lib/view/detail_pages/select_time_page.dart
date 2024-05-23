import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectTimePage extends StatefulWidget {
  static const String id = 'selectTimePage';
  const SelectTimePage({Key? key}) : super(key: key);

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  late List<DateTime> _next7Days;
  late int _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _next7Days = _calculateNext7Days();
    _selectedTabIndex = 0; // Default to the first tab
  }

  List<DateTime> _calculateNext7Days() {
    final List<DateTime> next7Days = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      next7Days.add(now.add(Duration(days: i)));
    }
    return next7Days;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: _next7Days.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Kun va Vaqtni tanlang',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: screenHeight / 45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.green,
            labelStyle: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: screenHeight / 50,
                fontWeight: FontWeight.w400,
              ),
            ),
            isScrollable: true,
            padding: EdgeInsets.zero,
            tabs: _next7Days.map((day) {
              return Tab(
                child: Text(
                  _formatDate(day),
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenHeight / 45,
                      color: _selectedTabIndex == _next7Days.indexOf(day) ? Colors.green : const Color(0xFF6E8BB7),
                    ),
                  ),
                ),
              );
            }).toList(),
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: _next7Days.map((day) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bo'sh joylar mavjud emas",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: screenHeight / 40,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight / 100),
                  Text(
                    "Boshqa kunni tanlang",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: screenHeight / 45,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6A6A6A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.green,
          onPressed: () {},
          label: SizedBox(
            width: screenWidth * .8,
            child: Center(
              child: Text(
                'Tasdiqlash',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenHeight / 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (_isToday(date)) {
      return 'Bugun';
    } else {
      return '${_weekdayName(date)} ${date.day}';
    }
  }

  String _weekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Dush';
      case DateTime.tuesday:
        return 'Sesh';
      case DateTime.wednesday:
        return 'Chor';
      case DateTime.thursday:
        return 'Pay';
      case DateTime.friday:
        return 'Juma';
      case DateTime.saturday:
        return 'Shan';
      case DateTime.sunday:
        return 'Yak';
      default:
        return '';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
