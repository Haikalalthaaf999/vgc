// To parse this JSON data, do
//
//     final getTiket = getTiketFromJson(jsonString);

import 'dart:convert';

GetTiket getTiketFromJson(String str) => GetTiket.fromJson(json.decode(str));

String getTiketToJson(GetTiket data) => json.encode(data.toJson());

class GetTiket {
  String message;
  List<Datum> data;

  GetTiket({required this.message, required this.data});

  factory GetTiket.fromJson(Map<String, dynamic> json) => GetTiket(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  int userId;
  int scheduleId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  Schedule schedule;

  Datum({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    scheduleId: json["schedule_id"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    schedule: Schedule.fromJson(json["schedule"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "schedule_id": scheduleId,
    "quantity": quantity,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "schedule": schedule.toJson(),
  };
}

class Schedule {
  int id;
  int filmId;
  DateTime startTime;
  DateTime createdAt;
  DateTime updatedAt;
  Film film;

  Schedule({
    required this.id,
    required this.filmId,
    required this.startTime,
    required this.createdAt,
    required this.updatedAt,
    required this.film,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    filmId: json["film_id"],
    startTime: DateTime.parse(json["start_time"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    film: Film.fromJson(json["film"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "film_id": filmId,
    "start_time": startTime.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "film": film.toJson(),
  };
}

class Film {
  int id;
  String title;
  String description;
  String genre;
  DateTime createdAt;
  DateTime updatedAt;

  Film({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    genre: json["genre"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "genre": genre,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
