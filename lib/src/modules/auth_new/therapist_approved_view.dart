import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_view.dart';

import 'therapist_profile.dart';
import 'therapist_profile_card.dart';

class TherapistApprovedView extends StatelessWidget {
  const TherapistApprovedView({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final TherapistProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TherapistProfileCard(profile: profile),
        const Flexible(
          child: SafeSpaceView(),
        ),
      ],
    );
  }
}
