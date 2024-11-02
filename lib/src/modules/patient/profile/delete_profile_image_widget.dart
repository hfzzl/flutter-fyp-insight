import 'package:flutter/material.dart';

class DeleteProfileImageWidget extends StatelessWidget{
  const DeleteProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        // Delete the profile image
      },
    );
  }
}