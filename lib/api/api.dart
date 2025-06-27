import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgc/models/film/list.dart';
import 'package:vgc/models/film/list_jadwal.dart';
import 'package:vgc/models/film/tambah_jadwal.dart';
import 'package:vgc/models/login/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:vgc/models/register/register_response.dart';


class AuthApi {
  static const String baseUrl = "https://appbioskop.mobileprojp.com";

  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/login');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final loginData = loginResponseFromJson(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginData.data.token);
      return loginData;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/api/register');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return registerResponseFromJson(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  static Future<List<Datum>> fetchFilms() async {
    final response = await http.get(Uri.parse('$baseUrl/films'));

    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      return ListFilm.fromJson(json.decode(response.body)).data;
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<bool> uploadFilm({
  required String title,
  required String description,
  required String genre,
  required File imageFile,
}) async {
  final uri = Uri.parse('https://appbioskop.mobileprojp.com/api/films');
  final request = http.MultipartRequest('POST', uri);

  request.fields['judul'] = title;
  request.fields['deskripsi'] = description;
  request.fields['genre'] = genre;

  final image = await http.MultipartFile.fromPath('image', imageFile.path);
  request.files.add(image);

  final response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Upload failed: ${response.statusCode}');
    return false;
  }
}


  /// ✅ Tambahkan ini untuk ambil jadwal film berdasarkan filmId
  static Future<List<JadwalDatum>> fetchJadwal(int filmId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/films/jadwal/$filmId'),
    );

    if (response.statusCode == 200) {
      final list = listJadwalFromJson(response.body);
      return list.data;
    } else {
      throw Exception('Gagal memuat jadwal: ${response.statusCode}');
    }
  }
   static Future<TambahJadwal> tambahJadwal(int filmId, DateTime startTime) async {
    final url = Uri.parse('$baseUrl/api/films/jadwal');
    final body = {
      'film_id': filmId.toString(),
      'start_time': DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return TambahJadwal(message: data['message'] ?? 'Berhasil menambahkan jadwal',data: JadwalData.fromJson(data['data']) );
      } else {
        throw Exception('Gagal menambahkan jadwal: ${response.body}');
      } 
    } catch (e) {
      print('ERROR saat menambahkan jadwal: $e');
      rethrow;
    }
  }

}
