import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vgc/api/api.dart'; // ganti sesuai path API kamu

class TambahJadwalPage extends StatefulWidget {
  final int filmId;
  const TambahJadwalPage({Key? key, required this.filmId}) : super(key: key);

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final _formKey = GlobalKey<FormState>();
  List<DateTime?> _selectedSchedules = [null, null, null];
  bool _isLoading = false;

  Future<void> _pickDateTime(int index) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedSchedules[index] = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitJadwal() async {
    if (_selectedSchedules.any((dt) => dt == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua jadwal sebelum menyimpan.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      for (var jadwal in _selectedSchedules) {
        await AuthApi.tambahJadwal(widget.filmId, jadwal!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua jadwal berhasil ditambahkan!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan jadwal.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal (3x)'),
        backgroundColor: const Color(0xff011245),
      ),
      backgroundColor: const Color(0xff011245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih 3 Jadwal:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () => _pickDateTime(index),
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    label: Text(
                      _selectedSchedules[index] == null
                          ? 'Pilih Jadwal ${index + 1}'
                          : dateFormat.format(_selectedSchedules[index]!),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _isLoading ? null : _submitJadwal,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Simpan Semua Jadwal'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
