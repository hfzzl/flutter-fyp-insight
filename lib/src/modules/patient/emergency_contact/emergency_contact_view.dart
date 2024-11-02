import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insight/src/utils/colors.dart';
import 'emergency_contact_form_view.dart';
import 'emergency_contact_view_model.dart';
import 'emergency_contact_model.dart';

// Class for displaying the emergency contact list
class EmergencyContactView extends StatelessWidget {
  const EmergencyContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmergencyContactViewModel>(context);
    return Scaffold(
      backgroundColor: ColorsConstant.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Emergency Contact'),
        backgroundColor: ColorsConstant.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<EmergencyContactModel>>(
        stream: viewModel.getEmergencyContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("No emergency contacts found"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final contact = snapshot.data![index];
                return Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text('${contact.name} (${contact.relationship})'),
                    subtitle: Text(
                      contact.phoneNumber,
                      style: const TextStyle(
                        color: ColorsConstant.blue,
                        fontSize: 12,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit,
                          color: ColorsConstant.primaryDark),
                      onPressed: () {
                        // Navigate to contact form for editing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmergencyContactFormView(
                                emergencyContact: contact),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to contact form for adding a new contact
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmergencyContactFormView(),
            ),
          );
        },
        backgroundColor: ColorsConstant.primaryDark,
        child: const Icon(Icons.add),
      ),
    );
  }
}
