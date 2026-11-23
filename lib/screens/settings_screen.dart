import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme;
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Aspetto',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('Tema', style: textTheme.bodyMedium)),
              //Button Light Mode
              _ModeButton(
                icon: Icons.wb_sunny_outlined,
                label: 'Tema chiaro',
                selected: !isDark,
                onTap: () {
                  debugPrint('Sole premuto');
                  context.read<ThemeProvider>().setThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(width: 12),
              //Button Dark Mode
              _ModeButton(
                icon: Icons.nightlight_outlined,
                label: 'Tema scuro',
                selected: isDark,
                onTap: () {
                  debugPrint('Luna premuta');
                  context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'This product uses the TMDB API but is not endorsed or certified by TMDB.',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = dark ? AppColors.secondary : AppColors.tertiary;
    final iconColor = dark ? AppColors.lightBg : AppColors.primary;

    return Semantics(
      label: label,
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: selected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? activeBg : iconColor.withValues(alpha: 0.5),
            ),
          ),
          child: Icon(icon, size: 28, color: iconColor),
        ),
      ),
    );
  }
}
