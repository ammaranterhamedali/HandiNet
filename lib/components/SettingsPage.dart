import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/components/startPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StartPage(),
          ));
    } catch (e) {
      showMessage(context, message: "Error logging out: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
