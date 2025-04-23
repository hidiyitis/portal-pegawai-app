import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_images.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_bloc.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_event.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_state.dart';
import 'package:portal_pegawai_app/presentation/setting/widget/menu_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(LoadUserData()),
      child: const _SettingView(),
    );
  }
}

class _SettingView extends StatelessWidget {
  const _SettingView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.loginScreen,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final userData = state is UserDataLoaded ? state.userData : null;

          return Scaffold(
            body: Column(
              spacing: 24,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan',
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: AppTextSize.headingSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['name'] ?? 'Arshita Hira',
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: AppTextSize.headingSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData?['role'] ?? 'Developer',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: AppTextSize.bodyLarge,
                                ),
                              ),
                              Text(
                                userData?['nip']?.toString() ?? 'NIP',
                                style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: AppTextSize.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  RoutesName.profileScreen,
                                ),
                            child: Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppImages.defaultProfile),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 10, color: AppColors.background),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    spacing: 8,
                    children: [
                      MenuWidget(
                        icon: IconlyLight.profile,
                        label: 'Profil',
                        nextPage: RoutesName.profileScreen,
                      ),
                      Divider(),
                      MenuWidget(
                        icon: IconlyLight.info_circle,
                        label: 'Tentang',
                        nextPage: RoutesName.aboutScreen,
                      ),
                      Divider(),
                      MenuWidget(
                        icon: IconlyLight.logout,
                        label: 'Keluar',
                        onTap: () {
                          context.read<SettingBloc>().add(LogoutUser());
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
