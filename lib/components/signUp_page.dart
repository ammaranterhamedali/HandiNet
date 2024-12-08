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
  String? userType = "Client"; 
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container( 
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(
                    style: BorderStyle.solid, color: Colors.green, width: 2),
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
                  iconEnabledColor: Colors.green,
                  iconDisabledColor: Colors.grey,
                  style: const TextStyle(color: Colors.black),
                  isDense: true,
                  focusColor: const Color.fromARGB(255, 253, 255, 253),
                ),
              ),
            ),
            ...fields,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 18,
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
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
