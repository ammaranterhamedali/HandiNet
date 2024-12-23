import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a sample notification message'),
            leading: const Icon(
              Icons.notifications,
              color: Colors.teal,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
