import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account',
        style: TextStyle(
          fontFamily: 'interB',
          color: AppColors.titletext
        ),),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
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
            return _buildUserView(data);
          } else if (role == 'FoodBank') {
            return _buildFoodBankView(data);
          } else {
            return const Center(child: Text('Unknown role'));
          }
        },
      ),
    );
  }

  Widget _buildUserView(Map<String, dynamic> data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('User Name: ${data['user_name']}', style: _textStyle()),
          Text('Email: ${data['user_emailId']}', style: _textStyle()),
          Text('Account: User', style: _textStyle()),
        ],
      ),
    );
  }

  Widget _buildFoodBankView(Map<String, dynamic> data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Food Bank Name: ${data['foodbank_name']}', style: _textStyle()),
          Text('Contact: ${data['foodbank_phoneNumber']}', style: _textStyle()),
          Text('Address: ${data['foodbank_address']}', style: _textStyle()),
          Text('Role: Food Bank', style: _textStyle()),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor,
    );
  }
}
