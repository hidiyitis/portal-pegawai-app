import 'package:equatable/equatable.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';

abstract class CutiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CutiInitial extends CutiState {}

class CutiLoading extends CutiState {}

// Replacement for KuotaCutiLoaded and DaftarCutiLoaded - combined state
class CutiDataLoaded extends CutiState {
  final KuotaCutiEntity kuotaCuti;
  final List<CutiEntity> daftarCuti;
  final String filter;

  CutiDataLoaded({
    required this.kuotaCuti,
    required this.daftarCuti,
    required this.filter,
  });

  @override
  List<Object?> get props => [kuotaCuti, daftarCuti, filter];
}

// Keep these for backward compatibility
class KuotaCutiLoaded extends CutiState {
  final KuotaCutiEntity kuotaCuti;

  KuotaCutiLoaded(this.kuotaCuti);

  @override
  List<Object?> get props => [kuotaCuti];
}

class DaftarCutiLoaded extends CutiState {
  final List<CutiEntity> daftarCuti;
  final String filter;

  DaftarCutiLoaded(this.daftarCuti, this.filter);

  @override
  List<Object?> get props => [daftarCuti, filter];
}

class DaftarManagerLoaded extends CutiState {
  final List<ManagerEntity> daftarManager;

  DaftarManagerLoaded(this.daftarManager);

  @override
  List<Object?> get props => [daftarManager];
}

class FormCutiError extends CutiState {
  final String message;

  FormCutiError(this.message);

  @override
  List<Object?> get props => [message];
}

class CutiSubmitSuccess extends CutiState {
  final CutiEntity cuti;

  CutiSubmitSuccess(this.cuti);

  @override
  List<Object?> get props => [cuti];
}
