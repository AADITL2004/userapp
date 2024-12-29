import 'package:flutter/material.dart';
import 'homepage.dart';
import 'test_page.dart';
import 'admin/dashboard.dart'; // Import UserTablePage
import 'package:amplify_flutter/amplify_flutter.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('user'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UserListScreen(), // Navigate to UserTablePage
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Sampling Mode'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(), // Navigate to homepage.dart
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Testing Mode'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Test(), // Navigate to testpage.dart
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () => Amplify.Auth.signOut(),
          ),
        ],
      ),
    );
  }
}
