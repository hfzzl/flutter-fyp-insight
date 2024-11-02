import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insight/src/modules/app/widget/loading_page.dart';
import 'package:insight/src/modules/patient/tracker/sobriety_tracker_view_model.dart';
import 'package:provider/provider.dart';
import 'src/modules/auth_new/admin_screen.dart';
import 'src/modules/auth/views/login_screen.dart';
import 'src/modules/auth_new/admin_view_model.dart';
import 'src/modules/auth_new/therapist_screen.dart';
import 'src/modules/auth_new/therapist_profile_form_view.dart';
import 'src/modules/auth_new/therapist_profile_repository.dart';
import 'src/modules/auth_new/therapist_profile_view_model.dart';
import 'src/modules/patient/journey/journey_view_model.dart';
import 'src/modules/patient/profile/patient_profile_form_view.dart';
import 'src/modules/auth_new/register_view.dart';
import 'src/modules/auth_new/user_repository.dart';
import 'src/modules/auth_new/user_view_model.dart';
import 'src/modules/patient/safe_space/safe_space_view_model.dart';
import 'src/modules/profile/community_member_profile_repository.dart';
import 'src/modules/profile/community_member_profile_view_model.dart';
import 'src/modules/patient/user_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  FirebaseAppCheck.instance.activate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(UserRepository())),
        ChangeNotifierProvider(
            create: (_) => CommunityMemberProfileViewModel(
                repository: CommunityMemberProfileRepository())),
        ChangeNotifierProvider(
            create: (_) => TherapistProfileViewModel(
                repository: TherapistProfileRepository())),
        ChangeNotifierProvider(create: (context) => SobrietyTrackerViewModel()),
        ChangeNotifierProvider(create: (context) => SafeSpaceViewModel()),
        ChangeNotifierProvider(create: (context) => JourneyViewModel()),
        ChangeNotifierProvider(create: (context) => AdminViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage(); // Show loading spinner while waiting for auth state
                } else {
                  final user = snapshot.data;
                  context.read<UserViewModel>().user =
                      user; // Update the UserViewModel with the current user
                  if (user == null) {
                    return const LoginScreen();
                  } else {
                    // Fetch the role of the user from Firestore and return the appropriate screen
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPage(); // Show loading spinner while waiting for user data
                        } else {
                          final userRole = snapshot.data!.get('role');
                          if (userRole == 'admin') {
                            return const AdminScreen();
                          } else if (userRole == 'therapist') {
                            if (snapshot.data!.get('isProfileComplete') ==
                                false) {
                              return const TherapistProfileFormView();
                            } else {
                              return const TherapistScreen();
                            }
                            // return TherapistScreen();
                          } else {
                            if (snapshot.data!.get('isProfileComplete') ==
                                false) {
                              return const MemberProfileFormView();
                            } else {
                              return const UserHomePage();
                            }
                          }
                        }
                      },
                    );
                  }
                }
              },
            ),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        '/admin': (context) => const AdminScreen(),
        '/therapist': (context) => const TherapistScreen(),
        '/user': (context) => const UserHomePage(),
        '/complete-profile': (context) => const MemberProfileFormView(),
        '/complete-profile-therapist': (context) =>
            const TherapistProfileFormView(),
      },
    );
  }
}
