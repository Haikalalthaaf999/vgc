import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgc/models/film/tambah.dart';

class PickImagePage extends StatefulWidget {
  const PickImagePage({super.key});

  @override
  State<PickImagePage> createState() => _PickImagePageState();
}

class _PickImagePageState extends State<PickImagePage> {
  File? _image;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final imagePath = pickedFile.path;

      final newMovie = TambahData(
        title: _titleController.text,
        description: _descriptionController.text,
        genre: _genreController.text,
        image: imagePath, // <= ini penting
      );

      Navigator.pop(context, newMovie);
    }
  }

  Future<TambahData?> uploadFilmToApi(TambahData film, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse('https://appbioskop.mobileprojp.com/api/films');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    // FIX: Cek null
    request.fields['title'] = film.title ?? '';
    request.fields['description'] = film.description ?? '';
    request.fields['genre'] = film.genre ?? '';

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(respStr);
      print("RESPON DARI API: $decoded");
      return TambahData.fromJson(decoded['data']);
    } else {
      print("Error Response: $respStr");
      return null;
    }
  }

  void _submit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _genreController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field dan gambar wajib diisi")),
      );
      return;
    }

    final movieToUpload = TambahData(
      title: _titleController.text,
      description: _descriptionController.text,
      genre: _genreController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: 0,
    );

    final uploadedMovie = await uploadFilmToApi(movieToUpload, _image!);

    if (uploadedMovie != null) {
      final updatedMovie = uploadedMovie.copyWith(image: _image!.path);
      Navigator.pop(context, updatedMovie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Film Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 100),
                  ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Pilih dari Gallery"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Film',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _genreController,
              decoration: const InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text("Simpan Film"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
