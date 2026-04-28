import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: profileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
