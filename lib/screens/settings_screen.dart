import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark mode'),
          subtitle: const Text('Choose a comfortable appearance'),
          value: theme.mode == ThemeMode.dark,
          onChanged: theme.toggle,
        )),
        const SizedBox(height: 12),
        const Card(child: ListTile(leading: Icon(Icons.lock_outline), title: Text('Your data stays on this device'), subtitle: Text('Transactions are stored locally using SQLite.'))),
        const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('Expense Tracker'), subtitle: Text('Version 1.0.0'))),
      ]),
    );
  }
}
