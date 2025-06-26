import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/film/tambah.dart';

class FilmService {
  static Future<List<TambahData>> fetchAllMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse('https://appbioskop.mobileprojp.com/api/films'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => TambahData.fromJson(item)).toList();
    } else {
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Gagal mengambil film');
    }
  }
}
