import 'dart:io';

import 'package:flutter/foundation.dart';

import 'community_member_profile_model.dart';
import 'community_member_profile_repository.dart';

class CommunityMemberProfileViewModel extends ChangeNotifier {
  final CommunityMemberProfileRepository repository;
  String? imageUrl;
  String? tempImageUrl;

  CommunityMemberProfileViewModel({required this.repository, this.imageUrl});

  Future<void> saveProfile(CommunityMemberProfile profile) async {
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

  Future<CommunityMemberProfile> getProfile() async {
    return await repository.getProfile();
  }
}
