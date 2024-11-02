import 'dart:io';

import 'package:flutter/foundation.dart';

import 'therapist_profile.dart';
import 'therapist_profile_repository.dart';

class TherapistProfileViewModel extends ChangeNotifier {
  final TherapistProfileRepository repository;
  String? imageUrl;
  String? tempImageUrl;

  TherapistProfileViewModel({required this.repository, this.imageUrl});

  Future<void> saveProfile(TherapistProfile profile) async {
    try {
      await repository.saveProfile(profile);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage(File image) async {
    // Upload image to Firebase Storage
    // await repository.uploadImage(path);
    imageUrl = await repository.uploadImage(image);
    notifyListeners();
    return imageUrl!;
  }

  Future<String> uploadTempImage(File image) async {
    // Upload image to Firebase Storage
    // await repository.uploadImage(path);
    tempImageUrl = await repository.uploadTempImage(image);
    notifyListeners();
    // print(tempImageUrl);
    return tempImageUrl!;
  }

  Future<TherapistProfile> getProfile() async {
    return await repository.getProfile();
  }
}
