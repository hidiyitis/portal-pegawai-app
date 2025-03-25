import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_images.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/splash/bloc/splash_cubit.dart';
import 'package:portal_pegawai_app/presentation/splash/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (BuildContext context, SplashState state) {
          if (state is UnAuthenticated) {
            Navigator.pushNamed(context, RoutesName.loginScreen);
          }
          if (state is Authenticated) {
            Navigator.pushNamed(context, RoutesName.homeScreen);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(AppImages.employeeIcon), width: 150),
              Text(
                'Portal Pegawai',
                style: TextStyle(
                  fontFamily: 'Inter-Regular',
                  color: AppColors.primary,
                  fontSize: AppTextSize.headingMedium,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
