import 'package:flutter/material.dart';
import '../../profile/community_member_profile_model.dart';
import '../../../utils/colors.dart';

class UserInfoCardWidget extends StatelessWidget {
  final CommunityMemberProfile profile;

  const UserInfoCardWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ColorsConstant.white,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profile.imageUrl),
        backgroundColor: Colors.grey.shade200,
        onBackgroundImageError: (exception, stackTrace) =>
            const Icon(Icons.account_circle, size: 40.0),
      ),
      title: Text(
        profile.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(profile.email),
    );
  }
}
