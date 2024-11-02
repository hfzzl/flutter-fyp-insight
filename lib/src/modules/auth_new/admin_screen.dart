import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/modules/auth_new/view_therapist_list.dart';
import '../../utils/colors.dart';
import 'user_view_model.dart';
import 'verify_therapist_view.dart';

//Class to display the admin screen
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user =
        context.select((UserViewModel userViewModel) => userViewModel.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        title: const Text('INSIGHT'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: ColorsConstant.primaryDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // const SizedBox(height: 5),
                  const Text(
                    'Welcome back,',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.reviews_rounded),
                      title: const Text('Verify Therapists'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyTherapistView(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('View Therapists'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewTherapistList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
