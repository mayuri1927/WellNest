import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../app/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          const SectionHeader(title: 'Appearance'),
          CustomCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6,
                  title: 'Theme',
                  subtitle: themeMode == ThemeMode.system ? 'System' : themeMode == ThemeMode.dark ? 'Dark' : 'Light',
                  onTap: () => _showThemeDialog(context, ref, themeMode),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          const SectionHeader(title: 'Account'),
          CustomCard(
            child: Column(
              children: [
                _SettingsTile(icon: Icons.email, title: 'Email', subtitle: authState.value?.userEmail ?? 'Not set'),
                const Divider(),
                _SettingsTile(icon: Icons.lock, title: 'Change Password', subtitle: 'Update your password', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          const SectionHeader(title: 'Notifications'),
          CustomCard(
            child: Column(
              children: [
                _SettingsSwitch(icon: Icons.notifications, title: 'Push Notifications', value: true, onChanged: (v) {}),
                const Divider(),
                _SettingsSwitch(icon: Icons.email, title: 'Email Notifications', value: false, onChanged: (v) {}),
                const Divider(),
                _SettingsSwitch(icon: Icons.calendar_today, title: 'Appointment Reminders', value: true, onChanged: (v) {}),
                const Divider(),
                _SettingsSwitch(icon: Icons.medication, title: 'Medicine Reminders', value: true, onChanged: (v) {}),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          const SectionHeader(title: 'About'),
          CustomCard(
            child: Column(
              children: [
                _SettingsTile(icon: Icons.info, title: 'App Version', subtitle: '1.0.0'),
                const Divider(),
                _SettingsTile(icon: Icons.description, title: 'Terms of Service', onTap: () {}),
                const Divider(),
                _SettingsTile(icon: Icons.privacy_tip, title: 'Privacy Policy', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).setThemeMode(v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).setThemeMode(v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).setThemeMode(v!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: AppColors.textSecondary)) : null,
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({required this.icon, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    );
  }
}
