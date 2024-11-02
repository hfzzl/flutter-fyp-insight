import 'package:flutter/material.dart';

import 'therapist_profile.dart';
import 'therapist_profile_card.dart';

class TherapistInReviewView extends StatelessWidget {
  const TherapistInReviewView({
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
        const SizedBox(height: 20),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Your account is still in reviewing process. Please wait for the admin to approve your account.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
