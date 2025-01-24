import 'package:anvaya/auth.dart';
import 'package:anvaya/bottom%20navbar/bnavbar.dart';

import 'package:anvaya/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_icons/super_icons.dart';

class SignorgPage extends StatefulWidget {
  const SignorgPage({super.key});

  @override
  State<SignorgPage> createState() => _SignorgPageState();
}

class _SignorgPageState extends State<SignorgPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;
  Future<void> signinwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Homepage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    }
  }

void _signUp() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => isLoading = true);

  try {
    // Attempt to create a new user
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Get user UID
    String uid = userCredential.user!.uid;

    // Save user data in Firestore
    await FirebaseFirestore.instance.collection('FoodBanks').doc(uid).set({
      'foodbank_name': _nameController.text.trim(),
      'foodbank_emailId': _emailController.text.trim(),
      'foodbank_phoneNumber': _phoneController.text.trim(),
      'uid': uid,
      'role': 'FoodBank',
      'foodbank_address':_addressController.text.trim(),
      'points': 0,
    });

    // Navigate to homepage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavbar()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful'),
        backgroundColor: Color(0xFF1E88E5),
      ),
    );
  } on FirebaseAuthException catch (e) {
    // Handle specific FirebaseAuth errors
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already in use. Please log in.'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: ${e.message}'),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
    }
  } catch (e) {
    // Handle other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An unexpected error occurred: $e'),
        backgroundColor: const Color(0xFFE53935),
      ),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Text('ANVAYA',
                          style: TextStyle(
                              fontFamily: 'interB',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF69adb2))),
                      const SizedBox(height: 60),
                      SizedBox(
                          height: 200,
                          child: Image.asset('assets/applogo.png')),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(SuperIcons.ii_man),
                            labelText: 'Name'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your name'
                            : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(SuperIcons.ii_mail),
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || !value.contains('@')
                                ? 'Enter a valid email'
                                : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(SuperIcons.ii_lock_closed),
                            labelText: 'Password'),
                        obscureText: true,
                        validator: (value) => value == null || value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                     
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(SuperIcons.ii_call),
                            labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          final phoneRegExp =
                              RegExp(r'^\+?[1-9]\d{1,14}$'); // E.164 format
                          if (value == null || value.isEmpty) {
                            return 'Enter a valid phone number';
                          } else if (!phoneRegExp.hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(SuperIcons.ii_map),
                            labelText: 'Address'),
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                    return 'Please enter your address.';
                  }
                  if (value.length < 10) {
                    return 'Address should be at least 10 characters long.';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9\s,.-]+$').hasMatch(value)) {
                    return 'Address contains invalid characters.';
                  }
                  return null;
                },
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(
                          'Already have an account? Login',
                          style:
                              TextStyle(color: Color(0xFF1E88E5), fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xFFf1f5f5)),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Color(0xFF69adb2))),
                      ),
                      const SizedBox(height: 10),
                      Text('OR'),
                      const SizedBox(height: 20),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                final auth =
                                    Provider.of<Auth>(context, listen: false);
                                try {
                                  await auth.signinwithGoogle();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Google sign-in failed: $e')),
                                  );
                                }
                              },
                              child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset('assets/google icon.png')),
                            ),
                            SizedBox(width: 20),
                          ])
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
