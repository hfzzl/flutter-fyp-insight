import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../app/widget/custom_loding_card_widget.dart';
import '../../app/widget/shimmer_load.dart';
import '../../profile/community_member_profile_view_model.dart';
import '../../profile/community_member_profile_model.dart';
import 'user_info_card_widget.dart';
import 'profile_card_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<CommunityMemberProfileViewModel>(context);
    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        centerTitle: true,
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<CommunityMemberProfile>(
        future: userViewModel.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                ListTile(
                    tileColor: ColorsConstant.white,
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20.0,
                    ),
                    title: ShimmerLoad(
                      width: 100.0,
                      height: 15.0,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    subtitle: ShimmerLoad(
                      width: 100.0,
                      height: 15.0,
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Column(
                    children: [
                      Text("Account Information",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      CustomLoadingCardWidget(),
                      CustomLoadingCardWidget(),
                      CustomLoadingCardWidget(),
                      CustomLoadingCardWidget(),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserInfoCardWidget(profile: snapshot.data!),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text("Account Information",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      ProfileCardWidget(profile: snapshot.data!),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user data available'));
          }
        },
      ),
    );
  }
}
