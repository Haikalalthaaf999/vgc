// To parse this JSON data, do
//
//     final deleteTiket = deleteTiketFromJson(jsonString);

import 'dart:convert';

DeleteTiket deleteTiketFromJson(String str) =>
    DeleteTiket.fromJson(json.decode(str));

String deleteTiketToJson(DeleteTiket data) => json.encode(data.toJson());

class DeleteTiket {
  String message;
  dynamic data;

  DeleteTiket({required this.message, required this.data});

  factory DeleteTiket.fromJson(Map<String, dynamic> json) =>
      DeleteTiket(message: json["message"], data: json["data"]);

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}
