import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/buildTextField.dart';
import 'package:handi_net_app/components/home_page.dart';
import 'package:handi_net_app/components/login_page.dart';
import 'package:handi_net_app/components/showMessage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? userType;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController boiController = TextEditingController();

  Future<void> signUpUser() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showMessage(context, message: 'Please fill all required fields.');
        return;
      }

      if (userType == null) {
        showMessage(context, message: 'Please Choose Account Type!');
        return;
      }

      // Firebase Authentication
      final auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final userId = userCredential.user!.uid;

      // Firestore Data Storage
      final userData = {
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
        'userType': userType,
        'location': addressController.text.trim(),
      };

      if (userType == 'Craftsman') {
        userData['specialty'] = specialtyController.text.trim();
        userData['experience'] = experienceController.text.trim();
        userData['bio'] = boiController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userData);

      if (!mounted) return;
      showMessage(context, message: 'Sign-up successful!', color: Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            email: emailController.text,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(context, message: 'Error: ${e.message}', color: Colors.red);
    } catch (e) {
      showMessage(context, message: 'Unexpected error: $e', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [
      Buildtextfield(
        labelText: "Full Name",
        hintText: "Enter your full name",
        prefixIcon: Icons.person,
        controller: fullNameController,
      ),
      Buildtextfield(
        labelText: "Email",
        hintText: "Enter your email",
        prefixIcon: Icons.email,
        inputType: TextInputType.emailAddress,
        controller: emailController,
      ),
      Buildtextfield(
        labelText: "Mobile Phone",
        hintText: "Enter your mobile phone",
        prefixIcon: Icons.phone,
        inputType: TextInputType.phone,
        controller: mobileController,
      ),
      Buildtextfield(
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: Icons.lock,
        isPassword: true,
        controller: passwordController,
      ),
    ];

    if (userType == "Client") {
      fields.add(Buildtextfield(
        labelText: 'location',
        hintText: 'Enter your location',
        prefixIcon: Icons.location_on_rounded,
        controller: addressController,
      ));
    } else if (userType == "Craftsman") {
      fields.addAll([
        Buildtextfield(
          labelText: 'location',
          hintText: 'Enter your location',
          prefixIcon: Icons.location_on_rounded,
          controller: addressController,
        ),
        Buildtextfield(
          labelText: 'Specialty',
          hintText: 'Enter your specialty',
          prefixIcon: Icons.manage_accounts_rounded,
          controller: specialtyController,
        ),
        Buildtextfield(
          labelText: 'Experience',
          hintText: 'Enter years of experience',
          prefixIcon: Icons.numbers_rounded,
          inputType: TextInputType.number,
          controller: experienceController,
        ),
        Buildtextfield(
          labelText: 'bio',
          hintText: 'Summarize your bio',
          prefixIcon: Icons.info,
          inputType: TextInputType.text,
          controller: boiController,
        ),
      ]);
    }

    return Scaffold(
      backgroundColor: const Color(0xffF0F4F7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.teal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.teal,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    value: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: "Client",
                        child: Text(
                          "Client",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Craftsman",
                        child: Text(
                          "Craftsman",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                    hint: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: const Text(
                        "Choose Account Type",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.teal,
                    ),
                    iconSize: 25,
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
              ...fields,
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signUpUser,
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal,
                    elevation: 3,
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
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
