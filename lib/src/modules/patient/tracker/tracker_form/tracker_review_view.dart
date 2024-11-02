import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:insight/src/modules/patient/tracker/sobriety_tracker_model.dart';
import 'package:insight/src/utils/colors.dart';
import 'package:intl/intl.dart';

import '../../../app/widget/custom_alert_box_dialog_widget.dart';
import '../sobriety_tracker_view_model.dart';

class TrackerReviewView extends StatefulWidget {
  // final String trackerId;
  final SobrietyTrackerModel sobrietyTracker;

  const TrackerReviewView({
    Key? key,
    required this.sobrietyTracker,
  }) : super(key: key);

  @override
  State<TrackerReviewView> createState() => _TrackerReviewView();
}

class _TrackerReviewView extends State<TrackerReviewView> {
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  SobrietyTrackerViewModel viewModel = SobrietyTrackerViewModel();
  int _progress = 0;
  bool _resetStreak = false;
  var parser = EmojiParser();

  List<Widget> _questions = [];

  @override
  void initState() {
    super.initState();

    _questions = [
      ListTile(
        title: const Text('Question 1'),
        trailing: Checkbox(
          value: _resetStreak,
          onChanged: (value) {
            setState(() {
              _resetStreak = value ?? false;
              _progress++;
            });
            if (_resetStreak) {
              // Reset the streak and set the date started back to today
              // You need to call your ViewModel here
            }
          },
        ),
      ),
      // Add more questions here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        title: const Text('Review Your Day'),
        automaticallyImplyLeading: false,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 35.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(parser.emojify(':fire:')),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'I\'ve been ${widget.sobrietyTracker.id} free for ${widget.sobrietyTracker.streak} days! ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(parser.emojify(':fire:')),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.all(20.0),
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
              // color: ColorsConstant.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have you involve with any ${widget.sobrietyTracker.id.toLowerCase()} today?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstant.purple,
                        ),
                        onPressed: () {
                          // Call your ViewModel here
                          SobrietyTrackerModel updatedTracker =
                              SobrietyTrackerModel(
                            id: widget.sobrietyTracker.id,
                            sobriety: widget.sobrietyTracker.sobriety,
                            startDate: DateFormat('MMM d, yyyy')
                                .format(DateTime.now()),
                            startTime: TimeOfDay.now().format(context),
                            goal: widget.sobrietyTracker.goal,
                            streak: 0, // Reset the streak
                          );
                          Navigator.of(context).pop();

                          // Call the ViewModel to update the tracker
                          viewModel.updateSobrietyTracker(updatedTracker);
                          showDialog(
                            context: context,
                            builder: (context) => const CustomAlertDialog(
                              title: 'You\'ve Got This!',
                              content:
                                  'No worries, your streak has been reset. Let\'s jump back in and keep the momentum going!',
                              buttonText: 'OK',
                              icon: Icons.restart_alt,
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstant.greenDark,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (context) => const CustomAlertDialog(
                              title: 'Great Job!',
                              content:
                                  'You\'ve reached a new milestone. Keep up the fantastic work!',
                              buttonText: 'OK',
                              icon: Icons.fireplace_rounded,
                            ),
                          );
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),

            // Display the current question based on the _progress value
            // if (_progress < _questions.length) _questions[_progress],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures the column takes minimal space
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstant.secondary,
                  minimumSize: const Size(600, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  // Button 1 action
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      dateController.text =
                          DateFormat.yMMMd().format(selectedDate);
                    });
                    SobrietyTrackerModel updatedTracker = SobrietyTrackerModel(
                      id: widget.sobrietyTracker.id,
                      sobriety: widget.sobrietyTracker.sobriety,
                      startDate: DateFormat('MMM d, yyyy')
                          .format(selectedDate), // Updated start date
                      startTime: widget.sobrietyTracker.startTime,
                      goal: widget.sobrietyTracker.goal,
                      streak: widget
                          .sobrietyTracker.streak, // Keep the current streak
                    );
                    // Call the ViewModel to update the tracker
                    viewModel.updateSobrietyTracker(updatedTracker);
                    // Navigator.of(context).pop();
                  }
                },
                child: const Text('Adjust Start Date'),
              ),
              const SizedBox(height: 5),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: ColorsConstant.scaffoldBackground,
                ),
                onPressed: () {
                  viewModel.deleteSobrietyTracker(widget.sobrietyTracker);
                  Navigator.of(context).pop();
                },
                child: const Text('Delete Tracker',
                    style: TextStyle(color: ColorsConstant.danger)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
