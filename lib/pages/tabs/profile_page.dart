import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../services/notifications_service.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final email = user?.email ?? 'Guest';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(email),
            subtitle: const Text('Logged in user'),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => NotificationsService.scheduleDailyReminder(8, 0, 'Workout', 'Time to workout!'),
            icon: const Icon(Icons.alarm),
            label: const Text('Schedule daily 08:00 workout reminder'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => NotificationsService.scheduleDailyReminder(20, 0, 'Log Meals', 'Remember to log your meals'),
            icon: const Icon(Icons.alarm),
            label: const Text('Schedule daily 20:00 meal log reminder'),
          ),
        ],
      ),
    );
  }
}
