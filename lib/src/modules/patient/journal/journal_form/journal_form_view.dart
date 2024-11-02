// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:insight/src/modules/patient/journal/journal_form/delete_dialog_widget.dart';
import 'package:insight/src/modules/patient/journal/journal_model.dart';
import 'package:intl/intl.dart';
import '../../../../utils/colors.dart';
import '../../../app/widget/custom_snack_bar_widget.dart';
import '../journal_view_model.dart';

// Class to display the journal form

class JournalFormView extends StatefulWidget {
  final JournalModel? journal;

  const JournalFormView({Key? key, this.journal}) : super(key: key);

  @override
  State<JournalFormView> createState() => _JournalFormViewState();
}

class _JournalFormViewState extends State<JournalFormView> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = JournalViewModel();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController moodController =
      TextEditingController(); // Controller for mood
  DateTime selectedDate = DateTime.now();
  String selectedMood = '😊';
  var parser = EmojiParser();
  Future<void>? _savingData;

  @override
  void initState() {
    super.initState();
    if (widget.journal != null) {
      _initializeFormWithJournalData();
    }
  }

  void _initializeFormWithJournalData() {
    titleController.text = widget.journal!.title;
    contentController.text = widget.journal!.content;
    dateController.text = widget.journal!.date;
    selectedMood = stringToEmoji(widget.journal!.mood);
    selectedDate = DateFormat.yMMMd().parse(widget.journal!.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Journal Entry'),
        backgroundColor: ColorsConstant.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (widget.journal != null) {
                final confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return const DeleteDialogWidget();
                  },
                );
                if (confirmDelete == true) {
                  _viewModel.deleteJournal(widget.journal!);
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorsConstant.primaryDark),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
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
                    ),
                    const SizedBox(width: 10), // Spacing between the fields
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedMood,
                          decoration: const InputDecoration(
                            labelText: 'Mood',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 17.0,
                                horizontal:
                                    10.0), // Adjust padding to match the TextFormField
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorsConstant.primaryDark),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMood = newValue!;
                            });
                          },
                          items: <String>['😊', '😢', '😠', '😌', '😰']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
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
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'What\'s on your mind today?',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contentController,
                  maxLines: 20,
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
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
                // Here you can handle your data saving logic
                if (widget.journal != null) {
                  final journalData = JournalModel(
                    id: widget.journal!.id,
                    title: titleController.text,
                    content: contentController.text,
                    mood: emojiToString(selectedMood),
                    date: dateController.text,
                    time: TimeOfDay.now().format(context),
                  );

                  _viewModel.updateJournal(journalData);

                  setState(() {
                    _savingData = Future.delayed(const Duration(seconds: 2));
                  });
                  _savingData!.whenComplete(() {
                    Navigator.of(context).pop();
                  });
                } else {
                  final journalData = JournalModel(
                    id: '${dateController.text} ${TimeOfDay.now().format(context)}',
                    title: titleController.text,
                    content: contentController.text,
                    mood: emojiToString(selectedMood),
                    date: dateController.text,
                    time: TimeOfDay.now().format(context),
                  );

                  _viewModel.addJournal(journalData);
                  setState(() {
                    _savingData = Future.delayed(const Duration(seconds: 2));
                  });
                  _savingData!.whenComplete(() {
                    Navigator.of(context).pop();
                  });
                }
              } else {
                showCustomSnackBar(
                  context,
                  'Please fill in all fields',
                );
              }
            },
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
                  return const Text('Save Entry');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

String emojiToString(String emoji) {
  switch (emoji) {
    case '😊':
      return 'Happy';
    case '😢':
      return 'Sad';
    case '😠':
      return 'Angry';
    case '😌':
      return 'Relaxed';
    case '😰':
      return 'Anxious';
    default:
      return 'Unknown';
  }
}

String stringToEmoji(String mood) {
  switch (mood) {
    case 'Happy':
      return '😊';
    case 'Sad':
      return '😢';
    case 'Angry':
      return '😠';
    case 'Relaxed':
      return '😌';
    case 'Anxious':
      return '😰';
    default:
      return '';
  }
}
