import 'package:flutter/material.dart';

class AddAgendaScreen extends StatefulWidget {
  const AddAgendaScreen({super.key});

  @override
  State<AddAgendaScreen> createState() => _AddAgendaScreenState();
}

class _AddAgendaScreenState extends State<AddAgendaScreen> {
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? _selectedPartisipan;
  final List<String> partisipanOptions = ['Semua', 'Tim A', 'Tim B'];

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _waktuController.text = picked.format(context);
      });
    }
  }

  void _submitAgenda() {
    // TODO: simpan agenda atau kirim ke backend
    print("Kegiatan: ${_kegiatanController.text}");
    print("Waktu: ${_waktuController.text}");
    print("Tempat: ${_tempatController.text}");
    print("Partisipan: $_selectedPartisipan");
    print("Catatan: ${_catatanController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Agenda',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Kegiatan",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _kegiatanController,
              decoration: const InputDecoration(
                hintText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Waktu", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(
              controller: _waktuController,
              readOnly: true,
              onTap: _selectTime,
              decoration: const InputDecoration(
                hintText: '--:--',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Tempat", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(
              controller: _tempatController,
              decoration: const InputDecoration(
                hintText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Partisipan",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedPartisipan,
              items:
                  partisipanOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPartisipan = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Pilih Partisipan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Catatan",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text(
              "*Optional",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _catatanController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tambahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitAgenda,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF00ADB5,
                  ), // ← warna background #00ADB5
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // ← warna teks putih
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
