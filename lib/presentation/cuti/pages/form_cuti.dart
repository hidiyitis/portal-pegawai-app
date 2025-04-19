import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_cubit.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';

class FormCutiPage extends StatefulWidget {
  const FormCutiPage({Key? key}) : super(key: key);

  @override
  _FormCutiPageState createState() => _FormCutiPageState();
}

class _FormCutiPageState extends State<FormCutiPage> {
  final _formKey = GlobalKey<FormState>();
  final _kegiatanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _catatanController = TextEditingController();

  ManagerEntity? _selectedManager;
  String? _selectedLampiran;
  bool _isLoading = false;
  late CutiCubit _cutiCubit;

  @override
  void dispose() {
    _kegiatanController.dispose();
    _tanggalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                SnackBar(
                  content: Text('Pengajuan cuti berhasil dikirim'),
                  backgroundColor: Colors.green,
                ),
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
            } else if (state is CutiLoading) {
              return Center(child: CircularProgressIndicator());
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
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<ManagerEntity> daftarManager) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kegiatan
            Text(
              'Kegiatan',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _kegiatanController,
              decoration: InputDecoration(
                hintText: 'Nama Kegiatan',
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

            // Tanggal
            Text(
              'Tanggal',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _tanggalController,
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _tanggalController.text =
                        '${date.day}/${date.month}/${date.year}';
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Manager
            Text(
              'Manager',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<ManagerEntity>(
              decoration: InputDecoration(
                hintText: 'Pilih Manager',
                border: OutlineInputBorder(),
              ),
              value: _selectedManager,
              items:
                  daftarManager.map((manager) {
                    return DropdownMenuItem<ManagerEntity>(
                      value: manager,
                      child: Text(manager.nama),
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

            // Lampiran
            Text(
              'Lampiran',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '*Optional (Untuk memperkuat alasan cuti anda)',
              style: TextStyle(
                color: AppColors.onSecondary,
                fontSize: AppTextSize.bodySmall,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () {
                // TODO: Implement file picking
                setState(() {
                  _selectedLampiran = 'lampiran.pdf';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('File berhasil ditambahkan')),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.onSurface),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedLampiran != null
                          ? Icons.check_circle
                          : Icons.upload_file,
                      color:
                          _selectedLampiran != null
                              ? AppColors.primary
                              : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _selectedLampiran ?? 'Tambah Lampiran',
                      style: TextStyle(
                        color:
                            _selectedLampiran != null
                                ? AppColors.onPrimary
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Catatan
            Text(
              'Catatan',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '*Optional',
              style: TextStyle(
                color: AppColors.onSecondary,
                fontSize: AppTextSize.bodySmall,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _catatanController,
              decoration: InputDecoration(
                hintText: 'Tambahan',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 32),

            // Button Selesai
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

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _cutiCubit.ajukanCuti(
        kegiatan: _kegiatanController.text,
        tanggal: _tanggalController.text,
        managerId: _selectedManager!.id,
        lampiran: _selectedLampiran,
        catatan:
            _catatanController.text.isNotEmpty ? _catatanController.text : null,
      );
    }
  }
}
