import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/journey/journey_model.dart';

import '../../profile/community_member_profile_model.dart';
import '../../profile/community_member_profile_repository.dart';
import 'journey_repository.dart';

//view model class for the journey module

class JourneyViewModel extends ChangeNotifier {
  final JourneyRepository _journeyRepository = JourneyRepository();
  final CommunityMemberProfileRepository _patientProfileRepository =
      CommunityMemberProfileRepository();

  Future<void> addJourney(content) async {
    await _journeyRepository.addJourney(content);
  }

  Stream<List<JourneyModel>> getJourneys() {
    return _journeyRepository.getJourneys();
  }

  Future<void> deleteJourney(journeyId) async {
    await _journeyRepository.deleteJourney(journeyId);
  }

  Future<CommunityMemberProfile> getOtherUser(userId) async {
    return _patientProfileRepository.getOtherUser(userId);
  }

  Stream<List<JourneyModel>> getMyJourneys() {
    return _journeyRepository.getMyJourneys();
  }
}
