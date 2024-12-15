class Artisan {
  final String email;
  final String fullName;
  final String bio;
  final String location;
  final String mobile;
  final String specialty;
  final String experience;
  Artisan({
    required this.email,
    required this.fullName,
    required this.bio,
    required this.location,
    required this.mobile,
    required this.specialty,
    required this.experience,
  });

  factory Artisan.fromMap(Map<String, dynamic> map) {
    return Artisan(
      email: map['email'],
      fullName: map['fullName'],
      bio: map['bio'],
      location: map['location'],
      mobile: map['mobile'],
      specialty: map['specialty'],
      experience: map['experience'],
    );
  }
}
