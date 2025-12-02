import 'package:flutter/material.dart';
import 'package:ppt_generator/features/history/presentation/history_screen.dart';
import 'package:ppt_generator/features/home_screen/presentation/home_screen.dart';
import 'package:ppt_generator/features/login_screen/presentation/login_screen.dart';
import 'package:ppt_generator/features/otp_screen/presentation/otp_screen.dart';
import 'package:ppt_generator/features/ppt_viewer/presentation/loading_screen.dart';
import 'package:ppt_generator/features/ppt_viewer/presentation/ppt_viewer_screen.dart';
import 'package:ppt_generator/features/sign_up_screen/presentation/sign_up_screen.dart';
import 'package:ppt_generator/features/splash_screen/presentation/splash_screen.dart';

class AppRoutes {
  static const initial_screen = '/';
  static const login_screen = 'login_screen';
  static const sign_up_screen = 'sign_up_screen';
  static const home_screen = 'home_screen';
  static const otp_screen = 'otp_screen';
  static const loading_screen = 'loading_screen';
  static const ppt_viewer_screen = 'ppt_viewer_screen';
  static const history_screen = 'history_screen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial_screen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case home_screen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case login_screen:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case sign_up_screen:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case otp_screen:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => OtpScreen(email: email));
      case loading_screen:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case ppt_viewer_screen:
        final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PptViewerScreen(pptUrl: args));
      case history_screen:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
