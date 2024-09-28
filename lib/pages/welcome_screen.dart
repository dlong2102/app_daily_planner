import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/logo.png')),
            SizedBox(height: 50),
            Text('Welcome to Daily Planner',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Login',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
