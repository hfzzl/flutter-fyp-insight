import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import 'therapist_approved_view.dart';
import 'therapist_in_review_view.dart';
import 'therapist_profile_view_model.dart';
import 'user_view_model.dart';

//Class to display the therapist screen after login

class TherapistScreen extends StatefulWidget {
  const TherapistScreen({super.key});

  @override
  State<TherapistScreen> createState() => _TherapistScreenState();
}

class _TherapistScreenState extends State<TherapistScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TherapistProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('INSIGHT'),
        backgroundColor: ColorsConstant.primaryDark,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              context.read<UserViewModel>().signOut();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: viewModel.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching profile'));
          } else {
            final profile = snapshot.data;
            if (profile?.status == 'reviewing') {
              return TherapistInReviewView(profile: profile!);
            } else if (profile?.status == 'approved') {
              return TherapistApprovedView(profile: profile!);
            } else if (profile?.status == 'rejected') {
              return const Center(
                  child: Text(
                'Your application has been rejected \nPlease contact support for more information',
                textAlign: TextAlign.center,
              ));
            } else {
              return const Center(child: Text('Unknown status'));
            }
          }
        },
      ),
    );
  }
}
