import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/showMessage.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  String _selectedCategory = 'Plumbing';
  DateTime? _selectedDeadline;
  final List<String> _categories = [
    'Plumbing',
    'Carpentry',
    'Electrical',
    'Painting'
  ];
  bool _isPosting = false;

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      if (_selectedDeadline == null) {
        showMessage(context, message: 'Please select a deadline');
        return;
      }

      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String userName = userDoc.data()?['fullName'] ?? 'Unknown User';
        String userEmail = userDoc.data()?['email'] ?? 'Unknown email';

        await FirebaseFirestore.instance.collection('jobs').add({
          'title': _jobTitleController.text,
          'description': _jobDescriptionController.text,
          'category': _selectedCategory,
          'location': _locationController.text,
          'budget': _budgetController.text,
          'deadline': _selectedDeadline != null
              ? Timestamp.fromDate(_selectedDeadline!)
              : null,
          'status': 'Open',
          'createdAt': Timestamp.now(),
          'userName': userName,
          'email': userEmail,
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your job has been posted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showMessage(context, message: 'User not logged in.');
      }
    } catch (e) {
      showMessage(context,
          message: 'Failed to post the job. Please try again later.');
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post a Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _jobTitleController,
                label: 'Job Title',
                hint: 'Enter a short job title (e.g., Fix a leaking tap)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _jobDescriptionController,
                label: 'Job Description',
                hint: 'Provide a detailed description of the job...',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job description cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Enter the job location (e.g., City, Street Address)',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _budgetController,
                label: 'Budget',
                hint: 'Enter your estimated budget (e.g., \$100 - \$200)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        onChanged: (String? newCategory) {
                          setState(() {
                            _selectedCategory = newCategory!;
                          });
                        },
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.teal),
                  title: Text(
                    _selectedDeadline == null
                        ? 'Select Deadline'
                        : 'Deadline: ${_selectedDeadline!.toLocal()}'
                            .split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDeadline = selectedDate;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _isPosting ? null : _postJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Post Job',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }
}
