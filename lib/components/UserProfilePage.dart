import 'package:flutter/material.dart';
import 'package:handi_net_app/components/EditProfilePageForUser.dart';
import 'package:handi_net_app/components/ProfileDetailRow.dart';
import 'package:handi_net_app/models/userModel.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.user});
  final UserModel user;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.user.fullName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 16,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget
                                    .user.profilePicture ??
                                "https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg"),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.user.userType.isNotEmpty)
                      Text(
                        widget.user.userType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 20),
                    ProfileDetailRow(
                      icon: Icons.person,
                      label: 'Name',
                      value: widget.user.fullName,
                    ),
                    ProfileDetailRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: widget.user.email,
                    ),
                    ProfileDetailRow(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: widget.user.location,
                    ),
                    ProfileDetailRow(
                      icon: Icons.phone,
                      label: 'Phone Number',
                      value: widget.user.mobile ?? 'Not Provided',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(user: widget.user),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
