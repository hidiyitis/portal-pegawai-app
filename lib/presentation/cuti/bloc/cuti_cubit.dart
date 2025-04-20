import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';

class CutiCubit extends Cubit<CutiState> {
  final CutiRepository cutiRepository;
  KuotaCutiEntity? _kuotaCuti;
  List<CutiEntity>? _daftarCuti;
  String _currentFilter = 'semua';

  CutiCubit({required this.cutiRepository}) : super(CutiInitial());

  Future<void> getKuotaCuti() async {
    try {
      final kuotaCuti = await cutiRepository.getKuotaCuti();
      _kuotaCuti = kuotaCuti;

      // If we already have daftar cuti data, emit combined state
      if (_daftarCuti != null) {
        emit(
          CutiDataLoaded(
            kuotaCuti: kuotaCuti,
            daftarCuti: _daftarCuti!,
            filter: _currentFilter,
          ),
        );
      } else {
        emit(CutiLoading());
      }
    } catch (e) {
      emit(FormCutiError(e.toString()));
    }
  }

  Future<void> getDaftarCuti({required String filter}) async {
    if (state is! CutiDataLoaded) {
      emit(CutiLoading());
    }

    try {
      _currentFilter = filter;
      final daftarCuti = await cutiRepository.getDaftarCuti();

      final filteredList =
          filter == 'semua'
              ? daftarCuti
              : daftarCuti.where((cuti) => cuti.status == filter).toList();

      _daftarCuti = filteredList;

      // If we already have kuota data, emit combined state
      if (_kuotaCuti != null) {
        emit(
          CutiDataLoaded(
            kuotaCuti: _kuotaCuti!,
            daftarCuti: filteredList,
            filter: filter,
          ),
        );
      }
    } catch (e) {
      emit(FormCutiError(e.toString()));
    }
  }

  Future<void> loadAllData({String filter = 'semua'}) async {
    emit(CutiLoading());
    try {
      // Load both data in parallel
      final kuotaFuture = cutiRepository.getKuotaCuti();
      final daftarCutiFuture = cutiRepository.getDaftarCuti();

      final results = await Future.wait([kuotaFuture, daftarCutiFuture]);

      final kuotaCuti = results[0] as KuotaCutiEntity;
      final daftarCutiAll = results[1] as List<CutiEntity>;

      _kuotaCuti = kuotaCuti;

      final filteredList =
          filter == 'semua'
              ? daftarCutiAll
              : daftarCutiAll.where((cuti) => cuti.status == filter).toList();

      _daftarCuti = filteredList;
      _currentFilter = filter;

      emit(
        CutiDataLoaded(
          kuotaCuti: kuotaCuti,
          daftarCuti: filteredList,
          filter: filter,
        ),
      );
    } catch (e) {
      emit(FormCutiError(e.toString()));
    }
  }

  Future<void> getDaftarManager() async {
    emit(CutiLoading());
    try {
      final daftarManager = await cutiRepository.getDaftarManager();
      emit(DaftarManagerLoaded(daftarManager));
    } catch (e) {
      emit(FormCutiError(e.toString()));
    }
  }

  Future<void> ajukanCuti({
    required String kegiatan,
    required String tanggal,
    required int managerId,
    String? lampiran,
    String? catatan,
  }) async {
    emit(CutiLoading());
    try {
      final cuti = await cutiRepository.ajukanCuti(
        kegiatan: kegiatan,
        tanggal: tanggal,
        managerId: managerId,
        lampiran: lampiran,
        catatan: catatan,
      );
      emit(CutiSubmitSuccess(cuti));
    } catch (e) {
      emit(FormCutiError(e.toString()));
    }
  }
}
