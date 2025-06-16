

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String phoneNumber;
  final String district;
  final String roleName;
  final String? profileImageUrl;
  final String? profileCoverUrl;
  final num? totalBalance;
  final bool isVerified;


  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.phoneNumber,
    required this.district,
    required this.roleName,
    required this.id,
    this.profileImageUrl,
    this.profileCoverUrl,
    this.totalBalance,
    required this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      email: json['Email'] ?? '',
      city: json['City'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      district: json['District'] ?? '',
      roleName: json['RoleName'] ?? '',
      profileImageUrl: json['ProfileImageUrl']??"",
      id: json['Id'] ?? '',
      profileCoverUrl: json['ProfileCoverUrl'] ?? '',
      totalBalance: json['TotalBalance'],
      isVerified: json['IsVerified'] ?? false,
    );
  }
  @override
  String toString() {
  return "firstName: $firstName, lastName: $lastName, email: $email, city: $city, phoneNumber: $phoneNumber, district: $district, roleName: $roleName, profileImageUrl: $profileImageUrl, id: $id, profileCoverUrl: $profileCoverUrl, totalBalance: $totalBalance,isVerified: $isVerified";
  }
}
