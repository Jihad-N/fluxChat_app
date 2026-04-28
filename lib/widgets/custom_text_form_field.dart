import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.text,
    required this.icon,
    required this.onChanged,
    this.isObscureText = false,
  });
  final String text;
  final Icon icon;
  final bool? isObscureText;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'field is required';
        } else
          return null;
      },
      onChanged: onChanged,
      obscureText: isObscureText!,
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
