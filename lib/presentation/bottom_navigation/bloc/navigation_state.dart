import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  int get tabIndex;
  String get tabName;

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {
  @override
  final int tabIndex;
  @override
  final String tabName;

  const NavigationInitial({this.tabIndex = 0, this.tabName = 'Home'});

  @override
  List<Object> get props => [tabIndex, tabName];
}
