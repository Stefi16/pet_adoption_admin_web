import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pet_adoption_admin_web/widgets/app_logo.dart';
import 'package:stacked/stacked.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/keyboard_unfocuser.dart';
import 'login_viewmodel.dart';

const double _width = 450;

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor.withOpacity(0.8),
      child: KeyboardUnfocuser(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ViewModelBuilder<LoginViewModel>.reactive(
              viewModelBuilder: () => LoginViewModel(),
              builder: (context, viewModel, child) {
                return Center(
                  child: SizedBox(
                    width: _width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AppLogo(),
                        _EmailTextField(viewModel: viewModel),
                        _PasswordTextField(viewModel: viewModel),
                        CustomButton(
                          text: text.login,
                          onTap: () => viewModel.login(),
                          isLoading: viewModel.isLoading,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: text.email,
          controller: viewModel.emailTextController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            viewModel.passwordFocusNode.requestFocus();
          },
          onFocusChanged: viewModel.onEmailFocusChange,
          hasError: viewModel.hasEmailError,
        ),
        if (viewModel.hasEmailError) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              text.invalidEmail,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
        SizedBox(height: viewModel.hasEmailError ? 16 : 20.0),
      ],
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          focusNode: viewModel.passwordFocusNode,
          controller: viewModel.passwordTextController,
          label: text.password,
          isPassword: true,
          obscureText: viewModel.shouldHidePassword,
          toggleVisibility: () => viewModel.toggleVisibility(),
          textInputAction: TextInputAction.done,
          hasError: viewModel.hasPasswordError,
          onFocusChanged: viewModel.onPasswordFocusChange,
          onEditingComplete: () => viewModel.login(),
        ),
        if (viewModel.hasPasswordError) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              text.invalidPassword,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
        SizedBox(height: viewModel.hasEmailError ? 16 : 20.0),
      ],
    );
  }
}
