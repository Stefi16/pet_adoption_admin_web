import 'package:pet_adoption_admin_web/login/login_view.dart';
import 'package:pet_adoption_admin_web/main/main_view.dart';
import 'package:pet_adoption_admin_web/services/auth_service.dart';
import 'package:pet_adoption_admin_web/services/database_service.dart';
import 'package:pet_adoption_admin_web/services/theme_switcher_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../splash/splash_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(
      page: SplashView,
      initial: true,
    ),
    MaterialRoute(
      page: LoginView,
    ),
    MaterialRoute(
      page: MainView,
    ),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: ThemeSwitcherService),
  ],
)
class App {}
