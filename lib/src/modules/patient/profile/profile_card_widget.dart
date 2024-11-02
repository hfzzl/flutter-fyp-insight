import 'package:flutter/material.dart';
import 'package:insight/src/modules/profile/community_member_profile_model.dart';
import 'package:provider/provider.dart';
import '../../auth_new/user_view_model.dart';
import '../emergency_contact/emergency_contact_view.dart';
import '../emergency_contact/emergency_contact_view_model.dart';
import '../journey/my_journey_post.dart';
import 'edit_profile_view.dart';

class ProfileOption {
  final IconData icon;
  final String title;
  final Function(BuildContext) onTap;
  ProfileOption({required this.icon, required this.title, required this.onTap});
}

class ProfileCardWidget extends StatelessWidget {
  final CommunityMemberProfile profile;

  const ProfileCardWidget({Key? key, required this.profile}) : super(key: key);

  List<ProfileOption> getOptions(BuildContext context) => [
        ProfileOption(
          icon: Icons.person_2_rounded,
          title: "Edit Profile",
          onTap: (context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileView(
                          profile: profile,
                        )));
          },
        ),
        ProfileOption(
          icon: Icons.post_add_rounded,
          title: "My Journey Post",
          onTap: (context) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyJourneyPost()));
          },
        ),
        ProfileOption(
          icon: Icons.emergency_rounded,
          title: "Emergency Contact",
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) =>
                      EmergencyContactViewModel(), // Assuming EmergencyContactViewModel is the model you want to provide
                  child: const EmergencyContactView(),
                ),
              ),
            );
          },
        ),
        ProfileOption(
          icon: Icons.logout_rounded,
          title: "Log Out",
          onTap: (context) {
            Navigator.of(context).pushReplacementNamed('/');
            context.read<UserViewModel>().signOut();
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    List<ProfileOption> options = getOptions(context);
    return Column(
      children: options.map((option) => _buildCard(context, option)).toList(),
    );
  }

  Widget _buildCard(BuildContext context, ProfileOption option) {
    return Card(
      child: ListTile(
        onTap: () => option.onTap(context),
        leading: Icon(option.icon),
        title: Text(option.title),
      ),
    );
  }
}
