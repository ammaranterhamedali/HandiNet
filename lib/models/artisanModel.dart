class Artisan {
  final String email;
  final String fullName;
  final String bio;
  final String location;
  final String mobile;
  final String specialty;
  final String experience;
  final String profilePictureUrl;


  Artisan({
    required this.email,
    required this.fullName,
    required this.bio,
    required this.location,
    required this.mobile,
    required this.specialty,
    required this.experience,
    required this.profilePictureUrl,
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
      profilePictureUrl: map['profilePictureUrl'] ??
          'https://i.etsystatic.com/16458179/r/il/2c997b/4719121103/il_570xN.4719121103_bp57.jpg',
    );
  }
}
