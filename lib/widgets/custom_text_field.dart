import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    required this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() {
    return CustomTextFieldState();
  }
}

class CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 355,
      height: 56,

      child: TextField(
        controller: widget.controller,

        // Color of typed text
        style: const TextStyle(color: AppColors.primary, fontSize: 16),

        // Cursor color
        cursorColor: AppColors.primary,

        //Hides the text if it is a password
        obscureText: widget.isPassword ? isObscured : false,

        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.lightBg.withValues(alpha: 0.8),

          // Icon color
          prefixIconColor: AppColors.primary,
          suffixIconColor: AppColors.primary,

          // Hint color
          hintStyle: const TextStyle(color: AppColors.primary),

          hintText: widget.hintText,

          prefixIcon: Icon(widget.prefixIcon),

          // Show/hide password button
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  icon: Icon(
                    isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
