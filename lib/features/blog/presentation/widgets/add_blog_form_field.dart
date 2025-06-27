import 'package:flutter/material.dart';

class AddBlogFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const AddBlogFormField({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $hintText' : null,
    );
  }
}
