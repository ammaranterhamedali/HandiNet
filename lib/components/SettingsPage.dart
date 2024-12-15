import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/components/startPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const StartPage();
        },
      ));
    } catch (e) {
      showMessage(context, message: "Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              leading: Icon(Icons.logout, color: Colors.red),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
