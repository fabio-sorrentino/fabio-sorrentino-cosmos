import '../data/demo_user.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';

import 'package:provider/provider.dart';

import '../providers/user_lists_provider.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final lists = context.watch<UserListsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: scheme.primary,
                backgroundImage: const AssetImage(
                  'assets/images/avatar-cosmos.png',
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DemoUser.name,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              DemoUser.email,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(
                  icon: Icons.movie_outlined,
                  value: '${lists.seenMoviesCount}',
                ),
                _Stat(icon: Icons.tv, value: '${lists.seenSeriesCount}'),
                _Stat(
                  icon: Icons.favorite_border,
                  value: '${lists.favoritesCount}',
                ),
              ],
            ),
            const SizedBox(height: 24),

            Divider(color: scheme.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 8),

            _ProfileTile(
              icon: Icons.settings_outlined,
              label: 'Impostazioni',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),

            _ProfileTile(
              icon: Icons.logout,
              label: 'Logout',
              color: scheme.error,
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Stat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Icon(icon, size: 24),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileTile({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? Theme.of(context).colorScheme.primary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: tileColor),
      title: Text(
        label,
        style: TextStyle(color: tileColor, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
