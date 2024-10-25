import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        _showSnackBar("Google sign-in was canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _navigateToHomeScreen(userCredential.user);
    } catch (error) {
      _showSnackBar("Sign-in error: $error");
    }
  }

  void _navigateToHomeScreen(User? user) {
    if (user != null) {
      _showSnackBar("Successfully signed in as ${user.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } else {
      _showSnackBar("Error: User is null.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      _navigateToHomeScreen(userCredential.user);
    } catch (error) {
      print("error : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          bool isSmallScreen = screenWidth < 600;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: isSmallScreen ? 300 : 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo yang responsif
                  Image.asset(
                    'assets/images/logo.png',
                    height: isSmallScreen ? 150 : 250,
                  ),
                  SizedBox(height: isSmallScreen ? 30 : 50),

                  // Login with Google Button
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Icon(Icons.account_circle),
                    label: Text("Login with Google"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 15 : 20,
                        horizontal: 50,
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),

                  // Anonymous Login Button
                  ElevatedButton.icon(
                    onPressed: _signInAnonymously,
                    icon: Icon(Icons.person_outline),
                    label: Text("Anonymous Login"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 15 : 20,
                        horizontal: 50,
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
