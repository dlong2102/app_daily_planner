class User {
  final String email;
  final String lastLogin;

  User({required this.email, required this.lastLogin});

  Map<String, dynamic> toJson() => {
        'email': email,
        'lastLogin': lastLogin,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        lastLogin: json['lastLogin'],
      );
}
