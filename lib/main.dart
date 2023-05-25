import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_adoption_admin_web/services/theme_switcher_service.dart';
import 'package:pet_adoption_admin_web/utils/setup_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'firebase_options.dart';
import 'main_app_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _setupStackedServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainAppViewModel>.reactive(
      onViewModelReady: (vm) => vm.init(),
      viewModelBuilder: () => MainAppViewModel(),
      builder: (context, viewModel, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        theme: FlexThemeData.light(
          scheme: viewModel.getProperColorTheme(),
        ),
        darkTheme: FlexThemeData.dark(
          scheme: viewModel.getProperColorTheme(),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('bg'),
          Locale('en'),
        ],
      ),
    );
  }
}

Future<void> _setupStackedServices() async {
  await setupLocator();
  setupDialogUi();
  await locator<ThemeSwitcherService>().init();
}
