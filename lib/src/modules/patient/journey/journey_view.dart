import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/shimmer_load.dart';
import 'package:insight/src/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../profile/community_member_profile_model.dart';
import 'journey_form_view.dart';
import 'journey_model.dart';
import 'journey_view_model.dart';

//Class for displaying the posts by the user
class JourneyView extends StatelessWidget {
  const JourneyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journeyViewModel = Provider.of<JourneyViewModel>(context);

    return Scaffold(
      body: StreamBuilder<List<JourneyModel>>(
        stream: journeyViewModel.getJourneys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("Let's start your journey"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final journey = snapshot.data![index];
                return FutureBuilder<CommunityMemberProfile>(
                  future: Provider.of<JourneyViewModel>(context, listen: false)
                      .getOtherUser(journey.userId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Card(
                          child: ShimmerLoad(width: 10, height: 50));
                    } else if (userSnapshot.hasError) {
                      return const ListTile(
                        leading: Icon(Icons.error),
                        title: Text('Failed to load user'),
                      );
                    } else if (userSnapshot.hasData) {
                      final user = userSnapshot.data!;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.imageUrl.isNotEmpty
                                ? NetworkImage(user.imageUrl)
                                : const AssetImage(
                                        "assets/images/default_profile_picture.jpg")
                                    as ImageProvider,
                            backgroundColor: Colors.grey.shade200,
                            onBackgroundImageError: (exception, stackTrace) =>
                                const Icon(Icons.account_circle, size: 40.0),
                          ),
                          title: Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                  DateFormat('dd MMM yyyy  h:mm a')
                                      .format(journey.timestamp.toDate()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                          subtitle: Text(
                            journey.content,
                            style: const TextStyle(
                              color: ColorsConstant.grey,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.primaryDark,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JourneyFormView(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: ColorsConstant.white,
        ),
      ),
    );
  }
}
