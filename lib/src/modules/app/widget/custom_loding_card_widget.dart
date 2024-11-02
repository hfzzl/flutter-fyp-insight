import 'package:flutter/material.dart';

import 'shimmer_load.dart';

class CustomLoadingCardWidget extends StatelessWidget {
  const CustomLoadingCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ShimmerLoad(
      width: double.infinity,
      height: 50,
      borderRadius: BorderRadius.circular(5.0),
    ));
  }
}
