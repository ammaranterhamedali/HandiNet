import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handi_net_app/models/artisanModel.dart';
import 'package:handi_net_app/models/userModel.dart';
import 'UserProfilePage.dart';
import 'ArtisanProfilePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userType = '';
  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userType = data['userType'] ?? 'Client';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userType == 'Craftsman') {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading artisan profile."));
          }

          final artisanData = snapshot.data!.data() as Map<String, dynamic>;
          final artisan = Artisan.fromMap(artisanData);

          return ArtisanProfilePage(artisan: artisan);
        },
      );
    } else {
  return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading user profile."));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final user = UserModel.fromMap(userData);

          return UserProfilePage(user: user);
        },
      );
    }
  }
}
