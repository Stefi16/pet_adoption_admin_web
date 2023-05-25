import 'package:pet_adoption_admin_web/models/animal_adoption.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/database_service.dart';

class ApproveAdoptionViewModel extends BaseViewModel {
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<AnimalAdoption> getNotApprovedAdoptions() {
    return _databaseService.allAdoptions
        .where((adoption) => !adoption.isApproved)
        .toList();
  }

  String getPhotoUrl(int index) =>
      getNotApprovedAdoptions().elementAt(index).photoUrl ?? '';

  void onApprove(AnimalAdoption adoption) async {
    adoption.isApproved = true;
    await _databaseService.addAdoption(adoption);

    _databaseService.allAdoptions
        .where(
          (a) => adoption.adoptionId == a.adoptionId,
        )
        .first
        .isApproved = true;

    notifyListeners();
  }

  void onRemove(String adoptionId) async {
    await _databaseService.deleteAdoption(adoptionId);
    notifyListeners();
  }
}
