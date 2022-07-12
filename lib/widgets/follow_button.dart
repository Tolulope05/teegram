import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  const FollowButton({
    Key? key,
    required this.text,
    required this.textColor,
    this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: onPressed!,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          width: 250,
          height: 27,
        ),
      ),
    );
  }
}
