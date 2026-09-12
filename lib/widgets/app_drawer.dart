import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AppDrawer extends ConsumerWidget {
  final Function(int) onTabSelect;

  // to allow the drawer to communicate with the bottom navbar and change the screen when a tile is selected
  const AppDrawer({super.key, required this.onTabSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Color(0xFFD9D9D9),
            title: const Icon(Icons.menu),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              onTabSelect(0);
            },
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Tasks List'),
            onTap: () {
              Navigator.of(context).pop();
              onTabSelect(1);
            },
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.assignment_add),
            title: const Text('Add Task'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/add_task');
            },
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Tracker'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/progress_tracker');
            },
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          Expanded(child: SizedBox.expand()),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              onTabSelect(3);
            },
          ),
        ],
      ),
    );
  }
}
