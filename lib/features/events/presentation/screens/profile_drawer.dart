import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/events_provider.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(scannerSettingsProvider);
    const brandColor = Color(0xFF4F46E5);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: brandColor),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
            accountName: const Text(
              "Ariq Ngonesh",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("ericokip402@gmail.com"),
            otherAccountsPictures: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text("Sync"),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text("Sound"),
            value: settings['sound']!,
            onChanged: (_) =>
                ref.read(scannerSettingsProvider.notifier).toggleSound(),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text("Vibration"),
            value: settings['vibration']!,
            onChanged: (_) =>
                ref.read(scannerSettingsProvider.notifier).toggleVibration(),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
