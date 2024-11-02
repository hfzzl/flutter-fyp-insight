import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'admin_view_model.dart';
import 'therapist_model.dart';
import 'view_therapist_details.dart';

class ViewTherapistList extends StatelessWidget {
  final AdminViewModel viewModel = AdminViewModel();

  ViewTherapistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstant.primaryDark,
        title: const Text('Verify Therapists'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            Expanded(
              child: StreamBuilder<List<TherapistModel>>(
                stream: viewModel.getApprovedTherapistsList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No therapists found'));
                  }
                  final therapists = snapshot.data!;
                  return ListView.builder(
                    itemCount: therapists.length,
                    itemBuilder: (context, index) {
                      final therapist = therapists[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: therapist.imageUrl.isNotEmpty
                                ? NetworkImage(therapist.imageUrl)
                                : const AssetImage(
                                        'assets/images/placeholder.png')
                                    as ImageProvider,
                          ),
                          title: Text(therapist
                              .fullName), // Changed from therapist.name
                          subtitle: Text(therapist.specialization),
                          onTap: () {
                            // Navigator.of(context).pushNamed('/therapistDetails', arguments: therapist);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewTherapistDetails(therapist)));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
