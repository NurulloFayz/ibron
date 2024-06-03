import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../controller/request_controller.dart';
import 'order_page.dart';

class SelectTimePage extends StatefulWidget {
  static const String id = 'selectTimePage';
  const SelectTimePage({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.serviceId,
    required this.userId,
    required this.price,
  }) : super(key: key);

  final String startTime;
  final String endTime;
  final String serviceId;
  final String userId;
  final String price;

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _next7Days;
  late int _selectedTabIndex;
  late Map<DateTime, List<FreeTime>> _freeTimesForDate;
  late ApiService _apiService;
  late String _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _freeTimesForDate = {};
    _next7Days = _calculateNext7Days();
    _selectedTabIndex = 0;
    _selectedTimeSlot = '';
    _tabController = TabController(length: _next7Days.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _apiService = ApiService();
    _fetchRequestsForDate(_next7Days[0]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTabIndex = _tabController.index;
      _fetchRequestsForDate(_next7Days[_selectedTabIndex]);
    });
  }

  List<DateTime> _calculateNext7Days() {
    final List<DateTime> next7Days = [];
    DateTime now = DateTime.now();

    // Start from the current day
    DateTime startDate = now.subtract(Duration(days: 6));
    for (int i = 0; i < 7; i++) {
      next7Days.add(startDate.add(Duration(days: i)));
    }
    return next7Days;
  }

  Future<void> _fetchRequestsForDate(DateTime date) async {
    try {
      final String serviceId = widget.serviceId;
      final String formattedDateForServer = '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';

      List<FreeTime> freeTimes = await _apiService.fetchFreeTimes(serviceId, formattedDateForServer);

      setState(() {
        _freeTimesForDate[date] = freeTimes;
      });
    } catch (e) {
      print('Error fetching free times: $e');
    }
  }

  Future<void> _sendPostRequest() async {
    if (_selectedTimeSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a time slot.')));
      return;
    }

    DateTime selectedDate = _next7Days[_selectedTabIndex];
    List<String> times = _selectedTimeSlot.split(" - ");
    String selectedStartTime = times[0];
    String selectedEndTime = times[1];

    final requestData = {
      'date': '${selectedDate.year}-${_addLeadingZero(selectedDate.month)}-${_addLeadingZero(selectedDate.day)}',
      'end_time': selectedEndTime,
      'price': double.parse(widget.price),
      'service_id': widget.serviceId,
      'start_time': selectedStartTime,
      'status': 'approved',
      'user_id': widget.userId,
    };
    try {
      // Navigate to OrderPage and pass requestData
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPage(requestData: requestData),
        ),
      );
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send request.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kun va vaqtni tanlang',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _next7Days.map((day) => Tab(text: _formatDateForDisplay(day))).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _next7Days
            .map(
              (day) => _buildTabContentForDate(day),
        )
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          _sendPostRequest();
        },
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
    );
  }

  Widget _buildTabContentForDate(DateTime day) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if (_freeTimesForDate.containsKey(day)) {
      final freeTimes = _freeTimesForDate[day]!;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust the number of columns as needed
          crossAxisSpacing: screenWidth / 50,
          mainAxisSpacing: screenHeight / 100,
          childAspectRatio: (screenWidth / 2) / (screenHeight / 17), // Adjust the aspect ratio as needed
        ),
        itemCount: freeTimes.length,
        itemBuilder: (context, index) {
          final freeTime = freeTimes[index];
          final timeSlot = '${freeTime.startTime} - ${freeTime.endTime}';
          final isSelected = _selectedTimeSlot == timeSlot;
          final isAvailable = freeTime.status;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isAvailable) {
                  _selectedTimeSlot = timeSlot;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 100, right: screenWidth / 50, left: screenWidth / 50),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green
                    : isAvailable
                    ? const Color(0xFFF2F4F7)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  timeSlot,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: screenHeight / 50,
                      fontWeight: FontWeight.w400,
                      color: isAvailable
                          ? (isSelected ? Colors.white : Colors.black)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "Bo'sh joylar mavjud emas",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: screenHeight / 45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
  }

  String _formatDateForDisplay(DateTime date) {
    final uzbekWeekdays = ['Yak', 'Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan'];
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'bugun';
    } else {
      return '${uzbekWeekdays[date.weekday % 7]}, ${(date.day)}';
    }
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
