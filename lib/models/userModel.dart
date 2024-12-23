class UserModel {
  final String fullName;
  final String email;
  final String location;
  final String? mobile; // Mobile is nullable
  final String userType;
  final String?
      profilePicture; // Profile picture is nullable (if user doesn't provide one)

  UserModel({
    required this.fullName,
    required this.email,
    required this.location,
    required this.userType,
    this.mobile, // Mobile is nullable
    this.profilePicture, // Profile picture is nullable
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? 'Not Provided',
      email: map['email'] ?? 'Not Provided',
      location: map['location'] ?? 'Not Provided',
      mobile: map['mobile'],
      userType: map['userType'],
      profilePicture: map['profilePicture'],
    );
  }
}
