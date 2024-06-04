class Request {
  String id;
  String serviceId;
  String userId;
  String clientId;
  String userName;
  String startTime;
  String endTime;
  int price;
  String status;
  String date;
  String day;
  Service service;
  int duration;
  String createdAt;

  Request({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.clientId,
    required this.userName,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.date,
    required this.day,
    required this.service,
    required this.duration,
    required this.createdAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      serviceId: json['service_id'],
      userId: json['user_id'],
      clientId: json['client_id'],
      userName: json['user_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      price: json['price'],
      status: json['status'],
      date: json['date'],
      day: json['day'],
      service: Service.fromJson(json['service']),
      duration: json['duration'],
      createdAt: json['created_at'],
    );
  }
}

class Service {
  String id;
  String categoryId;
  String businessMerchantId;
  String name;
  int duration;
  int price;
  String address;
  double latitude;
  double longitude;
  List<Url> url;
  List<Amenity> amenities;
  String createdAt;

  Service({
    required this.id,
    required this.categoryId,
    required this.businessMerchantId,
    required this.name,
    required this.duration,
    required this.price,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.url,
    required this.amenities,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      categoryId: json['category_id'],
      businessMerchantId: json['business_merchant_id'],
      name: json['name'],
      duration: json['duration'],
      price: json['price'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      url: List<Url>.from(json['url'].map((x) => Url.fromJson(x))),
      amenities: List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))),
      createdAt: json['created_at'],
    );
  }
}

class Url {
  String url;

  Url({required this.url});

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      url: json['url'],
    );
  }
}

class Amenity {
  String id;
  String name;
  String url;
  String createdAt;
  String updatedAt;

  Amenity({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
