import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/tracker/sobriety_tracker_model.dart';
import 'package:insight/src/modules/patient/tracker/tracker_form/tracker_form_view.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import 'sobriety_tracker_view_model.dart';
import 'tracker_form/tracker_review_view.dart';

// Class to display the sobriety tracker screen

class SobrietyTrackerView extends StatelessWidget {
  const SobrietyTrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SobrietyTrackerViewModel>();
    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
          title: const Text('Sobriety Tracker'),
          backgroundColor: ColorsConstant.primaryDark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: StreamBuilder<List<SobrietyTrackerModel>>(
        stream: viewModel.getSobrietyTrackers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tracker = snapshot.data![index];
                return Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackerReviewView(
                              sobrietyTracker: tracker,
                            ),
                          ),
                        );
                      },
                      tileColor: ColorsConstant.white,
                      title: Text(tracker.sobriety),
                      subtitle: Text(
                        'Started on ${tracker.startDate}',
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
                              builder: (context) => TrackerReviewView(
                                sobrietyTracker: tracker,
                              ),
                            ),
                          );
                        },
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Start tracking your sobriety journey!'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const TrackerFormView(),
        ),
        backgroundColor: ColorsConstant.primaryDark,
        child: const Icon(Icons.add),
      ),
    );
  }
}
