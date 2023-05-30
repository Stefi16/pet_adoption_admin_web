import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_adoption_admin_web/app/app.locator.dart';
import 'package:pet_adoption_admin_web/services/database_service.dart';

class ThemeSwitcherService {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final ValueNotifier<bool?> _isDarkMode = ValueNotifier<bool?>(false);

  ValueNotifier<bool?> get isDarkMode => _isDarkMode;

  final ValueNotifier<int?> _currentColorTheme = ValueNotifier<int?>(null);

  ValueNotifier<int?> get currentColorTheme => _currentColorTheme;

  Future<void> init(
    FlexScheme colorScheme,
    bool isDarkMode,
  ) async {
    currentColorTheme.value = colorScheme.index;
    this.isDarkMode.value = isDarkMode;
  }

  void setDarkTheme(bool value) {
    final currentUser = _databaseService.getCurrentUser();
    currentUser.isDarkMode = value;

    _databaseService.addUser(currentUser);
    _isDarkMode.value = value;
  }

  bool getIsDarkMode(BuildContext context) {
    final bool? isDarkMode = _isDarkMode.value;

    if (isDarkMode == null) {
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;

      return isDarkMode;
    }

    return isDarkMode;
  }

  void setColorTheme(FlexScheme scheme) {
    final currentUser = _databaseService.getCurrentUser();
    currentUser.theme = scheme;

    _databaseService.addUser(currentUser);
    _currentColorTheme.value = scheme.index;
  }

  Future<void> resetTheme() async {
    currentColorTheme.value = FlexScheme.aquaBlue.index;
    isDarkMode.value = false;
  }
}
