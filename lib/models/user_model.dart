// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String firstName;
  String lastName;
  DateTime birthday;
  String gender;
  String phoneNumber;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthday: DateTime.parse(json["birthday"]),
    gender: json["gender"],
    phoneNumber: json["phone_number"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "phone_number": phoneNumber,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
