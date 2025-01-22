import 'package:anvaya/chatbot%20page/chatbotpage.dart';
import 'package:anvaya/community/communitypage.dart';
import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/home%20page/home.dart';
import 'package:anvaya/profile/profile.dart';
import 'package:anvaya/volunteeringpage/volunteerpage.dart';
import 'package:flutter/material.dart';
import 'package:super_icons/super_icons.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _NavbarState();
}

class _NavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> pages = [Home(),Volunteerpage(), Chatbotpage(),Communitypage(), Profile()];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.secondaryColor,
          title: Text(
            'A  N  V  A  Y  A',
            style:
                TextStyle(fontFamily: 'interB', color: AppColors.primaryColor),
          )),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: Container(
        color: AppColors.secondaryColor,
        child: BottomNavigationBar(
          selectedFontSize: 12,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.mg_home_4_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.lc_heartHandshake),
              label: 'Volunteer',
            ),
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.bs_robot),
              label: 'Ai MealPrep',
            ),
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.cl_group_solid),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.bs_person_fill),
              label: 'Profile',
            ),
          ],
          selectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
                  AppColors.primaryColor,
          unselectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
                  Colors.grey,
          backgroundColor: AppColors.secondaryColor ?? Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          elevation: Theme.of(context).bottomNavigationBarTheme.elevation ?? 0,
        ),
      ),
    );
  }
}
