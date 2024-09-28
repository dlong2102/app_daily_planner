class AuthService {
  Future<bool> login(String email, String password) async {
    // TODO: Implement actual authentication logic here
    // For now, we'll just simulate a successful login
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return true;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
