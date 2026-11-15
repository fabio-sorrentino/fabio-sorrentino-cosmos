import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/cosmos-logo.png',
                      height: 96,
                      width: 114,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text('COSMOS CINEMA'),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      isPassword: false,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      prefixIcon: Icons.lock_outlined,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(label: 'Accedi')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
