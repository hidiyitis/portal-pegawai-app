import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_images.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required String greeting,
    required name,
    required role,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeDataLoaded) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat ${state.greeting}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: AppTextSize.headingMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name.split(' ')[0],
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: AppTextSize.headingMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -8),
                              child: Text(
                                state.user.role,
                                style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: AppTextSize.headingSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              IconlyLight.notification,
                              size: AppTextSize.headingMedium,
                            ),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  '${state.notificationCount}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppTextSize.bodySmall,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: state.user.photoUrl,
                              errorWidget:
                                  (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                    child: Icon(
                                      IconlyLight.image,
                                      size: AppTextSize.headingMedium,
                                    ),
                                  ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox(); // Tampilan loading/empty state
      },
    );
  }
}
