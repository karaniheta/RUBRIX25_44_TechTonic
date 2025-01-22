import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/home%20page/home.dart';
import 'package:anvaya/profile/profile.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:super_icons/super_icons.dart';


class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});


  @override
  State<BottomNavbar> createState() => _NavbarState();
}


class _NavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;


  final List<Widget> pages = [
    Home(),
    Profile()
  ];


  final List<Widget> appBarTitles = [
    Column(
      children: <Widget>[
        Text('Good Morning,'),
        Text('Rishi Mehta'),
      ],
    ),
  
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    // void handleThemeChange(bool isDarkMode) {
    //   Provider.of<ThemeNotifier>(context, listen: false)
    //       .toggleTheme(isDarkMode);
    // }


    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Row(
         
          children: [
            Container(
              height: 40,
              child: Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.titletext,
                )
              ),
              SizedBox(width: 20,)
         
            // Text(appBarTitles[_selectedIndex],
           ,
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.selectedtile,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.selectedtile,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      // drawer: Drawerclass(
      //   // onThemeChange: handleThemeChange,
      // ),
      bottomNavigationBar: BottomNavigationBar(   
        selectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(SuperIcons.mg_home_4_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(SuperIcons.bs_person_fill),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(SuperIcons.cl_briefcase_line),
          //   label: 'Portfolio',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(SuperIcons.cl_piggy_bank_line),
          //   label: 'MF',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(SuperIcons.bs_grid_3x3_gap_fill),
          //   label: 'Menu',
          // ),
        ],
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
                AppColors.selectedtile,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
                Colors.grey,
        backgroundColor: AppColors.navbarcolorbg,
        elevation: Theme.of(context).bottomNavigationBarTheme.elevation ?? 0,
      ),
    );
  }
}
