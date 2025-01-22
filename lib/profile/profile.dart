import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            
            image: DecorationImage(
              image: AssetImage('assets/prof.png'), 
              ),
          ),
        ),
      ],
    )
    ;
  }
}