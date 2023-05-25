import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_admin_web/utils/extensions.dart';
import 'package:pet_adoption_admin_web/widgets/dialogs/theme_dialog_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  final DialogRequest request;
  final Function(DialogResponse) completer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ViewModelBuilder<ThemeDialogViewModel>.reactive(
        viewModelBuilder: () => ThemeDialogViewModel(),
        builder: (context, viewModel, child) {
          final theme = Theme.of(context);
          final bool isDarkMode = viewModel.isDarkMode(context);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: FlexScheme.values.length,
              itemBuilder: (context, index) {
                final currentValue = FlexScheme.values.elementAt(index);
                final Color getColorDependingOnMode = isDarkMode
                    ? FlexThemeData.dark(
                        scheme: currentValue,
                      ).primaryColor
                    : FlexThemeData.light(
                        scheme: currentValue,
                      ).primaryColor;

                return Material(
                  child: InkWell(
                    onTap: () => viewModel.onThemeTapped(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: viewModel.isSelected(index)
                              ? theme.iconTheme.color!
                              : theme.iconTheme.color!.withOpacity(0.5),
                          width: viewModel.isSelected(index) ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: getColorDependingOnMode,
                      ),
                      child: Center(
                        child: Text(
                          currentValue.name.capitalizeFirstLetter(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}
