import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/domain/repositories/user_repository.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_event.dart';
import 'package:get_it/get_it.dart';

class AddAgendaScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddAgendaScreen({super.key, required this.selectedDate});

  @override
  State<AddAgendaScreen> createState() => _AddAgendaScreenState();
}

class _AddAgendaScreenState extends State<AddAgendaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  List<UserModel> allUsers = [];
  List<UserModel> selectedPartisipan = [];
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  void _loadParticipants() async {
    final users = await GetIt.I<UserRepository>().getAllUsers();
    setState(() {
      allUsers = users;
    });
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _waktuController.text = picked.format(context);
      });
    }
  }

  void _submitAgenda() {
    if (_formKey.currentState!.validate()) {
      final date = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        selectedTime?.hour ?? 0,
        selectedTime?.minute ?? 0,
      );

      final newAgenda = AgendasModel(
        title: _kegiatanController.text,
        date: date,
        location: _tempatController.text,
        description: _catatanController.text,
        participants: selectedPartisipan,
        createdBy: 1, // sementara
      );

      context.read<AgendaBloc>().add(AddAgenda(newAgenda));
      Navigator.pop(context);
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
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final user = allUsers[index];
                      final isSelected = selectedPartisipan.any(
                        (u) => u.nip == user.nip,
                      );
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setModalState(() {
                            if (value == true) {
                              selectedPartisipan.add(user);
                            } else {
                              selectedPartisipan.removeWhere(
                                (u) => u.nip == user.nip,
                              );
                            }
                          });
                          setState(() {});
                        },
                        title: Text(user.name),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Selesai'),
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

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat.yMMMMd('id_ID').format(widget.selectedDate);
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
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTextLabel("Tanggal Agenda"),
              TextFormField(
                readOnly: true,
                initialValue: dateText,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextLabel("Kegiatan"),
              TextFormField(
                controller: _kegiatanController,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                decoration: const InputDecoration(hintText: 'Nama Kegiatan'),
              ),
              const SizedBox(height: 16),
              _buildTextLabel("Waktu"),
              TextFormField(
                controller: _waktuController,
                readOnly: true,
                onTap: _selectTime,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                decoration: const InputDecoration(hintText: '--:--'),
              ),
              const SizedBox(height: 16),
              _buildTextLabel("Tempat"),
              TextFormField(
                controller: _tempatController,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
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
                        : selectedPartisipan.map((u) => u.name).join(', '),
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
              TextFormField(
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
      ),
    );
  }
}
