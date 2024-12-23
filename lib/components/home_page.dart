import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/ArtisanProfilePage.dart';
import 'package:handi_net_app/components/ServicesPage.dart';
import 'package:handi_net_app/components/SettingsPage.dart';
import 'package:handi_net_app/components/chatPage.dart';
import 'package:handi_net_app/components/notification_page.dart';
import 'package:handi_net_app/components/post_job_page.dart';
import 'package:handi_net_app/components/post_list_page.dart';
import 'package:handi_net_app/components/profilePage.dart';
import 'package:handi_net_app/models/artisanModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.email});
  final String email;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    _pages = [
      const MainHomePage(),
      const PostListPage(),
      const ServicesPage(),
      const ProfilePage(),
      ChatPage(email: widget.email),
      const NotificationsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostJobPage()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  String searchQuery = '';
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Plumbing',
    'Carpentry',
    'Electrical',
    'Painting',
    'Cleaning',
    'Air Conditioning',
  ];

  Future<List<Artisan>> fetchArtisans() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'Craftsman')
        .get();

    return snapshot.docs.map((doc) {
      return Artisan.fromMap(doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade700,
              Colors.blueGrey.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Search artisans...',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Categories Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(82, 24, 8, 8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text(
                    "Select a Category",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  dropdownColor: Colors.teal,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 30,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories
                      .map<DropdownMenuItem<String>>((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                )),
              ),
            ),
            const SizedBox(height: 20),

            // Featured Artisans Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Featured Artisans',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Artisan>>(
                future: fetchArtisans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No artisans found!',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final artisans = snapshot.data!
                      .where((artisan) =>
                          artisan.fullName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          artisan.specialty
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          artisan.location
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                      .where((artisan) =>
                          selectedCategory == 'All' ||
                          artisan.specialty == selectedCategory)
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: artisans.length,
                    itemBuilder: (context, index) {
                      final artisan = artisans[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: ClipOval(
                            child: Image.network(
                              artisan.profilePictureUrl,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(artisan.fullName),
                          subtitle: Text(
                            'Specialty: ${artisan.specialty}\nExperience: ${artisan.experience} years',
                          ),
                          dense: true,
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtisanProfilePage(
                                    artisan: artisan,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
