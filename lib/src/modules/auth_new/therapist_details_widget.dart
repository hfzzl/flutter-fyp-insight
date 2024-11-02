import 'package:flutter/material.dart';
import 'therapist_model.dart'; // Adjust the import path as necessary

class TherapistDetailsWidget extends StatelessWidget {
  final TherapistModel therapist;
  const TherapistDetailsWidget(this.therapist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 5),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(therapist.imageUrl),
          ),
          const SizedBox(height: 5),
          const Text('Details',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Full Name'),
                  subtitle: Text(therapist.fullName),
                ),
                ListTile(
                  title: const Text('Email'),
                  subtitle: Text(therapist.email),
                ),
                ListTile(
                  title: const Text('Specialization'),
                  subtitle: Text(therapist.specialization),
                ),
                ListTile(
                  title: const Text('Phone Number'),
                  subtitle: Text(therapist.phoneNo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
