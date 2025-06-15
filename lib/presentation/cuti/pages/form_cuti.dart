import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart'; // Package khusus untuk file picking
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_cubit.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';

class FormCutiPage extends StatefulWidget {
  const FormCutiPage({Key? key}) : super(key: key);

  @override
  _FormCutiPageState createState() => _FormCutiPageState();
}

class _FormCutiPageState extends State<FormCutiPage> {
  // Controllers untuk mengelola input text pada form
  final _formKey = GlobalKey<FormState>();
  final _kegiatanController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();
  final _catatanController = TextEditingController();

  // State variables untuk menyimpan pilihan user
  UserModel? _selectedManager;

  // Perubahan penting: kita gunakan PlatformFile untuk file handling yang lebih robust
  // PlatformFile memberikan informasi lebih lengkap tentang file yang dipilih
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  late CutiCubit _cutiCubit;

  // DateTime objects untuk menyimpan tanggal yang dipilih
  DateTime? _startDate;
  DateTime? _endDate;

  // Flag untuk tracking apakah user sudah mencoba submit
  // Ini membantu kita menampilkan error message pada waktu yang tepat
  bool _hasAttemptedSubmit = false;

  @override
  void dispose() {
    // Bersihkan resources ketika widget dihancurkan
    _kegiatanController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Formulir Cuti',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider<CutiCubit>(
        create: (context) {
          _cutiCubit = CutiCubit(cutiRepository: getIt());
          _cutiCubit.getDaftarManager();
          return _cutiCubit;
        },
        child: BlocConsumer<CutiCubit, CutiState>(
          listener: (context, state) {
            if (state is CutiSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pengajuan cuti berhasil dikirim')),
              );
              Navigator.of(context).pop();
            } else if (state is FormCutiError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              setState(() {
                _isLoading = false;
              });
            }
          },
          builder: (context, state) {
            if (state is DaftarManagerLoaded) {
              return _buildForm(context, state.daftarManager);
            } else if (state is FormCutiError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cutiCubit.getDaftarManager(),
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else {
              return _buildForm(context, []);
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<UserModel> daftarManager) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field untuk nama kegiatan cuti
            _buildFieldLabel('Kegiatan', isRequired: true),
            SizedBox(height: 8),
            TextFormField(
              controller: _kegiatanController,
              decoration: InputDecoration(
                hintText: 'Nama Kegiatan (contoh: Cuti Menikah)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama kegiatan tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Field untuk tanggal mulai cuti
            _buildFieldLabel('Tanggal Mulai Cuti', isRequired: true),
            SizedBox(height: 8),
            TextFormField(
              controller: _tanggalMulaiController,
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectStartDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal mulai tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Field untuk tanggal selesai cuti
            _buildFieldLabel('Tanggal Selesai Cuti', isRequired: true),
            SizedBox(height: 8),
            TextFormField(
              controller: _tanggalSelesaiController,
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectEndDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal selesai tidak boleh kosong';
                }
                if (_startDate != null && _endDate != null) {
                  if (_endDate!.isBefore(_startDate!)) {
                    return 'Tanggal selesai harus setelah tanggal mulai';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Dropdown untuk memilih manager
            _buildFieldLabel('Manager', isRequired: true),
            SizedBox(height: 8),
            DropdownButtonFormField<UserModel>(
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Pilih Manager',
                border: OutlineInputBorder(),
              ),
              value: _selectedManager,
              items:
                  daftarManager.map((manager) {
                    return DropdownMenuItem<UserModel>(
                      value: manager,
                      child: Text('${manager.name} - ${manager.role}'),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedManager = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Manager tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Section untuk lampiran file - SEKARANG WAJIB
            _buildFieldLabel('Lampiran', isRequired: true),
            SizedBox(height: 4),
            Text(
              'Upload file pendukung (PDF/DOCX)',
              style: TextStyle(
                color: AppColors.onSecondary,
                fontSize: AppTextSize.bodySmall,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),

            // Container untuk file picker dengan styling yang menunjukkan required field
            InkWell(
              onTap: _pickDocumentFile,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  // Border warna berubah tergantung status file dan validasi
                  border: Border.all(
                    color: _getFilePickerBorderColor(),
                    width: _selectedFile != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  // Background color yang subtle untuk menunjukkan status
                  color:
                      _selectedFile != null
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedFile != null
                          ? Icons
                              .description // Icon dokumen untuk file yang sudah dipilih
                          : Icons.upload_file,
                      color:
                          _selectedFile != null
                              ? AppColors.primary
                              : Colors.grey,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedFile?.name ??
                                'Pilih File Dokumen (PDF/DOCX)',
                            style: TextStyle(
                              color:
                                  _selectedFile != null
                                      ? AppColors.onPrimary
                                      : Colors.grey[600],
                              fontWeight:
                                  _selectedFile != null
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Tampilkan informasi tambahan file jika sudah dipilih
                          if (_selectedFile != null) ...[
                            SizedBox(height: 4),
                            Text(
                              '${_getFileSizeString(_selectedFile!.size)} • ${_selectedFile!.extension?.toUpperCase()}',
                              style: TextStyle(
                                color: AppColors.onSecondary,
                                fontSize: AppTextSize.bodySmall,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_selectedFile != null)
                      IconButton(
                        icon: Icon(Icons.close, size: 20, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedFile = null;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Error message untuk lampiran jika belum dipilih setelah attempt submit
            if (_hasAttemptedSubmit && _selectedFile == null)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  'Lampiran tidak boleh kosong',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: AppTextSize.bodySmall,
                  ),
                ),
              ),
            SizedBox(height: 16),

            // Field untuk catatan tambahan - tetap opsional
            _buildFieldLabel('Catatan', isRequired: false),
            SizedBox(height: 8),
            TextFormField(
              controller: _catatanController,
              decoration: InputDecoration(
                hintText: 'Tambahan keterangan (opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 32),

            // Tombol submit
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isLoading ? null : () => _submitForm(context),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: AppTextSize.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membuat label field dengan indikator required
  // Method ini membantu konsistensi visual dalam menunjukkan field mana yang wajib
  Widget _buildFieldLabel(String text, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppTextSize.bodyMedium,
          ),
        ),
        if (isRequired) ...[
          SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: AppTextSize.bodyMedium,
            ),
          ),
        ],
      ],
    );
  }

  // Method untuk menentukan warna border file picker berdasarkan status
  Color _getFilePickerBorderColor() {
    if (_selectedFile != null) {
      return AppColors.primary; // Hijau jika file sudah dipilih
    } else if (_hasAttemptedSubmit) {
      return Colors
          .red; // Merah jika sudah attempt submit tapi belum pilih file
    } else {
      return AppColors.onSurface; // Abu-abu default
    }
  }

  // Helper method untuk format ukuran file yang user-friendly
  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Method untuk memilih tanggal mulai
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _tanggalMulaiController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // Method untuk memilih tanggal selesai
  Future<void> _selectEndDate(BuildContext context) async {
    DateTime firstDate = _startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _tanggalSelesaiController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // Method yang diperbaharui untuk memilih file dokumen dengan file_picker
  // File picker memberikan kontrol yang lebih baik untuk filtering jenis file
  Future<void> _pickDocumentFile() async {
    try {
      // Gunakan file_picker dengan filter khusus untuk PDF dan DOCX
      // allowedExtensions memastikan hanya file yang diinginkan yang bisa dipilih
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx'], // Hanya PDF dan DOCX yang diizinkan
        allowMultiple: false, // Hanya satu file yang bisa dipilih
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Validasi ukuran file (maksimal 5MB)
        // Validasi ini penting untuk memastikan performa upload yang baik
        if (file.size > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ukuran file terlalu besar (maksimal 5MB)'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Validasi tambahan untuk memastikan file memiliki path yang valid
        if (file.path == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File tidak dapat diakses, silakan coba lagi'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _selectedFile = file;
          // Reset flag attempt submit karena user sudah memilih file
          if (_hasAttemptedSubmit) {
            _hasAttemptedSubmit = false;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File berhasil dipilih: ${file.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih file: ${e.toString()}')),
      );
    }
  }

  // Method submit yang diperbaharui dengan validasi lampiran wajib
  void _submitForm(BuildContext context) {
    // Set flag bahwa user sudah mencoba submit
    // Ini memungkinkan kita menampilkan error message untuk lampiran
    setState(() {
      _hasAttemptedSubmit = true;
    });

    // Validasi form standar dan validasi lampiran
    bool isFormValid = _formKey.currentState!.validate();
    bool isFileSelected = _selectedFile != null;

    // Jika semua validasi lolos, lanjutkan submit
    if (isFormValid && isFileSelected) {
      setState(() {
        _isLoading = true;
      });

      // Konversi PlatformFile ke XFile untuk compatibility dengan existing code
      // XFile adalah format yang diharapkan oleh backend integration layer
      XFile attachmentFile = XFile(_selectedFile!.path!);

      String startDateIso = _startDate!.toUtc().toIso8601String();
      String endDateIso = _endDate!.toUtc().toIso8601String();

      _cutiCubit.ajukanCuti(
        kegiatan: _kegiatanController.text,
        tanggalMulai: startDateIso,
        tanggalSelesai: endDateIso,
        managerId: _selectedManager!.nip,
        catatan:
            _catatanController.text.isNotEmpty ? _catatanController.text : null,
        attachmentFile: attachmentFile, // File sekarang wajib ada
      );
    } else {
      // Trigger rebuild untuk menampilkan error messages
      setState(() {});

      // Berikan feedback kepada user tentang field yang belum diisi
      String errorMessage = 'Mohon lengkapi semua field yang wajib diisi';
      if (!isFileSelected) {
        errorMessage += ', termasuk lampiran dokumen';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
