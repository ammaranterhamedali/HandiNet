import 'package:flutter/material.dart';
import 'package:handi_net_app/components/ArtisanProfilePage.dart';
import 'package:handi_net_app/models/artisanModel.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> service;
  final List<Artisan> artisans;

  const BookingConfirmationPage({
    super.key,
    required this.service,
    required this.artisans,
  });

  @override
  Widget build(BuildContext context) {
    List<Artisan> filteredArtisans = artisans.where((artisan) {
      return artisan.specialty.toLowerCase().trim() ==
          service['name'].toString().toLowerCase().trim();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Confirm Booking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  service['image'] ?? '',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                service['name'] ?? 'Service Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                service['description'] ?? 'Service Description',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Divider(height: 30, thickness: 1.2),
              const Text(
                'Available Artisans',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredArtisans.length,
                itemBuilder: (context, index) {
                  final artisan = filteredArtisans[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        _navigateToConfirmation(
                          context,
                          artisan,
                        );
                      },
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            artisan.profilePictureUrl,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          artisan.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Specialty: ${artisan.specialty}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Location: ${artisan.location}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToConfirmation(BuildContext context, Artisan artisan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtisanProfilePage(artisan: artisan),
      ),
    );
  }
}
