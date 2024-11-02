import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import 'journal_form/journal_form_view.dart';
import 'journal_view_model.dart';
import 'journal_model.dart';

// Class to display the journal entries
class JournalView extends StatelessWidget {
  const JournalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accessing JournalViewModel using Provider
    final journalViewModel = Provider.of<JournalViewModel>(context);

    return Scaffold(
      body: StreamBuilder<List<JournalModel>>(
        stream: journalViewModel.getJournals(), // Use stream instead of future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Show message if there are no journal entries
            return const Center(
                child: Text("Let's start writing your feelings"));
          } else if (snapshot.hasData) {
            // Display journal entries if data is available
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final journal = snapshot.data![index];
                return Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalFormView(
                              journal: journal,
                            ),
                          ),
                        );
                      },
                      title: Text(journal.title), // Display journal title
                      subtitle: Text(
                        journal.date,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JournalFormView(
                                journal: journal,
                              ),
                            ),
                          );
                        },
                      )),
                );
              },
            );
          } else {
            // Fallback for other states
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.primaryDark,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const JournalFormView(
            journal: null,
          ),
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
