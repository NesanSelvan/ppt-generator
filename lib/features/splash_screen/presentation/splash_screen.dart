import 'package:flutter/material.dart';
import 'package:ppt_generator/core/constants/app_images.dart';
import 'package:ppt_generator/core/constants/app_routes.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = SupabaseService().currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home_screen);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login_screen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(AppImages.appIcon, scale: 10),
      ),
    );
  }
}
