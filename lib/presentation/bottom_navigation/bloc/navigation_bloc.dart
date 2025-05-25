import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitial()) {
    on<NavigationTabChanged>(_onNavigationTabChange);
  }

  Future<void> _onNavigationTabChange(
    NavigationTabChanged event,
    Emitter<NavigationState> emit,
  ) async {
    String tabName = 'Home';
    switch (event.tabIndex) {
      case 0:
        tabName = 'Home';
        break;
      case 1:
        tabName = 'Kalender';
        break;
      case 2:
        tabName = 'Pengaturan';
        break;
    }
    emit(NavigationInitial(tabIndex: event.tabIndex, tabName: tabName));
  }
}
