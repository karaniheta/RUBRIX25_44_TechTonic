import 'package:anvaya/bottom%20navbar/bnavbar.dart';
import 'package:anvaya/home%20page/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:super_icons/super_icons.dart';

// import 'package:anvaya/constants/app_theme.dart';
// import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/hume.dart';
import 'package:anvaya/signup_page/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  Future<void> signinwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Homepage after successful login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
            
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
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
                      Text(
                        'ANVAYA',
                        style: TextStyle(
                          fontFamily: 'interB',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF69adb2)),
                        ),
                      
                      const SizedBox(height: 60),
                      // Logo
                      SizedBox(
                        height: 200,
                        child: Image.asset('assets/applogo.png'),
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration( prefixIcon: Padding(padding: EdgeInsets.all(8.0),
                        child: Icon(SuperIcons.ii_mail),) ,      labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || !value.contains('@')
                            ? 'Enter a valid email'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(prefixIcon: Padding(padding: EdgeInsets.all(8.0),
                        child: Icon(SuperIcons.ii_lock_closed),) ,  labelText: 'Password'),
                        obscureText: true,
                        validator: (value) =>
                            value == null || value.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(
                            color: Color(0xFF1E88E5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Sign Up Button
                      ElevatedButton(
                        onPressed: signInWithEmailAndPassword,
                        child: const Text('Log In',
                        style: TextStyle(
                          color: Color(0xFFf1f5f5)
                        ),),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Color(0xFF69adb2))                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('OR'),
                      const SizedBox(height: 20),
                      // Social Login Options
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: signinwithGoogle,
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: Image.asset('assets/google icon.png'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}