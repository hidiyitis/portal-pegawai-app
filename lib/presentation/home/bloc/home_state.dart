import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeDataLoaded extends HomeState {
  final String greeting;
  final UserModel user;
  final String currentDate;
  final int notificationCount;
  final List<AgendasModel> agendas;
  final int leaveQuota;
  final bool isClockedIn;
  final String? lastClockInPhoto; // Path foto terakhir
  final DateTime? lastClockIn; // Lokasi terakhir

  const HomeDataLoaded({
    required this.greeting,
    required this.user,
    required this.currentDate,
    required this.notificationCount,
    required this.agendas,
    required this.leaveQuota,
    required this.isClockedIn,
    this.lastClockInPhoto,
    this.lastClockIn,
  });

  // Update copyWith untuk handle new fields
  HomeDataLoaded copyWith({
    int? notificationCount,
    List<AgendasModel>? agenda,
    int? leaveQuota,
    bool? isClockedIn,
    String? lastClockInPhoto,
    DateTime? lastClockIn,
  }) {
    return HomeDataLoaded(
      greeting: greeting,
      user: user,
      currentDate: currentDate,
      notificationCount: notificationCount ?? this.notificationCount,
      agendas: agenda ?? agendas,
      leaveQuota: leaveQuota ?? this.leaveQuota,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      lastClockInPhoto: lastClockInPhoto ?? this.lastClockInPhoto,
      lastClockIn: lastClockIn ?? this.lastClockIn,
    );
  }

  @override
  List<Object?> get props => [
    greeting,
    user,
    currentDate,
    notificationCount,
    agendas,
    leaveQuota,
    isClockedIn,
    lastClockInPhoto,
    lastClockIn,
  ];
}

class ClockInProgress extends HomeState {
  @override
  List<Object> get props => [];
}

class ClockInSuccess extends HomeState {
  final String photoPath;
  final Position position;

  const ClockInSuccess(this.photoPath, this.position);

  @override
  List<Object> get props => [photoPath, position];
}

class ClockInError extends HomeState {
  final String message;

  const ClockInError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
