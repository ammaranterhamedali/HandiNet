import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handi_net_app/components/ProfileDetailRow.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/models/userModel.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            user = UserModel.fromMap(data);
            isLoading = false;
          });
        } else {
          if (mounted) {
            showMessage(context, message: "User document does not exist.");
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, message: "Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.fullName ?? 'User Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('No user data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow(
                        icon: Icons.person,
                        label: 'Name',
                        value: user!.fullName,
                      ),
                      ProfileDetailRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: user!.email,
                      ),
                      ProfileDetailRow(
                        icon: Icons.location_on,
                        label: 'Location',
                        value: user!.location,
                      ),
                      ProfileDetailRow(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        value: user!.mobile,
                      ),
                      ProfileDetailRow(
                        icon: Icons.verified_user,
                        label: 'User Type',
                        value: user!.userType,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
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
    );
  }
}
