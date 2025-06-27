// To parse this JSON data, do
//
//     final tambahJadwal = tambahJadwalFromJson(jsonString);

import 'dart:convert';

TambahJadwal tambahJadwalFromJson(String str) =>
    TambahJadwal.fromJson(json.decode(str));

String tambahJadwalToJson(TambahJadwal data) => json.encode(data.toJson());

class TambahJadwal {
  String message;
  JadwalData data;

  TambahJadwal({required this.message, required this.data});

  factory TambahJadwal.fromJson(Map<String, dynamic> json) =>
      TambahJadwal(message: json["message"], data: JadwalData.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class JadwalData {
  int filmId;
  DateTime startTime;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  JadwalData({
    required this.filmId,
    required this.startTime,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory JadwalData.fromJson(Map<String, dynamic> json) => JadwalData(
    filmId: json["film_id"],
    startTime: DateTime.parse(json["start_time"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "film_id": filmId,
    "start_time": startTime.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
