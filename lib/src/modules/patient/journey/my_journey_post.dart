import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import 'journey_model.dart';
import 'journey_view_model.dart';

class MyJourneyPost extends StatefulWidget {
  const MyJourneyPost({Key? key}) : super(key: key);

  @override
  State<MyJourneyPost> createState() => _MyJourneyPostState();
}

class _MyJourneyPostState extends State<MyJourneyPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsConstant.primaryDark,
      ),
      body: StreamProvider<List<JourneyModel>>.value(
        value: Provider.of<JourneyViewModel>(context, listen: false)
            .getMyJourneys(),
        initialData: const [],
        child: Consumer<List<JourneyModel>>(
          builder: (context, journeyList, child) {
            return ListView.builder(
              itemCount: journeyList.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(journeyList[index].content),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy  h:mm a')
                          .format(journeyList[index].timestamp.toDate()),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure you want to delete this journey post?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    // Perform the delete operation
                                    Provider.of<JourneyViewModel>(context,
                                            listen: false)
                                        .deleteJourney(
                                            journeyList[index].journeyPostId);
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog after the operation
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ));
              },
            );
          },
        ),
      ),
    );
  }
}
