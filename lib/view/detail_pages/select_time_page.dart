import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/request_controller.dart';
import '../../models/order_model.dart';
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
  late ApiService _apiService;
  late List<String> _selectedTimeSlots;

  @override
  void initState() {
    super.initState();
    _next7Days = _calculateNext7Days();
    _selectedTabIndex = 0;
    _selectedTimeSlots = [];
    _tabController = TabController(length: _next7Days.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _apiService = ApiService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  List<DateTime> _calculateNext7Days() {
    final List<DateTime> next7Days = [];
    DateTime now = DateTime.now();

    // Start from the current day
    DateTime startDate = now.subtract(const Duration(days: 0));
    for (int i = 0; i < 7; i++) {
      next7Days.add(startDate.add(Duration(days: i)));
    }
    return next7Days;
  }

  Future<List<FreeTime>> _fetchRequestsForDate(DateTime date) async {
    try {
      final String serviceId = widget.serviceId;
      final String formattedDateForServer =
          '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';
      return _apiService.fetchFreeTimes(serviceId, formattedDateForServer);
    } catch (e) {
      print('Error fetching free times: $e');
      throw e; // Rethrow the error to be caught by FutureBuilder
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
              fontSize: MediaQuery.of(context).size.height / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              labelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 52,
                  fontWeight: FontWeight.w500,
                ),
              ),
              controller: _tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: _next7Days
                  .map((day) => Tab(text: _formatDateForDisplay(day)))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _next7Days.map((day) {
          return FutureBuilder<List<FreeTime>>(
            future: _fetchRequestsForDate(day),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Bo'sh vaqtlar mavjud emas",style: GoogleFonts.roboto(textStyle:TextStyle(
                    fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                  )),),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No free time',style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontSize: screenHeight / 45,fontWeight: FontWeight.w500
                    ))),
                  );
                }
                return _buildGridView(snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green,));
              }
            },
          );
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          _sendPostRequest();
        },
        label: SizedBox(
          width:screenWidth  * .8,
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

  Widget _buildGridView(List<FreeTime> freeTimes) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth / 50,
        mainAxisSpacing: screenHeight / 100,
        childAspectRatio: (screenWidth / 2) / (screenHeight / 17),
      ),
      itemCount: freeTimes.length,
      itemBuilder: (context, index) {
        final freeTime = freeTimes[index];
        final timeSlot = '${freeTime.startTime} - ${freeTime.endTime}';
        final isAvailable = freeTime.status;

        // Check if the current time slot is the start or end time
        bool isStartTime = _selectedTimeSlots.isNotEmpty &&
            _selectedTimeSlots.first == timeSlot;
        bool isEndTime = _selectedTimeSlots.isNotEmpty &&
            _selectedTimeSlots.last == timeSlot;

        // Check if the current time slot is between the start and end time
        bool isBetweenSelected = false;
        if (_selectedTimeSlots.length == 2) {
          String startTime = _selectedTimeSlots.first.split(' - ')[0];
          String endTime = _selectedTimeSlots.last.split(' - ')[1];
          String currentTime = '${freeTime.startTime}:${freeTime.endTime}';
          if (currentTime.compareTo(startTime) > 0 &&
              currentTime.compareTo(endTime) < 0) {
            isBetweenSelected = true;
          }
        }

        bool isSelected = _selectedTimeSlots.contains(timeSlot) ||
            isStartTime ||
            isEndTime ||
            isBetweenSelected;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (!isStartTime && isAvailable) {
                // Prevent deselecting the start time
                if (_selectedTimeSlots.isEmpty ||
                    (isStartTime && _selectedTimeSlots.length == 2)) {
                  // Clear previous selections if a new start time is selected
                  _selectedTimeSlots.clear();
                  _selectedTimeSlots.add(timeSlot);
                } else if (isEndTime) {
                  // If an end time is selected, remove all selections after it
                  _selectedTimeSlots.removeRange(1, _selectedTimeSlots.length);
                } else {
                  // If the current time slot is already selected, deselect it
                  if (_selectedTimeSlots.contains(timeSlot)) {
                    _selectedTimeSlots.remove(timeSlot);
                  } else {
                    _selectedTimeSlots.add(timeSlot);
                  }
                }
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(
                top: screenHeight / 100,
                right: screenWidth / 50,
                left: screenWidth / 50),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green
                  : (isAvailable ? const Color(0xFFF2F4F7) : Colors.grey),
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
  }

  String _formatDateForDisplay(DateTime date) {
    final uzbekWeekdays = ['Yak', 'Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan'];
    DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'bugun';
    } else {
      return '${uzbekWeekdays[date.weekday % 7]} ${(date.day)}';
    }
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> _sendPostRequest() async {
    if (_selectedTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Iltimos vaqtni tanlang',
          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),
        ),
      ));
      return;
    }

    DateTime selectedDate = _next7Days[_selectedTabIndex];

    // Parse the String price to double
    double priceDouble = double.parse(widget.price);

    // Convert the double price to int
    int priceInt = priceDouble.toInt();

    // Create a list of OrderData objects
    List<OrderData> orderDataList = _selectedTimeSlots.map((timeSlot) {
      List<String> times = timeSlot.split(" - ");
      String selectedStartTime = times[0];
      String selectedEndTime = times[1];

      return OrderData(
        date:
            '${selectedDate.year}-${_addLeadingZero(selectedDate.month)}-${_addLeadingZero(selectedDate.day)}',
        endTime: selectedEndTime,
        price: priceInt, // Use the converted price
        serviceId: widget.serviceId,
        startTime: selectedStartTime,
        status: 'approved',
        userId: widget.userId,
        clientId: '', // Provide the appropriate value
      );
    }).toList();

    try {
      // Navigate to OrderPage and pass orderDataList
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPage(requestDataList: orderDataList),
        ),
      );
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send request.')));
    }
  }
}
