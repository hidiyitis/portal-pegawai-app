import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
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
  KuotaCutiEntity? _kuotaCuti;
  List<CutiEntity>? _daftarCuti;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentFilter = 'semua';
    _cutiCubit = CutiCubit(cutiRepository: getIt());
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    _cutiCubit.loadAllData(filter: _currentFilter).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
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
      body: BlocBuilder<CutiCubit, CutiState>(
        bloc: _cutiCubit,
        builder: (context, state) {
          if (state is CutiDataLoaded) {
            _kuotaCuti = state.kuotaCuti;
            _daftarCuti = state.daftarCuti;
          }
          return Column(
            children: [
              KuotaCutiCardWidget(
                kuotaTotal: _kuotaCuti?.total ?? 0,
                dalamPengajuan: _kuotaCuti?.dalamPengajuan ?? 0,
                ditolak: _kuotaCuti?.ditolak ?? 0,
                disetujui: _kuotaCuti?.disetujui ?? 0,
                onAjukanPressed: () {
                  Navigator.of(context).pushNamed(RoutesName.formCuti).then((
                    _,
                  ) {
                    _loadData();
                  });
                },
              ),
              StatusFilterWidget(
                currentFilter: _currentFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _currentFilter = filter;
                  });
                  _loadData();
                },
              ),
              Expanded(child: _buildCutiList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCutiList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_daftarCuti == null || _daftarCuti!.isEmpty) {
      return _buildEmptyState();
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _daftarCuti!.length,
        itemBuilder: (context, index) {
          final cuti = _daftarCuti![index];
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
}
