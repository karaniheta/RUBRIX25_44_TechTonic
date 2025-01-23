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
  
late Future<Map<String, dynamic>?> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle unauthenticated state
      return null;
    }

    try {
      // Check the 'Users' collection
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return {'role': 'User', ...userDoc.data()!};
      }

      // Check the 'FoodBank' collection
      final foodBankDoc = await FirebaseFirestore.instance
          .collection('FoodBanks')
          .doc(userId)
          .get();

      if (foodBankDoc.exists) {
        return {'role': 'FoodBank', ...foodBankDoc.data()!};
      }

      // If the user is not found in either collection
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }


  @override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: userData,
    builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          }

          final data = snapshot.data!;
          final role = data['role'];

          if (role == 'User') {
            return Uservolunteeringview();
          } else if (role == 'FoodBank') {
            return FoodBankVolunteeringView();
          } else {
            return const Center(child: Text('Unknown role'));
          }
        },
  );
}

}


