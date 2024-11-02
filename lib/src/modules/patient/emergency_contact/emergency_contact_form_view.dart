import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import 'emergency_contact_model.dart';
import 'emergency_contact_view_model.dart';

// Class for displaying the emergency contact form

class EmergencyContactFormView extends StatefulWidget {
  final EmergencyContactModel? emergencyContact;

  const EmergencyContactFormView({
    Key? key,
    this.emergencyContact,
  }) : super(key: key);

  @override
  State<EmergencyContactFormView> createState() =>
      _EmergencyContactFormViewState();
}

class _EmergencyContactFormViewState extends State<EmergencyContactFormView> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = EmergencyContactViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  Future<void>? _savingData;

  @override
  void initState() {
    super.initState();
    if (widget.emergencyContact != null) {
      _nameController.text = widget.emergencyContact!.name;
      _phoneController.text = widget.emergencyContact!.phoneNumber;
      _relationshipController.text = widget.emergencyContact!.relationship;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        backgroundColor: ColorsConstant.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          widget.emergencyContact != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this emergency contact?'),
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
                                _viewModel.deleteEmergencyContact(
                                    widget.emergencyContact!);
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                                Navigator.of(context)
                                    .pop(); // Go back to the previous screen
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone No.',
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
                    return 'Please enter a phone number';
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
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
                    return 'Please enter a relationship';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
            onPressed: _saveContact,
            child: FutureBuilder<void>(
              future: _savingData,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                } else {
                  return const Text('Save');
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingData = Future.delayed(const Duration(seconds: 2));
      });
      _savingData!.whenComplete(() {
        final emergencyContactData = EmergencyContactModel(
          id: '',
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          relationship: _relationshipController.text,
        );

        if (widget.emergencyContact != null) {
          _viewModel.updateEmergencyContact(
              widget.emergencyContact?.id, emergencyContactData);
          Navigator.of(context).pop();
        } else {
          _viewModel.addEmergencyContact(emergencyContactData);
          Navigator.of(context).pop(emergencyContactData);
        }
      });
    }
  }
}
