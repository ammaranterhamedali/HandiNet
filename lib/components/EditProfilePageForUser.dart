import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handi_net_app/components/showMessage.dart';
import 'package:handi_net_app/models/userModel.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;
  late final TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _locationController = TextEditingController(text: widget.user.location);
    _mobileController = TextEditingController(text: widget.user.mobile);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        showMessage(context, message: "User not logged in", color: Colors.red);
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'location': _locationController.text.trim(),
        'mobile': _mobileController.text.trim(),
      });

      if (mounted) {
        showMessage(context,
            message: "Profile updated successfully", color: Colors.teal);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showMessage(context,
            message: "Error updating profile: $e", color: Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Edit your details below:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  validatorMessage: 'Please enter your full name',
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  validatorMessage: 'Please enter your email',
                ),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  validatorMessage: 'Please enter your location',
                ),
                _buildTextField(
                  controller: _mobileController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validatorMessage: 'Please enter your phone number',
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.teal[700],
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
