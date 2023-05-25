import 'package:flutter/cupertino.dart';
import 'package:pet_adoption_admin_web/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../services/auth_service.dart';
import '../utils/setup_dialog.dart';

class MainViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();

  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  bool _isButtonClicked = false;

  int _index = 0;

  int get index => _index;

  set _setIndex(int value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }

  void init() {
    _databaseService.getAdoptions().then(
      (newAdoptions) {
        _databaseService.setAllAdoptions(newAdoptions);
        notifyListeners();
      },
    );
  }

  void onAddAdoptionTap() {
    _setIndex = 0;
    _pageController.animateToPage(
      _index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onApproveAdoptionTap() {
    _setIndex = 1;

    _pageController.animateToPage(
      _index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void logout() async {
    if (_isButtonClicked) {
      return;
    }

    _isButtonClicked = true;
    final success = await _authService.signOut();
    _isButtonClicked = false;

    if (success) {
      _navigationService.clearStackAndShow(Routes.loginView);
    }
  }

  void openThemes() async {
    await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.chooseTheme,
    );
  }
}
