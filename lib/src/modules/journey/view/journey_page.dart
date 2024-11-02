import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/journey_view_model.dart';
import 'new_entry.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final journeyViewModel = Provider.of<JourneyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Entries'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<JourneyViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.entries.isEmpty) {
                  return const Center(child: Text('No entries yet.'));
                }

                return ListView.builder(
                  itemCount: viewModel.entries.length,
                  itemBuilder: (context, index) {
                    final entry = viewModel.entries[index];
                    return ListTile(
                      title: Text(entry.title),
                      subtitle: Text(entry.content),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          viewModel.deleteEntry(entry.id);
                        },
                      ),
                      onTap: () {
                        // Handle entry tap (e.g., navigate to details or edit page)
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewEntryPage()),
              );
            },
            child: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }
}
