import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_event.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onLoadUserData(LoadUserData event, Emitter<SettingState> emit) async {
    try {
      final prefs = getIt<SharedPreferences>();
      if (prefs.containsKey('user')) {
        final userData = jsonDecode(prefs.getString('user')!);
        emit(UserDataLoaded(userData));
      } else {
        emit(const UserDataLoaded(null));
      }
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<SettingState> emit) async {
    try {
      final prefs = getIt<SharedPreferences>();
      await prefs.remove('user');
      await prefs.remove('token');
      emit(LogoutSuccess());
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }
}
