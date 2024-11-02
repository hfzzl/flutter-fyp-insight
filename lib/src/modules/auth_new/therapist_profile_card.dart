import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'therapist_profile.dart';

class TherapistProfileCard extends StatelessWidget {
  const TherapistProfileCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final TherapistProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: ColorsConstant.primaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profile.imageUrl),
          ),
          const SizedBox(height: 10),
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profile.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profile.specialization,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
