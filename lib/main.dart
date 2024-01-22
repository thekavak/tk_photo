import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tk_photo/feature/auth/login_view.dart';
import 'package:tk_photo/feature/home/home_view.dart';
import 'package:tk_photo/product/constant/app_color.dart';
import 'package:tk_photo/product/initialize/app_theme.dart';

import 'service/shared_preferences.dart';

String? username;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  username = await MySharedPreferences.instance
      .getStringValue(mySharedKey.TKP_USER_NAME);
  if (kDebugMode) {
    print(username);
  }
  runApp(const ProviderScope(child: MyApp()));
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TK Photo',
      theme: AppTheme().themeData,
      debugShowCheckedModeBanner: false,
      home: FlutterSplashScreen.scale(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 42, 42, 42),
            Color(0xFF941C25),
          ],
        ),
        childWidget: SizedBox(
          height: 150,
          child: Image.asset("assets/images/splash.png"),
        ),
        duration: const Duration(milliseconds: 1500),
        animationDuration: const Duration(milliseconds: 1000),
        onAnimationEnd: () => debugPrint("On Scale End"),
        nextScreen: (username != null && (username?.isNotEmpty ?? false))
            ? const HomePageView()
            : const LoginView(),
      ),
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomePageView(),
      },
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = ColorConstants.mtPrimary
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = const Color.fromARGB(255, 172, 172, 172).withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
