import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final IconData? icon;

  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonText,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, title, content, buttonText, icon),
    );
  }
}

dialogContent(BuildContext context, String title, String content,
    String buttonText, IconData? icon) {
  return Stack(
    children: <Widget>[
      //...bottom card part,
      Container(
        padding: const EdgeInsets.only(
          top: Consts.avatarRadius + Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: const EdgeInsets.only(top: Consts.avatarRadius),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        left: Consts.padding,
        right: Consts.padding,
        child: CircleAvatar(
          backgroundColor: ColorsConstant.primaryDark,
          radius: Consts.avatarRadius,
          child: Icon(icon ?? Icons.info),
        ),
      ),
    ],
  );
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 30.0;
}
