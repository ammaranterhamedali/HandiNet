import 'package:flutter/material.dart';
import 'package:handi_net_app/components/ProfileDetailRow.dart';
import 'package:handi_net_app/components/chatPage.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/models/artisanModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtisanProfilePage extends StatefulWidget {
  const ArtisanProfilePage({super.key, required this.artisan});
  final Artisan artisan;

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final List<String> workSampleUrls = [
      'https://www.upflip.com/wp-content/uploads/2024/09/Handyman-maintenance-skills.jpg',
      'https://imgcdn.stablediffusionweb.com/2024/9/17/45d1baeb-339f-4d82-9d33-79e48652cebb.jpg',
      'https://www.shutterstock.com/image-photo/hvac-technician-performing-air-conditioner-600nw-2488702851.jpg',
      'https://img.freepik.com/free-photo/man-electrical-technician-working-switchboard-with-fuses_169016-24062.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.artisan.fullName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  widget.artisan.profilePictureUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.artisan.fullName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: workSampleUrls.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      workSampleUrls[index],
                                      height: 200,
                                      width: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileDetailRow(
                              icon: Icons.info,
                              label: 'Bio',
                              value: widget.artisan.bio,
                            ),
                            const Divider(color: Colors.grey),
                            ProfileDetailRow(
                              icon: Icons.location_on,
                              label: 'Location',
                              value: widget.artisan.location,
                            ),
                            const Divider(color: Colors.grey),
                            ProfileDetailRow(
                              icon: Icons.phone,
                              label: 'Phone Number',
                              value: widget.artisan.mobile,
                            ),
                            const Divider(color: Colors.grey),
                            ProfileDetailRow(
                              icon: Icons.work,
                              label: 'Specialty',
                              value: widget.artisan.specialty,
                            ),
                            const Divider(color: Colors.grey),
                            ProfileDetailRow(
                              icon: Icons.star,
                              label: 'Experience',
                              value: '${widget.artisan.experience} years',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final String phoneNumber = widget.artisan.mobile;
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: phoneNumber);

                              try {
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(
                                    phoneUri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  if (mounted) {
                                    showMessage(context,
                                        message:
                                            'Unable to open the phone dialer.');
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  showMessage(context, message: 'Error: $e');
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Call Now',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ChatPage(
                                    email: widget.artisan.email,
                                  );
                                }),
                              );
                            },
                            icon: const Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Message',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
