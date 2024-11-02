import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors.dart';

class ShimmerLoad extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoad({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorsConstant.grayLight,
      highlightColor: ColorsConstant.grayAccent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12.0),
          color: ColorsConstant.background,
        ),
      ),
    );
  }
}
