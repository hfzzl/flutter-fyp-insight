import 'package:flutter/material.dart';
import 'package:insight/src/utils/colors.dart';

import '../../app/widget/custom_text_field_widget.dart';
import 'safe_space_model.dart';
import 'safe_space_view_model.dart';

//Class to display the add sharing form screen for the safe space
class AddSharingForm extends StatefulWidget {
  final SafeSpaceModel safeSpace;

  const AddSharingForm({Key? key, required this.safeSpace}) : super(key: key);

  @override
  State<AddSharingForm> createState() => _AddSharingFormState();
}

class _AddSharingFormState extends State<AddSharingForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = SafeSpaceViewModel();
  Future<void>? _savingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsConstant.primaryDark,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomTextField(
                controller: _descriptionController,
                hintText: 'Share your thoughts...',
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Don\'t forget to share your thoughts!';
                  }
                  return null;
                },
              ),
            ]),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _savingData = _viewModel.addSharing(
                      widget.safeSpace.safeSpaceId,
                      _descriptionController.text);
                  _savingData!.whenComplete(() {
                    Navigator.of(context).pop();
                  });
                });
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
                  return const Text('Submit');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
