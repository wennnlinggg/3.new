import 'package:flutter/material.dart';
import 'notification_settings_page.dart';
import 'security_settings_page.dart';

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
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationSettingsPage())),
                        ),
                        const Divider(height: 1),
                          ListTile(
                            title: const Text('Security settings'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SecuritySettingsPage())),
                          ),
                          const Divider(height: 1),
                        // Recommendations moved to Energy page
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
                  const SizedBox(height: 32),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // navigate to login and clear stack
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                      },
                      child: const Text('Log out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
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
