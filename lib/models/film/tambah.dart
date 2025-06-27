// To parse this JSON data, do
//
//     final addMovieResponse = addMovieResponseFromJson(jsonString);

import 'dart:convert';

AddMovieResponse addMovieResponseFromJson(String str) =>
    AddMovieResponse.fromJson(json.decode(str));

String addMovieResponseToJson(AddMovieResponse data) =>
    json.encode(data.toJson());

class AddMovieResponse {
  String title;
  String description;
  String genre;
  String director;
  String writer;
  String stats;
  String imageBase64;

  AddMovieResponse({
    required this.title,
    required this.description,
    required this.genre,
    required this.director,
    required this.writer,
    required this.stats,
    required this.imageBase64,
  });

  factory AddMovieResponse.fromJson(Map<String, dynamic> json) =>
      AddMovieResponse(
        title: json["title"],
        description: json["description"],
        genre: json["genre"],
        director: json["director"],
        writer: json["writer"],
        stats: json["stats"],
        imageBase64: json["image_base64"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "genre": genre,
    "director": director,
    "writer": writer,
    "stats": stats,
    "image_base64": imageBase64,
  };
}