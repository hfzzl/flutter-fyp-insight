import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_model.dart';
import 'package:insight/src/utils/colors.dart';
import 'safe_space_sharing_view.dart';
import 'safe_space_view_model.dart';

// Class to display the user's enrolled safe spaces
class MySafeSpaceView extends StatelessWidget {
  const MySafeSpaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SafeSpaceViewModel>(context);

    return Scaffold(
      body: StreamBuilder<List<SafeSpaceModel>>(
        stream: viewModel.getEnrolledSafeSpaces(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("No Enrolled Safe Spaces available"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final safeSpace = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.gray,
                      backgroundImage: AssetImage(safeSpace.safeSpaceImage), 
                    ),
                    title: Text(safeSpace.safeSpaceName),
                    subtitle: Text(safeSpace.description),
                    onTap: () {
                      // Navigate to the SafeSpaceFormView with the selected SafeSpace
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SafeSpaceSharingView(
                            safeSpace: safeSpace,
                          ),
                        ),
                      );
                    }
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}