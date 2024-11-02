import 'package:flutter/material.dart';
import 'package:insight/src/modules/profile/community_member_profile_repository.dart';

import '../../profile/community_member_profile_model.dart';
import 'safe_space_model.dart';
import 'safe_space_post_model.dart';
import 'safe_space_repository.dart';

class SafeSpaceViewModel extends ChangeNotifier {
  final SafeSpaceRepository _safeSpaceRepository = SafeSpaceRepository();
  final CommunityMemberProfileRepository _patientProfileRepository =
      CommunityMemberProfileRepository();

  Stream<List<SafeSpaceModel>> getSafeSpace() {
    return _safeSpaceRepository.getSafeSpaces();
  }

  Stream<List<SafeSpaceModel>> getEnrolledSafeSpaces() {
    return _safeSpaceRepository.getEnrolledSafeSpaces();
  }

  Future<void> addSafeSpace(SafeSpaceModel safeSpace) async {
    await _safeSpaceRepository.addSafeSpace(safeSpace);
  }

  Stream<List<SafeSpaceModel>> getNonEnrolledSafeSpaces() async* {
    final enrolledSafeSpaces =
        await _safeSpaceRepository.getEnrolledSafeSpaces().first;
    final allSafeSpaces = await _safeSpaceRepository.getSafeSpaces().first;

    final nonEnrolledSafeSpaces = allSafeSpaces
        .where((safeSpace) => !enrolledSafeSpaces.any((enrolledSpace) =>
            enrolledSpace.safeSpaceId == safeSpace.safeSpaceId))
        .toList();
    yield nonEnrolledSafeSpaces;
  }

  Future<void> joinSafeSpace(safeSpaceId) async {
    await _safeSpaceRepository.joinSafeSpace(safeSpaceId);
    notifyListeners();
  }

  Future<void> leaveSafeSpace(safeSpace) async {
    await _safeSpaceRepository.leaveSafeSpace(safeSpace);
  }

  Future<void> addSharing(safeSpaceId, sharingPost) async {
    await _safeSpaceRepository.addSharing(safeSpaceId, sharingPost);
    notifyListeners;
  }

  Stream<List<SafeSpacePostModel>> getSafeSpacePosts(String safeSpaceId) {
    notifyListeners();
    return _safeSpaceRepository.getSafeSpacePosts(safeSpaceId);
  }

  Future<CommunityMemberProfile> getOtherUser(userId) async {
    return _patientProfileRepository.getOtherUser(userId);
  }
}
