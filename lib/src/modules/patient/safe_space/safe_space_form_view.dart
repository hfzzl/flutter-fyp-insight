import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/custom_text_field_widget.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_model.dart';

import '../../../utils/colors.dart';
import '../../app/widget/custom_snack_bar_widget.dart';
import 'safe_space_view_model.dart';

//Class to show the form for creating a new safe space
class SafeSpaceFormView extends StatefulWidget {
  const SafeSpaceFormView({Key? key}) : super(key: key);

  @override
  State<SafeSpaceFormView> createState() => _SafeSpaceFormViewState();
}

class _SafeSpaceFormViewState extends State<SafeSpaceFormView> {
  final _viewModel = SafeSpaceViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedAvatarPath;
  bool _isAvatarSelected = false;
  final _formKey = GlobalKey<FormState>();
  Future<void>? _savingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        title: const Text('Safe Space Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Safe Space Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the safe space';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Choose Safe Space avatar'),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    for (var i = 1; i <= 6; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatarPath =
                                'assets/images/safe_space_avatar/safe_space_$i.jpg';
                            _isAvatarSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: _selectedAvatarPath ==
                                  'assets/images/safe_space_avatar/safe_space_$i.jpg'
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsConstant.secondary,
                                    width: 1.5,
                                  ),
                                )
                              : null,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: ColorsConstant.primary,
                            backgroundImage: AssetImage(
                                'assets/images/safe_space_avatar/safe_space_$i.jpg'),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
                if (!_isAvatarSelected) {
                  showCustomSnackBar(
                    context,
                    'Please select an avatar',
                  );
                } else {
                  setState(() {
                    SafeSpaceModel safeSpace = SafeSpaceModel(
                      description: _descriptionController.text,
                      safeSpaceImage: _selectedAvatarPath!,
                      createdTime: DateTime.now().toString(),
                      creatorId: '',
                      safeSpaceId: '',
                      safeSpaceName: _nameController.text,
                    );
                    _savingData = _viewModel.addSafeSpace(safeSpace);
                  });
                  _savingData!.whenComplete(() {
                    Navigator.of(context).pop();
                  });
                }
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
