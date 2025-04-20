import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_state.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/agenda_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/attendance_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/header_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/leave_widget.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_bloc.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:portal_pegawai_app/presentation/setting/pages/setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 5), (timer) {
      context.read<AuthBloc>().add(AuthCheckEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _getPage(state.tabIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.tabIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationTabChanged(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.calendar),
                label: 'Kalender',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.setting),
                label: 'Pengaturan',
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _getPage(int index) {
  switch (index) {
    case 0:
      return HomePageWidget();
    case 1:
      return Center(child: Text('Kalender'));
    case 2:
      return SettingPage();
    default:
      return Center(child: Text('Page Not Found'));
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is ClockInError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is HomeDataLoaded) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      greeting: state.greeting,
                      name: state.user?['name'] ?? 'Arshita Hira',
                      role: state.user?['role'] ?? 'Developer',
                    ),
                    const SizedBox(height: 24),
                    AttendanceWidget(
                      isClockedIn: state.isClockedIn,
                      lastClockInPhoto: state.lastClockInPhoto,
                      lastClockInPosition: state.lastClockInPosition,
                      onClockIn:
                          () =>
                              context.read<HomeBloc>().processClockIn(context),
                      onClockOut:
                          () =>
                              context.read<HomeBloc>().add(ClockOutRequested()),
                    ),
                    const SizedBox(height: 24),
                    AgendaWidget(agendas: state.agendas),
                    const SizedBox(height: 24),
                    LeaveWidget(leaveQuota: state.leaveQuota),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
