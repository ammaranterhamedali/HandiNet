import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/chatPage.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:intl/intl.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No posts available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index].data() as Map<String, dynamic>;

              String title = post['title'] ?? 'No Title';
              String description = post['description'] ?? 'No Description';
              String category = post['category'] ?? 'No Category';
              String location = post['location'] ?? 'No Location';
              String budget = post['budget'] ?? 'No Budget';
              String status = post['status'] ?? 'No Status';
              String userName = post['userName'] ?? 'Unknown User';
              String userEmail = post['email'] ?? 'Unknown@example.com';

              String deadline = 'No Deadline';
              if (post['deadline'] is Timestamp) {
                deadline = DateFormat('dd/MM/yyyy')
                    .format((post['deadline'] as Timestamp).toDate());
              }

              String createdAt = '';
              if (post['createdAt'] is Timestamp) {
                createdAt = DateFormat('dd/MM/yyyy')
                    .format((post['createdAt'] as Timestamp).toDate());
              }

 
              String postId = posts[index].id;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.teal),
                              const SizedBox(width: 5),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            createdAt,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: [
                          _buildDetailChip(Icons.category, category),
                          _buildDetailChip(Icons.location_on, location),
                          _buildDetailChip(Icons.money, budget),
                          _buildDetailChip(Icons.calendar_today, deadline),
                          _buildDetailChip(Icons.info, status),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _navigateToChat(context, userEmail);
                            },
                            icon: const Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            label: const Text('Message'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deletePost(context, postId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.teal),
      label: Text(label),
      backgroundColor: Colors.blueGrey.shade50,
      labelStyle: const TextStyle(fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _navigateToChat(BuildContext context, String email) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatPage(email: email);
    }));
  }

  void _deletePost(BuildContext context, String postId) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(postId).delete();
      showMessage(context, message: 'Post deleted successfully');
    } catch (e) {
      showMessage(context, message: 'Failed to delete post');
    }
  }
}
