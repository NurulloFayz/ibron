import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../controller/request_controller.dart';
import '../../models/request_model.dart';

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
  late ApiService apiService;
  Request? requestData;
  bool checkbox = false;

  @override
  void initState() {
    super.initState();
    _next7Days = _calculateNext7Days();
    _selectedTabIndex = 0;
    _tabController = TabController(length: _next7Days.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    apiService = ApiService(baseUrl: 'https://ibron.onrender.com');
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
    for (int i = 0; i < 7; i++) {
      next7Days.add(now.add(Duration(days: i)));
    }
    return next7Days;
  }

  Future<void> _fetchRequestsForDate(DateTime date) async {
    try {
      Request? request = await apiService.fetchRequests();
      setState(() {
        requestData = request;
      });
    } catch (e) {
      // Handle error
      print('Error fetching requests: $e');
    }
  }

  Future<void> postRequest(DateTime day, String startTime, String endTime,
      String serviceId, String userId) async {
    final Uri uri =
        Uri.parse('https://ibron.onrender.com/ibron/api/v1/request');

    // Retrieve status from requestData or set a default value
    String status = requestData?.requests.isNotEmpty ?? false
        ? requestData!.requests[0].status
        : 'approved';

    final Map<String, dynamic> body = {
      'date': _formatDate(day),
      'start_time': startTime,
      'end_time': endTime,
      'price': widget.price,
      'service_id': serviceId,
      'status': status,
      'user_id': userId,
    };

    print('Request payload: $body'); // Print the JSON payload here

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Request created successfully');
      } else {
        print('Failed to make request. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error making request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
          controller: _tabController,
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
                    color: _selectedTabIndex == _next7Days.indexOf(day)
                        ? Colors.green
                        : const Color(0xFF6E8BB7),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _next7Days.map((day) {
          return _buildTabContentForDate(day);
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          postRequest(
            _next7Days[_selectedTabIndex], // Pass the selected day
            '18:00',
            '19:00',
            widget.serviceId,
            widget.userId, // Pass the userId here
          );
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    List<RequestElement> requestsForDay = requestData?.requests
            .where((request) =>
                request.date.year == day.year &&
                request.date.month == day.month &&
                request.date.day == day.day)
            .toList() ??
        [];

    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight / 20),
          ...requestsForDay.map((request) {
            return Container(
              margin: EdgeInsets.only(
                  right: screenWidth / 40, left: screenWidth / 40),
              height: screenHeight / 14,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF2F4F7),
              ),
              child: Row(
                children: [
                  SizedBox(width: screenWidth / 30),
                  Text(
                    '${request.startTime} - ${request.endTime} ',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: screenHeight / 45,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        checkbox = !checkbox;
                      });
                    },
                    icon: Icon(
                      checkbox
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                      color: checkbox ? Colors.white : Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
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
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
