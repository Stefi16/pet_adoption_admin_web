import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_admin_web/main/tabs/add_new_adoption/add_new_adoption_view.dart';
import 'package:pet_adoption_admin_web/main/tabs/approve_adoption/approve_adoption_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

enum MainTabs {
  add,
  approve,
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ViewModelBuilder<MainViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => MainViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.pets_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 60),
                _TabButton(
                  onPressed: () => viewModel.onAddAdoptionTap(),
                  text: text.add,
                  fontWeight: viewModel.index == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                _TabButton(
                  onPressed: () => viewModel.onApproveAdoptionTap(),
                  text: text.approve,
                  fontWeight: viewModel.index == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ],
            ),
            actions: [
              DayNightSwitcherIcon(
                isDarkModeEnabled: viewModel.isDarkMode(),
                onStateChanged: (bool isDarkModeEnabled) =>
                    viewModel.setIsDarkMode(isDarkModeEnabled),
                dayBackgroundColor: theme.primaryColor,
                nightBackgroundColor: theme.scaffoldBackgroundColor,
              ),
              _IconButton(
                onPressed: () => viewModel.openThemes(),
                icon: Icons.brush,
              ),
              _IconButton(
                onPressed: () => viewModel.logout(),
                icon: Icons.logout,
              ),
            ],
          ),
          body: _CurrentView(
            pageController: viewModel.pageController,
          ),
        );
      },
    );
  }
}

class _CurrentView extends StatelessWidget {
  const _CurrentView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      itemBuilder: (context, index) {
        final mainTab = MainTabs.values.elementAt(index);

        switch (mainTab) {
          case MainTabs.add:
            return const AddNewAdoptionView();
          case MainTabs.approve:
            return const ApproveAdoptionView();
        }
      },
      itemCount: MainTabs.values.length,
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    Key? key,
    required this.text,
    required this.fontWeight,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final FontWeight fontWeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
