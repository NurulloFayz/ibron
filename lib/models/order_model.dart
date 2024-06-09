// order_data.dart

class OrderData {
  final String clientId;
  final String date;
  final String endTime;
  final int price;
  final String serviceId;
  final String startTime;
  final String status;
  final String userId;

  OrderData({
    required this.clientId,
    required this.date,
    required this.endTime,
    required this.price,
    required this.serviceId,
    required this.startTime,
    required this.status,
    required this.userId,
  });
}
