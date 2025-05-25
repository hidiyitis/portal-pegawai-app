import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadHomeData extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClockInClockOutRequested extends HomeEvent {
  final XFile photo;
  final Position position;

  const ClockInClockOutRequested(this.photo, this.position);

  @override
  List<Object> get props => [photo, position];
}

class RequestLeave extends HomeEvent {
  @override
  List<Object> get props => [];
}
