import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_icons/super_icons.dart';

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
        title: Text(
          'Your Account',
          style: TextStyle(fontFamily: 'interB', color: AppColors.titletext),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryColor,
          child: Icon(
            SuperIcons.is_profile_2user_bold,
            color: AppColors.secondaryColor,
            size: 50,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(16),
            width: 400,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(
                  color: AppColors.titletext,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '                User Details',
                  style: TextStyle(
                      fontFamily: 'intersB',
                      fontSize: 23,
                      color: AppColors.secondaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'User Name\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['user_name']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Email\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['user_emailId']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Date_of_Birth\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['dob']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Account\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: 'User', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Phone\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['user_phoneNumber']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Points\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['points']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFoodBankView(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryColor,
          child: Icon(
            SuperIcons.is_bank_outline,
            color: AppColors.secondaryColor,
            size: 50,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(16),
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.titletext,
              width: 2),
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '                FoodBank Details',
                  style: TextStyle(
                      fontFamily: 'intersB',
                      fontSize: 23,
                      color: AppColors.secondaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'FoodBank Name\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['foodbank_name']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Email\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['foodbank_mail']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Phone\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['foodbank_phoneNumber']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Account\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: 'FoodBank', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Address\n', // Label
                        style: TextStyle(
                          color: AppColors.secondaryColor, // Label color
                          fontSize: 18,
                          fontFamily: 'intersB',
                        ),
                      ),
                      TextSpan(
                        text: '${data['foodbank_address']}', // User Name
                        style: TextStyle(
                          color: AppColors.secondaryColor, // User name color
                          fontSize: 16,
                          fontFamily: 'interR',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
