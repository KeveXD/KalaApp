class FelhasznaloModel {
  final String username;
  final String email;
  final String password;
  final String? profilePicture;
  final String role;
  final bool debt;

  FelhasznaloModel({
    required this.username,
    required this.email,
    required this.password,
    this.profilePicture,
    this.role = "user",
    this.debt = false,
  });

  /// **JSON-re alakítás**
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'role': role,
      'debt': debt,
    };
  }

  /// **JSON-ből objektummá alakítás**
  factory FelhasznaloModel.fromJson(Map<String, dynamic> json) {
    return FelhasznaloModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profilePicture: json['profilePicture'],
      role: json['role'] ?? 'user',
      debt: json['debt'] ?? false,
    );
  }

  /// **copyWith függvény, hogy könnyen frissíthessük az adatokat**
  FelhasznaloModel copyWith({
    String? username,
    String? email,
    String? password,
    String? profilePicture,
    String? role,
    bool? debt,
  }) {
    return FelhasznaloModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      debt: debt ?? this.debt,
    );
  }
}
