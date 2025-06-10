class UserModel {
  final String uid;
  final String name;
  final String role;
  final String gender;
  final String profilePicture;

  UserModel({
    required this.uid,
    required this.name,
    required this.role,
    required this.gender,
    required this.profilePicture,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['Name'] ?? '',
      role: data['Role'] ?? '',
      gender: data['gender'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Role': role,
      'gender': gender,
      'ProfilePicture': profilePicture,
    };
  }
}
