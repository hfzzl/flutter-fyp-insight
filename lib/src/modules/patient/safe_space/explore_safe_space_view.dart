import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/safe_space/safe_space_model.dart';
import 'package:insight/src/utils/colors.dart';
import 'package:provider/provider.dart';

import 'safe_space_form_view.dart';
import 'safe_space_view_model.dart';

//Class to display the explore safe space screen
class ExploreSafeSpaceView extends StatelessWidget {
  const ExploreSafeSpaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SafeSpaceViewModel>(context);
     
    return  Scaffold(
      body: StreamBuilder<List<SafeSpaceModel>>(
        stream: viewModel.getNonEnrolledSafeSpaces(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty){
            return const Center(child: Text("No Safe Spaces available"));
          } else if (snapshot.hasData){
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                final safeSpace = snapshot.data![index];
                return Card(
                  child: ListTile(
                    onTap: () {
                    },
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.gray,
                      backgroundImage: AssetImage(safeSpace.safeSpaceImage),
                    ),
                    title: Text(safeSpace.safeSpaceName),
                    subtitle: Text(safeSpace.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {
                        viewModel.joinSafeSpace(safeSpace.safeSpaceId);
                      },
                    )
                  ),
                );
              }
            );
          }
          return const SizedBox.shrink();
        }        
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsConstant.primaryDark,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SafeSpaceFormView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
    );
  }
}