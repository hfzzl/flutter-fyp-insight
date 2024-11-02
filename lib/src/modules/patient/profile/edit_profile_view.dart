import 'package:flutter/material.dart';
import 'package:insight/src/modules/profile/community_member_profile_model.dart';

import '../../../utils/colors.dart';
import 'profile_form_widget.dart';

class EditProfileView extends StatelessWidget {
  final CommunityMemberProfile profile;

  const EditProfileView({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: ColorsConstant.primaryDark,
            centerTitle: true,
            title: const Text('Edit Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileFormWidget(profile: profile),
          ],
        ));
  }
}
