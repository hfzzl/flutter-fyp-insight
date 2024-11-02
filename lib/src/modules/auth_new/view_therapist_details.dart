import 'package:flutter/material.dart';
import 'package:insight/src/modules/auth_new/therapist_model.dart';
import '../../utils/colors.dart';
import 'therapist_details_widget.dart'; // Ensure this import is correct

class ViewTherapistDetails extends StatelessWidget {
  final TherapistModel therapist;
  const ViewTherapistDetails(this.therapist, {super.key});

  @override
  Widget build(BuildContext context) {
    // AdminViewModel viewModel = AdminViewModel();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        title: Text(therapist.fullName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: TherapistDetailsWidget(therapist), 
    );
  }
}