import 'package:flutter/material.dart';
import 'package:insight/src/modules/auth_new/therapist_model.dart';
import '../../utils/colors.dart';
import 'admin_view_model.dart';
import 'therapist_details_widget.dart'; // Ensure this import is correct

class VerifyTherapistForm extends StatelessWidget {
  final TherapistModel therapist;
  const VerifyTherapistForm(this.therapist, {super.key});

  @override
  Widget build(BuildContext context) {
    AdminViewModel viewModel = AdminViewModel();
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
      body: TherapistDetailsWidget(therapist), // Use the extracted widget here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstant.secondary,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await viewModel.approveTherapist(therapist.userId);
                  Navigator.of(context).pop();
                },
                child: const Text('APPROVE'),
              ),
              const SizedBox(height: 10),
              TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await viewModel.rejectTherapist(therapist.userId);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
