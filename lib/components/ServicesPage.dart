import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/booking.dart';
import 'package:handi_net_app/models/artisanModel.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> services = [
    {
      'name': 'Carpentry',
      'icon': Icons.handyman,
      'description': 'Woodworking, furniture repair, and custom builds.',
      'image':
          'https://imgcdn.stablediffusionweb.com/2024/9/17/45d1baeb-339f-4d82-9d33-79e48652cebb.jpg',
    },
    {
      'name': 'Plumbing',
      'icon': Icons.plumbing,
      'description':
          'Fixing leaks, installing pipes, and plumbing maintenance.',
      'image':
          'https://centraljerseyins.com/wp-content/uploads/2024/06/plumber-fixing-sink.jpg',
    },
    {
      'name': 'Electrical',
      'icon': Icons.lightbulb,
      'description': 'Wiring, repairs, and electrical installations.',
      'image':
          'https://tristateec.com/wp-content/uploads/2021/04/2021-03-working-on-high-voltage-industrial-electrical-project-chattnooga.jpg',
    },
    {
      'name': 'Painting',
      'icon': Icons.format_paint,
      'description': 'Interior and exterior painting for homes and offices.',
      'image':
          'https://images.pexels.com/photos/1070536/pexels-photo-1070536.jpeg?cs=srgb&dl=pexels-steve-1070536.jpg&fm=jpg',
    },
    {
      'name': 'Air Conditioning',
      'icon': Icons.ac_unit,
      'description': 'AC installation, repair, and maintenance services.',
      'image':
          'https://www.shutterstock.com/image-photo/hvac-technician-performing-air-conditioner-600nw-2488702851.jpg',
    },
    {
      'name': 'Cleaning',
      'icon': Icons.cleaning_services,
      'description': 'Professional cleaning services for homes and offices.',
      'image':
          'https://rapidweblaunch.com/wp-content/uploads/2022/11/cleaning-website-examples-collage.jpg',
    },
  ];

  List<Artisan> artisans = [];

  @override
  void initState() {
    super.initState();
    _loadArtisans();
  }

  Future<void> _loadArtisans() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'Craftsman')
        .get();

    final List<Artisan> loadedArtisans = snapshot.docs.map((doc) {
      return Artisan.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      artisans = loadedArtisans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Services',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.all(10.0),
            elevation: 5.0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsPage(
                      service: service,
                      artisans: artisans,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                    child: Image.network(
                      service['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            service['description'],
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ServiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> service;
  final List<Artisan> artisans;

  const ServiceDetailsPage(
      {super.key, required this.service, required this.artisans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title:
            Text(service['name'], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  service['image'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF000000).withAlpha((0.6 * 255).toInt()),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    service['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(service['description'],
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BookingConfirmationPage(
                              service: service,
                              artisans: artisans,
                            );
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Book now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
