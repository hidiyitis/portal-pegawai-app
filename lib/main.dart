import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart' as di;
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_theme.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_bloc.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_state.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_bloc.dart';

//test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await di.init();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(authRepository: di.getIt<AuthRepository>())
                    ..add(AuthCheckEvent()),
        ),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => HomeBloc()..add(LoadHomeData())),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
        navigatorKey: navigatorKey,
        builder:
            (context, child) => BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated &&
                    state.message.contains('Expired')) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: navigatorKey.currentContext!,
                      builder:
                          (context) => PopScope(
                            canPop: false,
                            child: AlertDialog(
                              title: const Text(
                                'Sesi Berakhir',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              content: const Text(
                                'Sesi Anda telah berakhir, silakan login kembali.',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RoutesName.loginScreen,
                                    );
                                  },
                                  style: ButtonStyle(
                                    overlayColor: WidgetStatePropertyAll(
                                      AppColors.primary.withAlpha(25),
                                    ),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    );
                  });
                }
              },
              child: child,
            ),
      ),
    );
  }
}
