class ScheduleModel {
  final int count;
  final List<ScheduleItem> schedule;

  ScheduleModel({
    required this.count,
    required this.schedule,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      count: json['count'] ?? 0,
      schedule: (json['schedule'] as List<dynamic>)
          .map((item) => ScheduleItem.fromJson(item))
          .toList(),
    );
  }
}

class ScheduleItem {
  final String id;
  final String serviceId;
  final String day;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;

  ScheduleItem({
    required this.id,
    required this.serviceId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] ?? '',
      serviceId: json['service_id'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
