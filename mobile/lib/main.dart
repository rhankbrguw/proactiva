import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'core/session.dart';
import 'features/auth/login_screen.dart';
import 'features/shell/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final token = await SessionManager.getToken();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ProActivaApp(isLoggedIn: token != null),
    ),
  );
}

class ProActivaApp extends StatelessWidget {
  final bool isLoggedIn;

  const ProActivaApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
      ),
      home: isLoggedIn ? const MainNavigationShell() : const LoginScreen(),
    );
  }
}
