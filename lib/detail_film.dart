import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vgc/models/film/list_jadwal.dart';
import 'package:vgc/api/api.dart';

class MovieDetailPage extends StatefulWidget {
  final int filmId;
  final String title;
  final String imageUrl;
  final String releaseDate;
  final String duration;
  final double rating;
  final String synopsis;

  const MovieDetailPage({
    super.key,
    required this.filmId,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.duration,
    required this.rating,
    required this.synopsis,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JadwalDatum> _jadwalList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadJadwal();
  }

  void loadJadwal() async {
    try {
      final jadwal = await AuthApi.fetchJadwal(widget.filmId);
      setState(() {
        _jadwalList = jadwal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xff011245),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(widget.imageUrl, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrl,
                        width: 90,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.releaseDate} · ${widget.duration}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                size: 18,
                                color: index < widget.rating.round()
                                    ? Colors.yellow
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            color: const Color(0xff011245),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.yellow,
              tabs: const [
                Tab(text: 'SINOPSIS'),
                Tab(text: 'JADWAL'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.synopsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _jadwalList.isEmpty
                    ? const Center(
                        child: Text(
                          "Jadwal belum tersedia",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _jadwalList.length,
                        itemBuilder: (context, index) {
                          final jadwal = _jadwalList[index];
                          final startTime = jadwal.startTime;

                          return ListTile(
                            title: Text(
                              "Jam: ${startTime != null ? timeFormat.format(startTime.toLocal()) : '--:--'}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Tanggal: ${startTime != null ? dateFormat.format(startTime.toLocal()) : '--'}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
