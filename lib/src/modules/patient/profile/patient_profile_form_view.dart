import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/modules/app/widget/custom_elevated_button_widget.dart';
import 'package:insight/src/modules/profile/community_member_profile_model.dart';
import 'package:provider/provider.dart';

import '../../app/widget/custom_text_field_widget.dart';
import '../../profile/community_member_profile_view_model.dart';
import '../../auth_new/user_view_model.dart';

class MemberProfileFormView extends StatefulWidget {
  const MemberProfileFormView({
    super.key,
  });

  @override
  State<MemberProfileFormView> createState() => _MemberProfileFormViewState();
}

class _MemberProfileFormViewState extends State<MemberProfileFormView> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Future<String>? _uploadingImage;
  Future<void>? _savingProfile;

  @override
  void initState() {
    super.initState();
    _uploadingImage = Future.value('');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityMemberProfileViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const Text('Complete your Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<UserViewModel>().signOut();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _uploadingImage =
                            viewModel.uploadImage(File(pickedFile.path));
                      });
                    }
                  },
                  child: FutureBuilder<String>(
                    future: _uploadingImage, // your Future
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.pink),
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
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: viewModel.imageUrl != null
                                        ? Colors.transparent
                                        : Colors.grey,
                                    image: viewModel.imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                viewModel.imageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: viewModel.imageUrl == null
                                      ? const Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                if (viewModel.imageUrl != null)
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
                              ],
                            );
                          }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text('Profile Picture'),
                const SizedBox(height: 8.0),

                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        hintText: 'Username',
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        hintText: 'Phone Number',
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: _bioController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your bio';
                          }
                          return null;
                        },
                        hintText: 'Bio',
                      ),
                      // ...
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Submit button
                CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a Snackbar.
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(const SnackBar(content: Text('Processing Data')));

                      const emptyPicture =
                          'https://firebasestorage.googleapis.com/v0/b/insight-utm.appspot.com/o/public-image%2Fdefault_profile_picture.jpg?alt=media&token=2fdbba9c-7e50-4f90-bd23-2940c2874c05';

                      final profile = CommunityMemberProfile(
                          name: _nameController.text,
                          phoneNumber: _phoneController.text,
                          bio: _bioController.text,
                          imageUrl: viewModel.imageUrl ?? emptyPicture,
                          email: '');
                      viewModel.saveProfile(profile);

                      setState(() {
                        _savingProfile = viewModel.saveProfile(
                            profile); // Set the _savingProfile future
                      });
                      _savingProfile!.whenComplete(() {
                        Navigator.of(context).pushReplacementNamed('/user');
                      });
                    }
                  },
                  buttonText: FutureBuilder<void>(
                    future: _savingProfile,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      } else {
                        return const Text('Complete Profile');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
