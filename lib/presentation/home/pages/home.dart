// lib/presentation/home/pages/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_state.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/agenda_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/attendance_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/header_widget.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/leave_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  AttendanceWidget(),
                  AgendaWidget(),
                  LeaveWidget(),
                ],
              ),
            ),
          ),
        );
      case 1:
        return Center(child: Text('Kalender'));
      case 2:
        return Center(child: Text('Pengaturan'));
      default:
        return Center(child: Text('Page Not Found'));
    }
  }
}
