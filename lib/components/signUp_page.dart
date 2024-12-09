import 'package:flutter/material.dart';
import 'package:handi_net_app/components/buildTextField.dart';
import 'package:handi_net_app/components/home_page.dart';
import 'package:handi_net_app/components/login_page.dart';

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
        labelText: 'Address',
        hintText: 'Enter your address',
        prefixIcon: Icons.location_city_outlined,
        controller: addressController,
      ));
    }

    if (userType == "Craftsman") {
      fields.add(Buildtextfield(
        labelText: 'Specialty',
        hintText: 'Enter your specialty',
        prefixIcon: Icons.manage_accounts_rounded,
        controller: specialtyController,
      ));
      fields.add(Buildtextfield(
        labelText: 'Experience',
        hintText: 'Enter years of experience',
        prefixIcon: Icons.numbers_rounded,
        inputType: TextInputType.number,
        controller: experienceController,
      ));
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
                      style: BorderStyle.solid, color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
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
                                fontSize: 16.0, fontWeight: FontWeight.w800),
                          )),
                      DropdownMenuItem(
                          value: "Craftsman",
                          child: Text(
                            "Craftsman",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                    ],
                    hint: const Text(
                      "Choose Account Type",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.all(10),
                    iconEnabledColor: Colors.teal,
                    iconDisabledColor: Colors.grey,
                    style: const TextStyle(color: Colors.black),
                    isDense: true,
                  ),
                ),
              ),
              ...fields,
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ArtisanHomePage();
                    }));
                  },
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginPage();
                      }));
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
