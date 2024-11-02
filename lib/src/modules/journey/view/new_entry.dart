import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/journey_entry.dart';
import 'package:provider/provider.dart';

import '../viewmodel/journey_view_model.dart';

class NewEntryPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final content = _contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  // Get the current user ID
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final userId = user.uid;

                    // Create a new JourneyEntry
                    final newEntry = JourneyEntry(
                      id: '',
                      title: title,
                      content: content,
                      createdAt: DateTime.now(),
                    );

                    // Add the entry to Firestore under the user's subcollection
                    final docRef = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('entries')
                        .add({
                      'title': newEntry.title,
                      'content': newEntry.content,
                      'createdAt': newEntry.createdAt,
                    });

                    // Update the entry with the Firestore ID
                    newEntry.id = docRef.id;

                    // Add the entry to the ViewModel
                    final journeyViewModel =
                        Provider.of<JourneyViewModel>(context, listen: false);
                    journeyViewModel.addEntry(newEntry);

                    // Go back to the previous screen
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
