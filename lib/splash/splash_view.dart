import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption_admin_web/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Center(
        child: ViewModelBuilder<SplashViewModel>.nonReactive(
          viewModelBuilder: () => SplashViewModel(),
          onViewModelReady: (vm) => vm.init(),
          builder: (context, viewModel, child) => SizedBox(
            height: 350,
            child: Lottie.asset('assets/animations/loading_cat.json'),
          ),
        ),
      ),
    );
  }
}
