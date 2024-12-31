import 'package:budget_tracker_app/screen/home/home_page.dart';
import 'package:budget_tracker_app/screen/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';

  static List<GetPage> getRoutes() {
    return [
      GetPage(name: splash, page: () => const SplashScreen()),
      GetPage(name: home, page: () => HomePage()),
    ];
  }
}
