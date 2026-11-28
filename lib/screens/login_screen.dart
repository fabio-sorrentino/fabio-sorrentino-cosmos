import 'package:flutter/material.dart';

import '../data/demo_user.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/main_shell.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Error message displayed below the fields (null = no error)
  String? _error;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    String? error;
    if (email.isEmpty || password.isEmpty) {
      error = 'Inserisci email e password';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      error = 'Email non valida';
    } else if (email != DemoUser.email || password != DemoUser.password) {
      error = 'Email o password errate';
    }

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    // Correct credentials: opens the Home page and removes the Login from the history
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                          Color(0xFF050522),
                          AppColors.primary,
                          Color(0xFF11116D),
                        ]
                      : const [
                          Color(0xFFF4FCFF),
                          AppColors.surfaceLight,
                          Color(0xFF90DDE9),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -110,
            right: -85,
            child: _GlowOrb(
              size: 300,
              color: AppColors.tertiary.withValues(alpha: isDark ? 0.16 : 0.2),
            ),
          ),
          Positioned(
            bottom: -155,
            left: -110,
            child: _GlowOrb(
              size: 340,
              color: AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.14),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.hoverPrimary : Colors.white)
                          .withValues(alpha: isDark ? 0.84 : 0.82),
                      border: Border.all(
                        color: (isDark ? Colors.white : AppColors.primary)
                            .withValues(alpha: 0.14),
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(
                            alpha: isDark ? 0.24 : 0.1,
                          ),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.tertiary.withValues(alpha: 0.28),
                                AppColors.secondary.withValues(alpha: 0.12),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.tertiary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/cosmos-logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'COSMOS CINEMA',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'La tua prossima storia comincia qui.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
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

                        // Error message (appears only if _error is not null)
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),

                        PrimaryButton(label: 'Accedi', onPressed: _submit),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
