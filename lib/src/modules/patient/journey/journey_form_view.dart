import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../app/widget/custom_text_field_widget.dart';
import 'journey_view_model.dart';

//Class for the journey form to be filled by the user
class JourneyFormView extends StatelessWidget {
  const JourneyFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final viewModel = JourneyViewModel();

    return Scaffold(
        backgroundColor: ColorsConstant.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: ColorsConstant.primaryDark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Journey Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: contentController,
                  hintText: 'Share your journey...',
                  maxLines: 13,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsConstant.secondary,
                minimumSize: const Size(64, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                viewModel.addJourney(
                  contentController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Share Journey'),
            ),
          ),
        ));
  }
}
