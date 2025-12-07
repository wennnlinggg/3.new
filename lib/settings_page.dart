import 'package:flutter/material.dart';
// NOTE: avoid importing the large `image_pages.dart` while it has compile errors.
// Navigation targets here use simple placeholder pages instead.

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.green.shade100, Colors.green.shade50.withAlpha(153)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('General', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Notification settings'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: const Text('Notifications')), body: const Center(child: Text('Notification settings (placeholder)'))))),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Security settings'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: const Text('Security')), body: const Center(child: Text('Security settings (placeholder)'))))),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Dark mode of plugins'),
                          trailing: Switch(value: false, onChanged: (_) {}),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text('Language & region', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(title: const Text('Region'), trailing: const Icon(Icons.chevron_right)),
                        const Divider(height: 1),
                        ListTile(title: const Text('Language'), trailing: const Icon(Icons.chevron_right)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
