import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addDummyUsers() async {
  List<Map<String, dynamic>> dummyUsers = [
    {
      'fullName': 'Alice Johnson',
      'email': 'alice@example.com',
      'mobile': '1234567890',
      'userType': 'Client',
      'location': '123 Elm Street, Springfield',
      'password': '123123',
    },
    {
      'fullName': 'Bob Smith',
      'email': 'bob@example.com',
      'mobile': '9876543210',
      'userType': 'Craftsman',
      'location': '456 Oak Avenue, Springfield',
      'specialty': 'Carpentry',
      'experience': '5',
      'bio': 'Expert in woodwork and furniture making.',
      'password': '123123',
    },
    {
      'fullName': 'Charlie Brown',
      'email': 'charlie@example.com',
      'mobile': '2345678901',
      'userType': 'Client',
      'location': '789 Pine Road, Springfield',
      'password': '123123',
    },
    {
      'fullName': 'Diana Prince',
      'email': 'diana@example.com',
      'mobile': '3456789012',
      'userType': 'Craftsman',
      'location': '101 Maple Lane, Springfield',
      'specialty': 'Plumbing',
      'experience': '8',
      'bio': 'Specialist in household plumbing and repairs.',
      'password': '123123',
    },
    {
      'fullName': 'Ethan Hunt',
      'email': 'ethan@example.com',
      'mobile': '4567890123',
      'userType': 'Client',
      'location': '202 Birch Street, Springfield',
      'password': '123123',
    },
    {
      'fullName': 'Fiona Gallagher',
      'email': 'fiona@example.com',
      'mobile': '5678901234',
      'userType': 'Craftsman',
      'location': '303 Willow Avenue, Springfield',
      'specialty': 'Electrical',
      'experience': '10',
      'bio': 'Experienced in electrical installations and repairs.',
      'password': '123123',
    },
    {
      'fullName': 'George Orwell',
      'email': 'george@example.com',
      'mobile': '6789012345',
      'userType': 'Client',
      'location': '404 Oak Boulevard, Springfield',
      'password': '123123',
    },
    {
      'fullName': 'Hannah Montana',
      'email': 'hannah@example.com',
      'mobile': '7890123456',
      'userType': 'Craftsman',
      'location': '505 Cedar Drive, Springfield',
      'specialty': 'Painting',
      'experience': '7',
      'bio': 'Professional in house painting and decor.',
      'password': '123123',
    },
    {
      "fullName": "John Doe",
      "email": "john@example.com",
      "mobile": "7890123456",
      "userType": "Craftsman",
      "location": "123 Oak Street, Springfield",
      "specialty": "Cleaning",
      "experience": "5",
      "bio": "Expert in residential and office cleaning.",
      "password": "123123"
    },
    {
      "fullName": "Jane Smith",
      "email": "jane@example.com",
      "mobile": "7890987654",
      "userType": "Craftsman",
      "location": "456 Maple Avenue, Springfield",
      "specialty": "Air Conditioning",
      "experience": "8",
      "bio":
          "Certified HVAC technician specializing in air conditioning systems.",
      "password": "123123"
    },
    {
      'fullName': 'Ian McKellen',
      'email': 'ian@example.com',
      'mobile': '8901234567',
      'userType': 'Client',
      'location': '606 Pinecrest Way, Springfield',
      'password': '123123',
    },
    {
      'fullName': 'Jessica Alba',
      'email': 'jessica@example.com',
      'mobile': '9012345678',
      'userType': 'Craftsman',
      'location': '707 Elm Circle, Springfield',
      'specialty': 'Carpentry',
      'experience': '4',
      'bio': 'Skilled in woodwork and custom furniture.',
      'password': '123123',
    },
    {
      'fullName': 'Tom Hanks',
      'email': 'tom@example.com',
      'mobile': '0123456789',
      'userType': 'Craftsman',
      'location': '808 Birch Avenue, Springfield',
      'specialty': 'Plumbing',
      'experience': '12',
      'bio': 'Expert plumber with over 12 years of experience.',
      'password': '123123',
    },
    {
      'fullName': 'Emma Stone',
      'email': 'emma@example.com',
      'mobile': '1230984567',
      'userType': 'Craftsman',
      'location': '909 Oak Avenue, Springfield',
      'specialty': 'Electrical',
      'experience': '6',
      'bio': 'Specialized in home electrical systems and repairs.',
      'password': '123123',
    },
    {
      'fullName': 'Will Smith',
      'email': 'will@example.com',
      'mobile': '2345678900',
      'userType': 'Craftsman',
      'location': '1010 Pine Road, Springfield',
      'specialty': 'Carpentry',
      'experience': '9',
      'bio': 'Woodworking professional skilled in custom carpentry.',
      'password': '123123',
    },
    {
      'fullName': 'Miley Cyrus',
      'email': 'miley@example.com',
      'mobile': '3456789011',
      'userType': 'Craftsman',
      'location': '1111 Cedar Street, Springfield',
      'specialty': 'Painting',
      'experience': '4',
      'bio': 'Professional house painter with attention to detail.',
      'password': '123123',
    },
  ];

  for (var user in dummyUsers) {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user['email'],
        password: user['password'],
      );

      final userId = userCredential.user!.uid;
      user.remove('password');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user);

      print("User ${user['fullName']} added successfully!");
    } catch (e) {
      print("Failed to add user ${user['fullName']}: $e");
    }
  }
}
