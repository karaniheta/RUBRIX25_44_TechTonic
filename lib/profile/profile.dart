import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/login/login_page.dart';
import 'package:anvaya/profile/about.dart';
import 'package:anvaya/profile/account.dart';
import 'package:anvaya/profile/transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:super_icons/super_icons.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/prof.png'),
                ),
              ),
            ),
            // Text()
            SizedBox(
              height: 40,
            ),
            Profilebuttons(
                text: 'Your Account',
                icon: SuperIcons.bs_person,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Account()),
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Profilebuttons(
                text: 'Your Transactions',
                icon: SuperIcons.is_transaction_minus_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Transactions()),
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Profilebuttons(
                text: 'Your Impact', icon: SuperIcons.bs_star, onTap: () {}),
            SizedBox(
              height: 10,
            ),
            Profilebuttons(
                text: 'Your Rewards', icon: SuperIcons.bx_gift, onTap: () {}),
            SizedBox(
              height: 10,
            ),
            Profilebuttons(
                text: 'About', icon: SuperIcons.bs_info_circle, onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>AboutPage()))),

            SizedBox(
              height: 10,
            ),

            Profilebuttons(
                text: 'Log out',
                icon: SuperIcons.bx_power_off,
                onTap: () => _showLogoutConfirmationDialog(context)),
          ],
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  Future<void> logout() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseAuth.instance.signOut();
        print('$user logged off');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error logging out : $e');
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentTextStyle: TextStyle(
          color: AppColors.text,
          fontFamily: 'interR',
        ),
        backgroundColor: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // contentPadding: EdgeInsets.only(left: 20,right: 20),
        title: Center(
            child: Text(
          'Confirm Logout',
          style: TextStyle(fontFamily: 'interB'),
        )),
        content: Text(
          'Are you sure you want to log out?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: const Color.fromARGB(255, 142, 142, 142)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

Widget Profilebuttons(
    {required String text, required IconData icon, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(157, 235, 235, 235),
                    shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 130, 130, 130),
                ),
              ),
              TextButton(
                  onPressed: onTap,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'interR',
                        // fontWeight: FontWeight.w500,
                        color: AppColors.text),
                  )),
            ],
          ),
          Icon(
            SuperIcons.ev_arrow_ios_forward,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ],
      ),
    ),
  );
}
