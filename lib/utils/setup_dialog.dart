import 'package:pet_adoption_admin_web/widgets/dialogs/theme_dialog.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../widgets/dialogs/choose_age_dialog.dart';

enum DialogType {
  chooseAge,
  chooseTheme,
}

void setupDialogUi() {
  final DialogService dialogService = locator<DialogService>();

  final builders = {
    DialogType.chooseAge: (context, sheetRequest, completer) =>
        ChooseAgeDialog(request: sheetRequest, completer: completer),
    DialogType.chooseTheme: (context, sheetRequest, completer) =>
        ThemeDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
