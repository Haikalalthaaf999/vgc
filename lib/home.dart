import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgc/detail_film.dart';
import 'package:vgc/models/film/tambah.dart';
import 'package:vgc/src/bottom.dart';
import 'package:vgc/tambah_film.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<TambahData> allMovies = [];

  final List<Map<String, dynamic>> movieImages = [
    {
      'id': 1,
      'title': 'Inside Out 2',
      'imageUrl':
          'https://i.pinimg.com/736x/7a/5c/f7/7a5cf71a89266b24ec1c0fe647d69037.jpg',
      'releaseDate': '27 Februari 2020',
      'duration': '1j 29m',
      'rating': 4.0,
      'synopsis': 'Film Inside Out 2 menceritakan Riley yang beranjak remaja dan menghadapi berbagai perubahan emosi. Emosi-emosi baru seperti Anxiety (Kecemasan), Envy (Iri), Ennui (Jenuh), dan Embarrassment (Malu) muncul dan mengganggu emosi inti Riley (Joy, Sadness, Anger, Disgust, dan Fear).',
    },
    {
      'id': 2,
      'title': 'Spider-Man: No Way Home',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/en/0/00/Spider-Man_No_Way_Home_poster.jpg',
      'releaseDate': '17 Desember 2021',
      'duration': '2j 28m',
      'rating': 4.5,
      'synopsis':
          'Peter Parker menghadapi kekacauan multiverse setelah identitasnya terbongkar.',
    },
    {
      'id': 3,
      'title': 'Doctor Strange Multiverse of Madness',
      'imageUrl':
          'https://i.pinimg.com/736x/68/6e/f1/686ef19247330b0530f17b65f1e7541f.jpg',
      'releaseDate': '26 Juni 2019',
      'duration': '1j 46m',
      'rating': 3.9,
      'synopsis':
          'Dokter Strange menghadapi kekacauan multiverse setelah identitasnya terbongkar. Mereka harus mengumpulkan semua kekuatan untuk menghindari kekacauan yang lebih besar dari sebelumnya.',
    },
    {
      'id': 4,
      'title': 'Sonic the Hedgehog 2',
      'imageUrl':
          'https://i.pinimg.com/736x/c3/ea/27/c3ea276736f2424ad341f5bef3349bb4.jpg',
      'releaseDate': '19 Juli 2013',
      'duration': '1j 52m',
      'rating': 4.3,
      'synopsis':
          'Sonic menghadapi kekacauan multiverse setelah identitasnya terbongkar.',
    },
    {
      'id': 5,
      'title': '24H Limit',
      'imageUrl':
          'https://i.pinimg.com/736x/28/8b/b2/288bb226c16be6d37ad95576ab95bafc.jpg',
      'releaseDate': '1 April 2011',
      'duration': '1j 43m',
      'rating': 4.0,
      'synopsis':
          'seorang mantan pemburu bayaran yang ingin hidup damai. Mereka harus mengumpulkan semua kekuatan untuk menghindari kekacauan yang lebih besar dari sebelumnya.',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      final movies = await fetchAllMoviesFromApi();
      setState(() {
        allMovies = movies;
      });
    } catch (e) {
      debugPrint("Error loadMovies: $e");
    }
  }

Future<List<TambahData>> fetchAllMoviesFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await http.get(
      Uri.parse('https://appbioskop.mobileprojp.com/api/films'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    // Tambahkan log ini 👇
    print("=== RESPONSE STATUS: ${response.statusCode}");
    print("=== RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic> && jsonData['data'] is List) {
        final List<dynamic> data = jsonData['data'];
        return data.map((e) => TambahData.fromJson(e)).toList();
      } else {
        throw Exception("Format data API tidak sesuai.");
      }
    } else {
      throw Exception("Gagal mengambil film");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9FB3DF),
      appBar: AppBar(
        title: const Text("Choose Movie"),
        backgroundColor: const Color(0xff9FB3DF),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              searchBar(),
              const SizedBox(height: 24),
              sectionTitle("Now Playing"),
              const SizedBox(height: 12),
              carouselSlider(),
              const SizedBox(height: 24),
              buildMovieSection("Top Movies", movieImages),
              const SizedBox(height: 24),
              sectionTitle('All Movies'),
              const SizedBox(height: 12),
              buildAllMovies(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMovie = await Navigator.push<TambahData?>(
            context,
            MaterialPageRoute(builder: (_) =>  PickImagePage()),
          );

          if (newMovie != null) {
            setState(() {
              allMovies.add(newMovie);
            });
          }
        },
        backgroundColor: const Color(0xffFFF1D5),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home, size: 24.0),
          Icon(Icons.confirmation_number, size: 24.0),
          Icon(Icons.history, size: 24.0),
          Icon(Icons.person, size: 24.0),
        ],
        index: _selectedIndex,
        color: const Color(0xffFFF1D5),
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color(0xff9FB3DF),
        height: 75.0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget searchBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        icon: Icon(Icons.search, color: Colors.white),
        suffixIcon: Icon(Icons.mic, color: Colors.white),
      ),
    ),
  );

  Widget sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget carouselSlider() => CarouselSlider(
    items: movieImages.map((movie) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.network(movie['imageUrl'], fit: BoxFit.cover),
        ),
      );
    }).toList(),
    options: CarouselOptions(
      height: 200,
      enlargeCenterPage: true,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      viewportFraction: 0.35,
      enableInfiniteScroll: true,
    ),
  );

  Widget buildMovieSection(String title, List<Map<String, dynamic>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(
                        filmId: movie['id'],
                        title: movie['title'],
                        imageUrl: movie['imageUrl'],
                        releaseDate: movie['releaseDate'],
                        duration: movie['duration'],
                        rating: movie['rating'],
                        synopsis: movie['synopsis'],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie['imageUrl'],
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildAllMovies() {
  if (allMovies.isEmpty) {
    return const Text(
      "Belum ada film ditambahkan.",
      style: TextStyle(color: Colors.white70),
    );
  }

  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(), // untuk scroll tidak konflik
    shrinkWrap: true,
    itemCount: allMovies.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 3 kolom
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.6, // tinggi gambar lebih panjang
    ),
    itemBuilder: (context, index) {
      final movie = allMovies[index];
      final imageUrl =
          movie.imageUrl ??
          (movie.image != null && movie.image!.startsWith('films/')
              ? 'https://appbioskop.mobileprojp.com/public/${movie.image}'
              : '');

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(
                filmId: movie.id ?? 0,
                title: movie.title ?? 'Unknown',
                imageUrl: imageUrl,
                releaseDate: 'Unknown',
                duration: '1j 29m',
                rating: 4.0,
                synopsis: 'Sinopsis tidak tersedia.',
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 140,
                            child: Center(child: Icon(Icons.broken_image)),
                          );
                        },
                      )
                    : const SizedBox(
                        height: 140,
                        child: Center(child: Icon(Icons.image_not_supported)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  movie.title ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 4),
                    Text("4.0", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
