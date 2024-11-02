import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../app/widget/custom_text_field_widget.dart';
import '../../app/widget/custom_elevated_button_widget.dart';
import '../../profile/community_member_profile_model.dart';
import '../../profile/community_member_profile_view_model.dart';

class ProfileFormWidget extends StatefulWidget {
  final CommunityMemberProfile? profile;
  const ProfileFormWidget({Key? key, this.profile}) : super(key: key);

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  Future<String>? _uploadingImage;
  bool tempImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _phoneController =
        TextEditingController(text: widget.profile?.phoneNumber ?? '');
    _bioController = TextEditingController(text: widget.profile?.bio ?? '');
    _imageUrl = widget.profile?.imageUrl;
    _uploadingImage = Future.value('');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CommunityMemberProfileViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _uploadingImage =
                          viewModel.uploadTempImage(File(pickedFile.path));
                      //  print('Image uploaded $_uploadingImage');
                      tempImage = true;
                    });
                  }
                },
                child: FutureBuilder<String>(
                  future: _uploadingImage,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 75,
                              height: 75,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.pink),
                              ),
                            ),
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // imageChild = const Icon(Icons.error);
                    } else if (tempImage == true) {
                      return Stack(children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage(viewModel.tempImageUrl!),
                        ),
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.bottomRight,
                            icon: const Icon(Icons.delete_rounded,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                viewModel.tempImageUrl = null;
                                _uploadingImage = Future.value('');
                              });
                            },
                          ),
                        ),
                      ]);
                    }
                    return Stack(children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.profile!.imageUrl),
                      ),
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.bottomRight,
                          icon: const Icon(Icons.delete_rounded,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              viewModel.imageUrl = null;
                              _uploadingImage = Future.value('');
                            });
                          },
                        ),
                      ),
                    ]);
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              const Text('Profile Image'),
              const SizedBox(height: 8.0),
              CustomTextField(
                controller: _nameController,
                hintText: 'Username',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your username' : null,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _bioController,
                hintText: 'Bio',
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your bio' : null,
              ),
              const SizedBox(height: 16.0),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    CommunityMemberProfile profile = CommunityMemberProfile(
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                        bio: _bioController.text,
                        imageUrl: _imageUrl ?? '',
                        email: '');
                    viewModel.saveProfile(profile);
                  }
                },
                buttonText: const Text('Complete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
