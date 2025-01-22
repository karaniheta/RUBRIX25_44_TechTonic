import 'package:anvaya/login/login_page.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void tologin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                
                image: DecorationImage(
                  image: AssetImage('assets/prof.png'), 
                  ),
              ),
            ),
            TextButton(
              onPressed: tologin, 
              child: Text('Logout'))
          ],
        ),
      ),
    )
    ;
  }
}