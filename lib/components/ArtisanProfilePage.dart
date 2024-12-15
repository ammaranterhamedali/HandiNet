import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handi_net_app/components/ProfileDetailRow.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/models/artisanModel.dart';

class ArtisanProfilePage extends StatefulWidget {
  const ArtisanProfilePage({super.key});

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  Artisan? artisan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArtisanData();
  }

  Future<void> _fetchArtisanData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            artisan = Artisan.fromMap({
              'email': data['email'] ?? 'Not Provided',
              'fullName': data['fullName'] ?? 'Not Provided',
              'bio': data['bio'] ?? 'No bio available',
              'location': data['location'] ?? 'Not Provided',
              'mobile': data['mobile'] ?? 'Not Provided',
              'specialty': data['specialty'] ?? 'Not Provided',
              'experience': data['experience'] ?? 'Not Provided',
            });
            isLoading = false;
          });
        } else {
          if (!mounted) return;
          showMessage(context, message: "Artisan document does not exist.");
        }
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(context, message: "Error fetching artisan data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artisan?.fullName ?? 'Artisan Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artisan == null
              ? const Center(child: Text('No artisan data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow(
                        icon: Icons.person,
                        label: 'Name',
                        value: artisan!.fullName,
                      ),
                      ProfileDetailRow(
                        icon: Icons.info,
                        label: 'Bio',
                        value: artisan!.bio,
                      ),
                      ProfileDetailRow(
                        icon: Icons.location_on,
                        label: 'Location',
                        value: artisan!.location,
                      ),
                      ProfileDetailRow(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        value: artisan!.mobile,
                      ),
                      ProfileDetailRow(
                        icon: Icons.work,
                        label: 'Specialty',
                        value: artisan!.specialty,
                      ),
                      ProfileDetailRow(
                        icon: Icons.star,
                        label: 'Experience',
                        value: '${artisan!.experience} years',
                      ),
                    ],
                  ),
                ),
    );
  }
}
