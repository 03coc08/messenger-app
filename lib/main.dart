import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_app/core/config/env.dart';
import 'package:messenger_app/core/utils/app_snackbar.dart';
import 'package:messenger_app/screens/login_page.dart';
import 'package:messenger_app/theme/app_colors.dart';
import 'package:messenger_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Quên truyền file env thì báo lỗi luôn
  Env.validate();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: AppSnackBar.messengerKey,
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
