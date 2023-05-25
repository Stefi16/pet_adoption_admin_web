import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_adoption_admin_web/app/app.router.dart';
import 'package:pet_adoption_admin_web/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app/app.locator.dart';
import '../services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  FocusNode get passwordFocusNode => _passwordFocusNode;
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailTextController = TextEditingController();
  TextEditingController get emailTextController => _emailTextController;

  TextEditingController get passwordTextController => _passwordTextController;
  final TextEditingController _passwordTextController = TextEditingController();

  bool get shouldHidePassword => _shouldHidePassword;
  bool _shouldHidePassword = true;
  set _setShouldHidePassword(bool value) {
    if (_shouldHidePassword != value) {
      _shouldHidePassword = value;
      notifyListeners();
    }
  }

  bool get hasEmailError => _hasEmailError;
  bool _hasEmailError = false;
  set _setHasEmailError(bool value) {
    if (_hasEmailError != value) {
      _hasEmailError = value;
      notifyListeners();
    }
  }

  bool get hasPasswordError => _hasPasswordError;
  bool _hasPasswordError = false;
  set _setHasPasswordError(bool value) {
    if (_hasPasswordError != value) {
      _hasPasswordError = value;
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  bool _isLoading = false;
  set setIsLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void login() async {
    if (hasTextFieldError() || isLoading) {
      return;
    }

    setIsLoading = true;

    final email = emailTextController.text;
    final password = passwordTextController.text;

    final result = await _authService.loginUser(email, password);

    if (result) {
      final appUser =
          await _databaseService.getUser(_authService.currentUser!.uid);

      if (!appUser.isAdmin) {
        final result = await _authService.signOut();

        if (result) {
          final text = AppLocalizations.of(
            StackedService.navigatorKey!.currentContext!,
          );

          _snackbarService.showSnackbar(
            message: text.userIsNotAdminError,
            title: text.error,
          );
        }
      } else {
        _navigationService.clearStackAndShow(Routes.splashView);
      }
    }

    setIsLoading = false;
  }

  bool hasTextFieldError() => hasEmailError || hasPasswordError;

  void toggleVisibility() => _setShouldHidePassword = !shouldHidePassword;

  void onPasswordFocusChange(bool isFocused) {
    if (isFocused) {
      _setHasPasswordError = false;
      return;
    }

    _setHasPasswordError = validatePassword(passwordTextController.text);
  }

  bool _validateEmail(String input) => !EmailValidator.validate(input);

  void onEmailFocusChange(bool isFocused) {
    if (isFocused) {
      _setHasEmailError = false;
      return;
    }

    _setHasEmailError = _validateEmail(emailTextController.text);
  }

  bool validatePassword(String input) {
    const String passwordExpression = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regExp = RegExp(passwordExpression);

    return !regExp.hasMatch(input);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
