import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadHomeData extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClockInRequested extends HomeEvent {
  final String photoPath;
  final Position position;

  const ClockInRequested(this.photoPath, this.position);

  @override
  List<Object> get props => [photoPath, position];
}

class ClockOutRequested extends HomeEvent {
  @override
  List<Object> get props => [];
}

class RequestLeave extends HomeEvent {
  @override
  List<Object> get props => [];
}
