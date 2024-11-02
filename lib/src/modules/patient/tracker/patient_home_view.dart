import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/shimmer_load.dart';
import 'package:insight/src/modules/profile/community_member_profile_model.dart';
import 'package:insight/src/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../profile/community_member_profile_view_model.dart';
import '../quotes/quote_widget.dart';
import 'home_tracker_button_widget.dart';
import 'sobriety_tracker_view.dart';
import 'sobriety_tracker_view_model.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({Key? key}) : super(key: key);

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  Future<CommunityMemberProfile>? _userProfileFuture;

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<CommunityMemberProfileViewModel>(context, listen: false);
    _userProfileFuture = viewModel.getProfile();

    Future.delayed(Duration.zero, () {
      final trackerViewModel =
          Provider.of<SobrietyTrackerViewModel>(context, listen: false);
      trackerViewModel.updateStreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 150,
          decoration: const BoxDecoration(
            color: ColorsConstant.primaryDark,
          ),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FutureBuilder<CommunityMemberProfile>(
                future: _userProfileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return _buildProfile(snapshot.data);
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            _buildQuoteContainer(),
            _buildTrackerTitle(),
            _buildTrackerButton(),
            const SizedBox(height: 20),
            // _buildEmptyContainer(),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        ShimmerLoad(
          width: double.infinity,
          height: 25,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildProfile(CommunityMemberProfile? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          '${profile?.name}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1, 1),
          ),
        ],
      ),
      height: 160,
      child: const QuoteWidget(),
    );
  }

  Widget _buildTrackerTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: const Text(
        'Tracker',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTrackerButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SobrietyTrackerView()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(1, 1),
            ),
          ],
        ),
        height: 80,
        child: const HomeTrackerButtonWidget(),
      ),
    );
  }
}
