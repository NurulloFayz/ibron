import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../controller/request_controller.dart';

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
  late Map<String, bool> _selectedTimeSlots;

  @override
  void initState() {
    super.initState();
    _freeTimesForDate = {};
    _next7Days = _calculateNext7Days();
    _selectedTabIndex = 0;
    _selectedTimeSlots = {};
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

    // Start from the day before today
    DateTime startDate = now.subtract(Duration(days: 1));
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
    DateTime selectedDate = _next7Days[_selectedTabIndex];

    for (var entry in _selectedTimeSlots.entries) {
      if (entry.value) {
        List<String> times = entry.key.split(" - ");
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
          await _apiService.postRequest(requestData);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request sent successfully!')));
        } catch (e) {
          print('Error sending request: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send request.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Time'),
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
        onPressed: _sendPostRequest,
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Tasdiqlash',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
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
      return ListView.builder(
        itemCount: freeTimes.length,
        itemBuilder: (context, index) {
          final freeTime = freeTimes[index];
          final timeSlot = '${freeTime.startTime} - ${freeTime.endTime}';
          final isSelected = _selectedTimeSlots[timeSlot] ?? false;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(screenHeight / 100),
                child: Container(
                  height: screenHeight / 16,
                  width: screenWidth / 1.1,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth / 40,),
                      Text('${_formatDateForDisplay(day)} $timeSlot',
                        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 50,fontWeight: FontWeight.w400)),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedTimeSlots[timeSlot] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  String _formatDateForDisplay(DateTime date) {
    final uzbekWeekdays = ['Yak', 'Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan'];
    return '${_addLeadingZero(date.day)} ${uzbekWeekdays[date.weekday % 7]}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
