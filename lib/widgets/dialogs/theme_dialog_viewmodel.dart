import 'package:flutter/src/widgets/framework.dart';
import 'package:pet_adoption_admin_web/services/theme_switcher_service.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';

class ThemeDialogViewModel extends BaseViewModel {
  final ThemeSwitcherService _themeSwitcherService =
      locator<ThemeSwitcherService>();

  void onThemeTapped(int index) async {
    await _themeSwitcherService.setColorTheme(index);
    notifyListeners();
  }

  bool isDarkMode(BuildContext context) {
    return _themeSwitcherService.getIsDarkMode(context);
  }

  bool isSelected(int index) {
    final currentIndex = _themeSwitcherService.currentColorTheme.value;

    return currentIndex == index;
  }
}
