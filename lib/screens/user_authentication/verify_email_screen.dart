import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Your Email")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isEmailVerified
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(height: 20),
                    Text(
                      "Email verified successfully!",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.teal, // Text color
                      ),
                      child: Text("Continue to Login"),
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.email, size: 100, color: Colors.teal),
                    SizedBox(height: 20),
                    Text(
                      "A verification link has been sent to your email.\nPlease check your inbox and verify.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await checkEmailVerified();
                        setState(() => isLoading = false);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.teal, // Text color
                      ),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text("I've Verified My Email"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
