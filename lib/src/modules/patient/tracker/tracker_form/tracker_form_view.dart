import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/colors.dart';
import '../../../app/widget/custom_snack_bar_widget.dart';
import '../sobriety_tracker_model.dart';
import '../sobriety_tracker_view_model.dart';

// Class to display the sobriety tracker form
class TrackerFormView extends StatefulWidget {
  const TrackerFormView({Key? key}) : super(key: key);

  @override
  State<TrackerFormView> createState() => _TrackerFormViewState();
}

class _TrackerFormViewState extends State<TrackerFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addictionController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final SobrietyTrackerViewModel _viewModel = SobrietyTrackerViewModel();

// List of suggestions for addiction type
  final List<String> suggestions = [
    'Alcohol',
    'Smoking',
    'Gambling',
    'Self-harm',
    'Drugs',
    'Cigarettes',
    'Eating Disorder',
  ];

// Selected date and time
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Method to create InputChip
  Widget buildInputChip(String value) {
    return InputChip(
      backgroundColor: ColorsConstant.primaryDark,
      label: Text(value),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      ),
      onPressed: () {
        setState(() {
          addictionController.text = value;
        });
      },
    );
  }

  Future<void>? _savingData;

  @override
  Widget build(BuildContext context) {
    suggestions.sort((a, b) => a.compareTo(b));

    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Start Tracking'),
        backgroundColor: ColorsConstant.primaryDark,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Text field for addiction type
                const Text('What are you getting sober from?',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addictionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsConstant.primaryDark),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your addiction type';
                    }
                    return null;
                  },
                ),
                Wrap(
                  spacing: 3.0,
                  runSpacing: -10.0,
                  children: suggestions.map(buildInputChip).toList(),
                ),
                const SizedBox(height: 10),
                // Text field for start date
                const Text('When did you start?',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsConstant.primaryDark),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onTap: () async {
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
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Text field for goal
                const Text('I want to stop my addiction because...',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: goalController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsConstant.primaryDark),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your goal';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // Button to submit the form
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsConstant.secondary,
              minimumSize: const Size(64, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Parse the selected date
                DateTime selectedDate =
                    DateFormat.yMMMd().parse(dateController.text);

                // Calculate the streak as the difference in days between today and the selected date
                int streak = DateTime.now().difference(selectedDate).inDays;

                final trackerData = SobrietyTrackerModel(
                  id: '',
                  startDate: dateController.text,
                  startTime: TimeOfDay.now().format(context),
                  sobriety: addictionController.text,
                  goal: goalController.text,
                  streak: streak,
                );

                _viewModel.addSobrietyTracker(trackerData);
                setState(() {
                  _savingData = _viewModel.addSobrietyTracker(trackerData);
                });

                _savingData!.whenComplete(() {
                  Navigator.of(context).pop();
                });
              } else {
                showCustomSnackBar(
                  context,
                  'Please fill in all fields',
                );
              }
            },
            // Display the button text based on the state of the form submission
            child: FutureBuilder<void>(
              future: _savingData,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                } else {
                  return const Text('Start Tracking');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
