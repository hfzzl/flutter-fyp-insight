import 'package:flutter/material.dart';
import 'package:insight/src/utils/colors.dart';

class HomeTrackerButtonWidget extends StatelessWidget {
  const HomeTrackerButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                  color: ColorsConstant.greenDark.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: const Icon(
                    Icons.track_changes, 
                    size: 30, 
                    color: ColorsConstant.background
                    )
                  ),
              const SizedBox(width: 10),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                    'Sobriety Tracker',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Track your sobriety journey',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )              
            ],
          ),
        ),
      ],
    );
  }
}