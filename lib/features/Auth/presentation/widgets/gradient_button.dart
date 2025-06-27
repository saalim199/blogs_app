import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const GradientButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPallete.gradient1, AppPallete.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          fixedSize: Size(395, 55),
        ),
        onPressed: onPressed,
        child: Text(buttonText, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
