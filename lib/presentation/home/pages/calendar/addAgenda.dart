import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_images.dart';

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

  final List<String> partisipanOptions = ['Tutus', 'Yobel', 'Jay'];
  List<String> selectedPartisipan = [];

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

  void _showPartisipanSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pilih Partisipan",
                    style: TextStyle(
                      fontSize: AppTextSize.headingSmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: partisipanOptions.length,
                    itemBuilder: (context, index) {
                      String name = partisipanOptions[index];
                      bool isSelected = selectedPartisipan.contains(name);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setModalState(() {
                            if (value == true) {
                              selectedPartisipan.add(name);
                            } else {
                              selectedPartisipan.remove(name);
                            }
                          });
                          setState(() {});
                        },
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: AppTextSize.bodyMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        secondary: CircleAvatar(
                          backgroundImage: AssetImage(AppImages.defaultProfile),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.bodyMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitAgenda() {
    print("Kegiatan: ${_kegiatanController.text}");
    print("Waktu: ${_waktuController.text}");
    print("Tempat: ${_tempatController.text}");
    print("Partisipan: $selectedPartisipan");
    print("Catatan: ${_catatanController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Agenda',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppTextSize.headingSmall,
            color: AppColors.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: AppColors.onPrimary,
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextLabel("Kegiatan"),
            TextField(
              controller: _kegiatanController,
              decoration: const InputDecoration(hintText: 'Nama Kegiatan'),
            ),
            const SizedBox(height: 16),
            _buildTextLabel("Waktu"),
            TextField(
              controller: _waktuController,
              readOnly: true,
              onTap: _selectTime,
              decoration: const InputDecoration(hintText: '--:--'),
            ),
            const SizedBox(height: 16),
            _buildTextLabel("Tempat"),
            TextField(
              controller: _tempatController,
              decoration: const InputDecoration(hintText: 'Lokasi'),
            ),
            const SizedBox(height: 16),
            _buildTextLabel("Partisipan"),
            GestureDetector(
              onTap: _showPartisipanSelector,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedPartisipan.isEmpty
                      ? "Pilih Partisipan"
                      : selectedPartisipan.join(', '),
                  style: TextStyle(
                    fontSize: AppTextSize.bodyMedium,
                    color:
                        selectedPartisipan.isEmpty
                            ? AppColors.onSecondary
                            : AppColors.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextLabel("Catatan", optional: true),
            TextField(
              controller: _catatanController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Tambahan'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitAgenda,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                "Selesai",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextSize.bodyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppTextSize.bodyLarge,
              color: AppColors.onPrimary,
            ),
          ),
          if (optional) const SizedBox(width: 6),
          if (optional)
            const Text(
              "*Optional",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
