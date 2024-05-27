class Request {
  int count;
  List<RequestElement> requests;

  Request({
    required this.count,
    required this.requests,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    count: json["count"],
    requests: List<RequestElement>.from(
        json["requests"].map((x) => RequestElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class RequestElement {
  String id;
  String serviceId;
  String userId;
  String startTime;
  String endTime;
  int price;
  String status;
  DateTime date;
  String createdAt;
  String updatedAt;

  RequestElement({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RequestElement.fromJson(Map<String, dynamic> json) =>
      RequestElement(
        id: json["id"],
        serviceId: json["service_id"],
        userId: json["user_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        price: json["price"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "user_id": userId,
    "start_time": startTime,
    "end_time": endTime,
    "price": price,
    "status": status,
    "date": date.toIso8601String(),
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
