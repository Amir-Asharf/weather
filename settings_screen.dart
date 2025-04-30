import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) {
                      // TODO: Implement theme switching
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.thermostat,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Temperature Unit'),
                  trailing: DropdownButton<String>(
                    value: '°C',
                    items: const [
                      DropdownMenuItem(
                        value: '°C',
                        child: Text('Celsius'),
                      ),
                      DropdownMenuItem(
                        value: '°F',
                        child: Text('Fahrenheit'),
                      ),
                    ],
                    onChanged: (value) {
                      // TODO: Implement unit switching
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Weather Alerts'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Implement notifications
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.update,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Auto Update'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Implement auto update
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show about dialog
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
