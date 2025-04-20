import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_cubit.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/cuti_item_widget.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/kuota_cuti_card_widget.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/status_filter_widget.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';

class PengajuanCutiPage extends StatefulWidget {
  const PengajuanCutiPage({super.key});

  @override
  _PengajuanCutiPageState createState() => _PengajuanCutiPageState();
}

class _PengajuanCutiPageState extends State<PengajuanCutiPage> {
  String _currentFilter = 'semua';
  late CutiCubit _cutiCubit;

  @override
  void initState() {
    super.initState();
    _currentFilter = 'semua';
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
          'Pengajuan Cuti',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider<CutiCubit>(
        create: (context) {
          _cutiCubit = CutiCubit(cutiRepository: getIt());
          _cutiCubit.loadAllData(filter: _currentFilter);
          return _cutiCubit;
        },
        child: BlocBuilder<CutiCubit, CutiState>(
          builder: (context, state) {
            if (state is CutiLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FormCutiError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => _cutiCubit.loadAllData(filter: _currentFilter),
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (state is CutiDataLoaded) {
              return _buildContent(
                context,
                state.kuotaCuti.total,
                state.kuotaCuti.dalamPengajuan,
                state.kuotaCuti.ditolak,
                state.kuotaCuti.disetujui,
                state.daftarCuti,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    int kuotaTotal,
    int dalamPengajuan,
    int ditolak,
    int disetujui,
    List<CutiEntity> daftarCuti,
  ) {
    return Column(
      children: [
        //detail cuti
        KuotaCutiCardWidget(
          kuotaTotal: kuotaTotal,
          dalamPengajuan: dalamPengajuan,
          ditolak: ditolak,
          disetujui: disetujui,
          onAjukanPressed: () {
            Navigator.of(context).pushNamed(RoutesName.formCuti).then((_) {
              _cutiCubit.loadAllData(filter: _currentFilter);
            });
          },
        ),

        // status
        StatusFilterWidget(
          currentFilter: _currentFilter,
          onFilterChanged: (filter) {
            setState(() {
              _currentFilter = filter;
            });
            _cutiCubit.loadAllData(filter: _currentFilter);
          },
        ),

        // riwayat cuti
        Expanded(
          child:
              daftarCuti.isEmpty
                  ? _buildEmptyState()
                  : _buildCutiList(daftarCuti),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_state.png',
            width: 150,
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.work_off_outlined,
                size: 80,
                color: AppColors.primary,
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada pengajuan',
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: AppTextSize.bodyLarge,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCutiList(List<CutiEntity> daftarCuti) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: daftarCuti.length,
      itemBuilder: (context, index) {
        final cuti = daftarCuti[index];
        return CutiItemWidget(
          cuti: cuti,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detail untuk cuti ID: ${cuti.id}')),
            );
          },
        );
      },
    );
  }
}
