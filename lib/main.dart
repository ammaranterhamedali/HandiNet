import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/home_page.dart';
import 'package:handi_net_app/components/startPage.dart';
import 'package:handi_net_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const HandiNet());
}

class HandiNet extends StatefulWidget {
  const HandiNet({super.key});

  @override
  State<HandiNet> createState() => _HandiNetState();
}

class _HandiNetState extends State<HandiNet> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _currentUser == null
          ? const StartPage()
          : HomePage(email: _currentUser!.email ?? 'No email'),
    );
  }
}
