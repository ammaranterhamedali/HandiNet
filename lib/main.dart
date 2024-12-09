import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handi_net_app/components/startPage.dart';
import 'package:handi_net_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HandiNet());
}

class HandiNet extends StatefulWidget {
  const HandiNet({super.key});

  @override
  State<HandiNet> createState() => _HandiNetState();
}

class _HandiNetState extends State<HandiNet> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}
