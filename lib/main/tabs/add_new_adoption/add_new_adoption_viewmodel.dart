import 'dart:typed_data';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:pet_adoption_admin_web/utils/extensions.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../models/animal_adoption.dart';
import '../../../models/animal_age.dart';
import '../../../services/auth_service.dart';
import '../../../services/database_service.dart';
import '../../../utils/enums.dart';
import '../../../utils/setup_dialog.dart';

const keyYears = 'years';
const keyMonths = 'months';

class AddNewAdoptionViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthService _authService = locator<AuthService>();

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _breedController = TextEditingController();
  TextEditingController get breedController => _breedController;

  final TextEditingController _countryController = TextEditingController();
  TextEditingController get countryController => _countryController;

  final TextEditingController _cityController = TextEditingController();
  TextEditingController get cityController => _cityController;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  final FocusNode _countryFocusNode = FocusNode();
  FocusNode get countryFocusNode => _countryFocusNode;

  final FocusNode _cityFocusNode = FocusNode();
  FocusNode get cityFocusNode => _cityFocusNode;

  final FocusNode _descriptionFocusNode = FocusNode();
  FocusNode get descriptionFocusNode => _descriptionFocusNode;

  AnimalAge? _ageResult;
  AnimalAge? get ageResult => _ageResult;
  set _setAgeResult(AnimalAge? newAge) {
    _ageResult = newAge;
    notifyListeners();
  }

  AnimalGender? _chosenGender;
  AnimalGender? get chosenGender => _chosenGender;
  set _setChosenGender(AnimalGender? newGender) {
    if (_chosenGender != newGender) {
      _chosenGender = newGender;
      notifyListeners();
    }
  }

  AnimalType? _chosenType;
  AnimalType? get chosenType => _chosenType;
  set _setNewAnimalTypeValue(AnimalType? animalType) {
    if (_chosenType != animalType) {
      _chosenType = animalType;
      notifyListeners();
    }
  }

  bool _hasNameError = false;
  bool get hasNameError => _hasNameError;
  set _setHasNameError(bool hasNameError) {
    if (_hasNameError != hasNameError) {
      _hasNameError = hasNameError;
      notifyListeners();
    }
  }

  bool _hasGenderError = false;
  bool get hasGenderError => _hasGenderError;
  set _setHasGenderError(bool hasGenderError) {
    if (_hasGenderError != hasGenderError) {
      _hasGenderError = hasGenderError;
      notifyListeners();
    }
  }

  bool _hasAnimalTypeError = false;
  bool get hasAnimalTypeError => _hasAnimalTypeError;
  set _setHasAnimalTypeError(bool hasAnimalTypeError) {
    if (_hasAnimalTypeError != hasAnimalTypeError) {
      _hasAnimalTypeError = hasAnimalTypeError;
      notifyListeners();
    }
  }

  bool _hasAgeError = false;
  bool get hasAgeError => _hasAgeError;
  set _setHasAgeError(bool hasAgeError) {
    if (_hasAgeError != hasAgeError) {
      _hasAgeError = hasAgeError;
      notifyListeners();
    }
  }

  bool _hasCountryError = false;
  bool get hasCountryError => _hasCountryError;
  set _setHasCountryError(bool hasCountryError) {
    if (_hasCountryError != hasCountryError) {
      _hasCountryError = hasCountryError;
      notifyListeners();
    }
  }

  bool _hasCityError = false;
  bool get hasCityError => _hasCityError;
  set _setHasCityError(bool hasCityError) {
    if (_hasCityError != hasCityError) {
      _hasCityError = hasCityError;
      notifyListeners();
    }
  }

  bool _hasDescriptionError = false;
  bool get hasDescriptionError => _hasDescriptionError;
  set _setHasDescriptionError(bool hasDescriptionError) {
    if (_hasDescriptionError != hasDescriptionError) {
      _hasDescriptionError = hasDescriptionError;
      notifyListeners();
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set _setIsLoading(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  Uint8List? _chosenPhoto;
  Uint8List get chosenPhoto => _chosenPhoto ?? Uint8List.fromList([]);
  set _setChosenPhoto(Uint8List? newPhoto) {
    _chosenPhoto = newPhoto;
    notifyListeners();
  }

  void chooseGender(AnimalGender? newValue) => _setChosenGender = newValue;

  void chooseType(AnimalType? newValue) => _setNewAnimalTypeValue = newValue;

  void setYearsAndMonths(Map<String, int?>? result) {
    final int? months = result?[keyMonths];
    final int? years = result?[keyYears];

    if (months != null && years != null) {
      _setAgeResult = AnimalAge(months: months, years: years);
    }
  }

  Future<DialogResponse?> showAgeDialog() async {
    return await _dialogService.showCustomDialog(
      variant: DialogType.chooseAge,
      barrierDismissible: true,
    );
  }

  void publishAdoption() async {
    _validateAll();

    if (_hasFormError() || _isLoading) {
      return;
    }

    _setIsLoading = true;
    final newAdoptionId = const Uuid().v4();
    String? url;

    if (chosenPhoto.isNotEmpty) {
      url = await _databaseService.uploadAdoptionImage(
        chosenPhoto,
        newAdoptionId,
      );
    }

    final newAdoption = AnimalAdoption(
      userId: _authService.currentUserId!,
      animalName: nameController.text,
      genderType: _chosenGender!,
      animalType: _chosenType!,
      isApproved: true,
      country: countryController.text,
      city: cityController.text,
      description: descriptionController.text,
      breed: breedController.text.isEmpty ? null : breedController.text,
      animalAge: ageResult!,
      adoptionId: newAdoptionId,
      photoUrl: url,
      datePublished: DateTime.now(),
    );

    await _databaseService.addAdoption(newAdoption);
    _clearForm();
    _setIsLoading = false;
  }

  void _clearForm() {
    nameController.clear();
    _setChosenGender = null;
    _setNewAnimalTypeValue = null;
    _setAgeResult = null;
    _breedController.clear();
    _countryController.clear();
    _cityController.clear();
    _descriptionController.clear();
    _setChosenPhoto = null;
  }

  void _validateName() {
    final name = nameController.text.removeWhiteSpaces();
    _setHasNameError = name.isEmpty || name.length < 2;
  }

  void _validateGender() => _setHasGenderError = _chosenGender == null;

  void _validateAnimalType() => _setHasAnimalTypeError = _chosenType == null;

  void _validateAnimalAge() => _setHasAgeError = _ageResult == null;

  void _validateCountry() {
    final country = countryController.text.removeWhiteSpaces();
    _setHasCountryError = country.isEmpty || country.length < 3;
  }

  void _validateCity() {
    final city = cityController.text.removeWhiteSpaces();
    _setHasCityError = city.isEmpty || city.length < 2;
  }

  void _validateDescription() {
    final description = descriptionController.text.removeWhiteSpaces();
    _setHasDescriptionError = description.isEmpty || description.length < 10;
  }

  void _validateAll() {
    _validateName();
    _validateGender();
    _validateAnimalType();
    _validateAnimalAge();
    _validateCountry();
    _validateCity();
    _validateDescription();
  }

  bool _hasFormError() =>
      _hasGenderError ||
      _hasNameError ||
      _hasAgeError ||
      _hasAnimalTypeError ||
      _hasCityError ||
      _hasCountryError ||
      _hasDescriptionError;

  void _disposeControllers() {
    _nameController.dispose();
    _breedController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
  }

  void _disposeFocusNodes() {
    _cityFocusNode.dispose();
    _countryFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void uploadPhoto() async {
    final Uint8List? result = await ImagePickerWeb.getImageAsBytes();

    if (result != null) {
      _setChosenPhoto = result;
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }
}
