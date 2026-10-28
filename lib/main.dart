import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CanTechApp());
}

class CanTechApp extends StatelessWidget {
  const CanTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAN-TECH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryBlue,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          secondary: AppColors.cyanNeon,
          surface: AppColors.cardBg,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}