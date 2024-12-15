class UserModel {
  final String fullName;
  final String email;
  final String location;
  final String mobile;
  final String userType;
  UserModel({
    required this.fullName,
    required this.email,
    required this.location,
    required this.mobile,
    required this.userType,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? 'Not Provided',
      email: map['email'] ?? 'Not Provided',
      location: map['location'] ?? 'Not Provided',
      mobile: map['mobile'] ?? 'Not Provided',
      userType: map['userType'],
    );
  }
}
