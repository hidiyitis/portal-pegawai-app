import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationTabChanged extends NavigationEvent {
  final int tabIndex;

  const NavigationTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
