import 'package:pet_adoption_admin_web/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../services/auth_service.dart';

class SplashViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void init() async {
    final currentUser = _authService.currentUser;

    if (currentUser != null) {
      final users = await _databaseService.getUsers();
      final appUser = await _databaseService.getUser(currentUser.uid);
      final adoptions = await _databaseService.getAdoptions();

      _databaseService.initDatabaseService(
        currentUser: appUser,
        users: users,
        adoptions: adoptions,
      );

      Future.delayed(
        const Duration(seconds: 3),
        () {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              _navigationService.clearStackAndShow(Routes.mainView);
            },
          );
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            _navigationService.clearStackAndShow(Routes.loginView);
          },
        ),
      );
    }
  }
}
