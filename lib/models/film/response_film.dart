// To parse this JSON data, do
//
//     final responseFilm = responseFilmFromJson(jsonString);

import 'dart:convert';

ResponseFilm responseFilmFromJson(String str) =>
    ResponseFilm.fromJson(json.decode(str));

String responseFilmToJson(ResponseFilm data) => json.encode(data.toJson());

class ResponseFilm {
  String message;
  List<dynamic> data;

  ResponseFilm({required this.message, required this.data});

  factory ResponseFilm.fromJson(Map<String, dynamic> json) => ResponseFilm(
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
