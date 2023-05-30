import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/animal_adoption.dart';
import '../models/app_user.dart';

const String _dbUsers = 'users';
const String _dbAnimalAdoptions = 'animal_adoption';

class DatabaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AppUser getCurrentUser() => _currentUser;

  AppUser setCurrentUser(AppUser currentUser) => _currentUser = currentUser;
  AppUser _currentUser = AppUser.createNew('', '');

  List<AppUser> _users = [];

  List<AppUser> getAllUsers() => _users;

  AppUser getUsersById(String id) {
    return _users.where((user) => user.id == id).first;
  }

  List<AnimalAdoption> _adoptions = [];

  List<AnimalAdoption> get allAdoptions => _adoptions;

  void setAllAdoptions(List<AnimalAdoption> newAdoptions) =>
      _adoptions = newAdoptions;

  void initDatabaseService({
    required AppUser currentUser,
    required List<AppUser> users,
    required List<AnimalAdoption> adoptions,
  }) {
    _currentUser = currentUser;
    _users = users;
    _adoptions = adoptions;
  }

  Future<void> addUser(AppUser user) async {
    await _firebaseFirestore.collection(_dbUsers).doc(user.id).set(
          user.toJson(),
        );
  }

  Future<AppUser> getUser(String id) async {
    return _firebaseFirestore.collection(_dbUsers).doc(id).get().then(
          (data) => AppUser.fromJson(
            data.data()!,
          ),
        );
  }

  Future<List<AppUser>> getUsers() async {
    return _firebaseFirestore.collection(_dbUsers).get().then(
          (data) => data.docs
              .map(
                (animalAdoption) => AppUser.fromJson(
                  animalAdoption.data(),
                ),
              )
              .toList(),
        );
  }

  Future<String> uploadImage(Uint8List imageBytes, String userId) async {
    final reference = _storage.ref('profile_picture/$userId.jpg');

    await reference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await reference.getDownloadURL();
  }

  Future<void> addAdoption(AnimalAdoption adoption) async {
    await _firebaseFirestore
        .collection(_dbAnimalAdoptions)
        .doc(adoption.adoptionId)
        .set(
          adoption.toJson(),
        );
  }

  Future<AnimalAdoption> getAdoption(String id) async {
    return _firebaseFirestore.collection(_dbAnimalAdoptions).doc(id).get().then(
          (data) => AnimalAdoption.fromJson(
            data.data()!,
          ),
        );
  }

  Future<List<AnimalAdoption>> getAdoptions() async {
    return _firebaseFirestore.collection(_dbAnimalAdoptions).get().then(
          (data) => data.docs
              .map(
                (animalAdoption) => AnimalAdoption.fromJson(
                  animalAdoption.data(),
                ),
              )
              .toList(),
        );
  }

  Future<bool> deleteAdoption(String id) async {
    try {
      await _firebaseFirestore.collection(_dbAnimalAdoptions).doc(id).delete();
      await _deleteAdoptionImage(id);
      _adoptions.removeWhere((adoption) => adoption.adoptionId == id);

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<AnimalAdoption>> getAdoptionsStream() {
    return _firebaseFirestore
        .collection(_dbAnimalAdoptions)
        .snapshots()
        .map((query) => query.docs)
        .map(
          (docs) => docs
              .map(
                (e) => AnimalAdoption.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Future<String> uploadAdoptionImage(
      Uint8List imageBytes, String adoptionId) async {
    final reference = _storage.ref('adoption_picture/$adoptionId.jpg');

    await reference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await reference.getDownloadURL();
  }

  Future<void> _deleteAdoptionImage(String adoptionId) async {
    final reference = _storage.ref('adoption_picture/$adoptionId.jpg');

    await reference.delete();
  }
}
