class UserResponse {
  final int id;
  final String name;
  final String email;
  final String provider;
  final List<String> roles;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    required this.roles,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      provider: json['provider'] ?? 'local',
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : [],
    );
  }
}
