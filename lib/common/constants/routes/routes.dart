import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';

import '../../../presentation/pages.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (context) => HomePage());
      // case RoutesName.loginScreen:
      //   return MaterialPageRoute(builder: (context) => LoginPage());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (context) => HomePage());
      case RoutesName.pengajuanCuti:
        return MaterialPageRoute(builder: (context) => PengajuanCutiPage());
      case RoutesName.formCuti:
        return MaterialPageRoute(builder: (context) => FormCutiPage());
      case RoutesName.profileScreen:
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case RoutesName.aboutScreen:
        return MaterialPageRoute(builder: (context) => AboutPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(body: Center(child: Text('No Route Defined'))),
        );
    }
  }
}
