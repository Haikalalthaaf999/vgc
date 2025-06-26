// To parse this JSON data, do:
// final listJadwal = listJadwalFromJson(jsonString);

import 'dart:convert';

ListJadwal listJadwalFromJson(String str) =>
    ListJadwal.fromJson(json.decode(str));

String listJadwalToJson(ListJadwal data) => json.encode(data.toJson());

class ListJadwal {
  String message;
  List<JadwalDatum> data;

  ListJadwal({required this.message, required this.data});

  factory ListJadwal.fromJson(Map<String, dynamic> json) => ListJadwal(
    message: json["message"] ?? "",
    data: json["data"] != null
        ? List<JadwalDatum>.from(
            json["data"].map((x) => JadwalDatum.fromJson(x)),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class JadwalDatum {
  int? id;
  int? filmId;
  DateTime? startTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  Film? film;

  JadwalDatum({
    this.id,
    this.filmId,
    this.startTime,
    this.createdAt,
    this.updatedAt,
    this.film,
  });

  factory JadwalDatum.fromJson(Map<String, dynamic> json) => JadwalDatum(
    id: json["id"],
    filmId: json["film_id"],
    startTime: json["start_time"] != null
        ? DateTime.tryParse(json["start_time"])
        : null,
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
    film: json["film"] != null ? Film.fromJson(json["film"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "film_id": filmId,
    "start_time": startTime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "film": film?.toJson(),
  };
}

class Film {
  final int? id;
  final String? title;
  final String? description;
  final String? genre;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Film({
    this.id,
    this.title,
    this.description,
    this.genre,
    this.createdAt,
    this.updatedAt,
  });

  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    genre: json["genre"],
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "genre": genre,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
