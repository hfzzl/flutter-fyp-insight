import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/blocs/auth_bloc.dart';
import '../auth/blocs/auth_event.dart';
import '../auth/models/user_model.dart';

class UserProfile extends StatefulWidget {
  final UserModel user;

  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: Container(), // Remove the back arrow
        centerTitle: true, // Center the title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes the shadow direction
                ),
              ],
            ),
            child: const Divider(
              height: 1.0,
              // color: Colors.transparent, // make the divider transparent
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.displayName ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuItem('Edit Profile', Icons.edit),
                  const SizedBox(height: 16),
                  _buildMenuItem(
                      'My Journey Post', Icons.access_alarm_outlined),
                  const SizedBox(height: 16),
                  _buildMenuItem('Emergency Contact', Icons.phone),
                  const SizedBox(height: 16),
                  _buildMenuItem('Sign Out', Icons.logout, onPressed: _logout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(1, 1), // changes the shadow direction
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  void _logout() {
    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
  }
}
