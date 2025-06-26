// To parse this JSON data, do
//
//     final listFilm = listFilmFromJson(jsonString);

import 'dart:convert';

ListFilm listFilmFromJson(String str) => ListFilm.fromJson(json.decode(str));

String listFilmToJson(ListFilm data) => json.encode(data.toJson());

class ListFilm {
  String message;
  List<Datum> data;

  ListFilm({required this.message, required this.data});

  factory ListFilm.fromJson(Map<String, dynamic> json) => ListFilm(
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
  String title;
  String description;
  String genre;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> schedules;

  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.createdAt,
    required this.updatedAt,
    required this.schedules,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    genre: json["genre"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    schedules: List<dynamic>.from(json["schedules"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "genre": genre,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "schedules": List<dynamic>.from(schedules.map((x) => x)),
  };
}
