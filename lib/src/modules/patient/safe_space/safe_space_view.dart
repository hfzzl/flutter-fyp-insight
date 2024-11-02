import 'package:flutter/material.dart';
import 'package:insight/src/utils/colors.dart';

import 'explore_safe_space_view.dart';
import 'my_safe_space_view.dart';

//Class to display the safe space screen
class SafeSpaceView extends StatefulWidget {
  const SafeSpaceView({Key? key}) : super(key: key);

  @override
  State<SafeSpaceView> createState() => _SafeSpaceViewState();
}

class _SafeSpaceViewState extends State<SafeSpaceView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Material(
            color: ColorsConstant.primaryDark,
            child: TabBar(
              indicatorColor: ColorsConstant.primary,
              controller: _tabController,
              tabs: const [
                Tab(text: 'My Safe Space'),
                Tab(text: 'Explore Safe Spaces'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MySafeSpaceView(),
                ExploreSafeSpaceView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
