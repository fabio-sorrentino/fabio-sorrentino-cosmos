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

        // Colore del testo digitato
        style: const TextStyle(color: AppColors.primary, fontSize: 16),

        // Colore del cursore
        cursorColor: AppColors.primary,

        // Nasconde il testo se è una password
        obscureText: widget.isPassword ? isObscured : false,

        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.lightBg.withValues(alpha: 0.8),

          // Colore delle icone
          prefixIconColor: AppColors.primary,
          suffixIconColor: AppColors.primary,

          // Colore del suggerimento
          hintStyle: const TextStyle(color: AppColors.primary),

          hintText: widget.hintText,

          prefixIcon: Icon(widget.prefixIcon),

          // Pulsante mostra/nascondi password
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
