import 'package:anvaya/volunteeringpage/foodbankvolunteeringview.dart';
import 'package:anvaya/volunteeringpage/uservolunteeringview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Volunteerpage extends StatefulWidget {
  const Volunteerpage({super.key});

  @override
  State<Volunteerpage> createState() => _VolunteerpageState();
}

class _VolunteerpageState extends State<Volunteerpage> {


  @override
Widget build(BuildContext context) {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('FoodBanks').doc(userId).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return Text('$userId   Error: ${snapshot.error}');
      }

      final userData = snapshot.data!.data() as Map<String, dynamic>;
      final role = userData['role'];

      return  role == 'User'
            ? Uservolunteeringview()
            : FoodBankVolunteeringView();
    }
      );
    }
}


