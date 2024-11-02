import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/shimmer_load.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_model.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_post_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../profile/community_member_profile_model.dart';
import 'add_sharing_form.dart';
import 'safe_space_view_model.dart';

class SafeSpaceSharingView extends StatefulWidget {
  final SafeSpaceModel safeSpace;

  const SafeSpaceSharingView({Key? key, required this.safeSpace})
      : super(key: key);

  @override
  State<SafeSpaceSharingView> createState() => _SafeSpaceSharingViewState();
}

class _SafeSpaceSharingViewState extends State<SafeSpaceSharingView> {
  late Stream<List<SafeSpacePostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Stream<List<SafeSpacePostModel>> _fetchPosts() {
    return SafeSpaceViewModel().getSafeSpacePosts(widget.safeSpace.safeSpaceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: ColorsConstant.primaryDark,
        title: Text(widget.safeSpace.safeSpaceName),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Leave Safe Space'),
                    content: const Text(
                        'Are you sure you want to leave the safe space?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<SafeSpaceViewModel>()
                              .leaveSafeSpace(widget.safeSpace.safeSpaceId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Leave'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topCenter,
            // height: 150,
            decoration: const BoxDecoration(
              color: ColorsConstant.primaryDark,
            ),
            child: Column(children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.safeSpace.safeSpaceImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.safeSpace.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<List<SafeSpacePostModel>>(
                stream: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _postsFuture = _fetchPosts();
                        });
                      },
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            leading: FutureBuilder<CommunityMemberProfile>(
                              future: SafeSpaceViewModel()
                                  .getOtherUser(post.userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return CircleAvatar(
                                    backgroundImage: snapshot
                                            .data!.imageUrl.isNotEmpty
                                        ? NetworkImage(snapshot.data!.imageUrl)
                                        : const AssetImage(
                                                "assets/images/default_profile_picture.jpg")
                                            as ImageProvider,
                                  );
                                } else {
                                  // Placeholder in case the user data is still loading
                                  return const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/default_profile_picture.jpg"),
                                  );
                                }
                              },
                            ),
                            title: FutureBuilder<CommunityMemberProfile>(
                              future: SafeSpaceViewModel()
                                  .getOtherUser(post.userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Row(
                                    children: [
                                      Text('${snapshot.data?.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Text(
                                          DateFormat('dd MMM yyyy  h:mm a')
                                              .format(post.timestamp.toDate()),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          )),
                                    ],
                                  );
                                } else {
                                  return ShimmerLoad(
                                    width: 100,
                                    height: 20,
                                    borderRadius: BorderRadius.circular(5),
                                  );
                                }
                              },
                            ),
                            subtitle: Text(post.content),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No posts found");
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.primaryDark,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSharingForm(safeSpace: widget.safeSpace),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
