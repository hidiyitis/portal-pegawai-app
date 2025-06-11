import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_state.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';
import 'package:portal_pegawai_app/presentation/agenda/widgets/agenda_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/attendance_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/header_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/leave_widget.dart';
import 'package:portal_pegawai_app/presentation/agenda/pages/calendar.dart';
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
    Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<AuthBloc>().add(AuthCheckEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop && state.tabIndex != 0) {
              context.read<NavigationBloc>().add(NavigationTabChanged(0));
            }
          },
          child: Scaffold(
            body: _getPage(state.tabIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.tabIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(NavigationTabChanged(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.home),
                  label: 'Beranda',
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
      return CalendarScreen();
    case 2:
      return SettingPage();
    default:
      return Center(child: Text('Page Not Found'));
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<HomeBloc>().add(LoadHomeData());

    await Future.delayed(const Duration(seconds: 1));
  }

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
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () => _refreshData(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderWidget(
                        greeting: state.greeting,
                        name: state.user.name,
                        role: state.user.department.name,
                      ),
                      const SizedBox(height: 24),
                      AttendanceWidget(
                        isClockedIn: state.isClockedIn,
                        isClockedOut: state.isClockedOut,
                        lastClockIn: state.lastClockIn,
                        lastClockOut: state.lastClockOut,
                        onClockInOut:
                            () => context
                                .read<HomeBloc>()
                                .processClockInClockOut(context),
                      ),
                      const SizedBox(height: 24),
                      AgendaWidget(),
                      const SizedBox(height: 24),
                      LeaveWidget(leaveQuota: state.leaveQuota),
                    ],
                  ),
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
