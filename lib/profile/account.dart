import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: AppColors.secondaryColor,
        // title: Text('Account Page'),
      ),
      body: Center(child: Text('Account Page')),
    );
  }
}