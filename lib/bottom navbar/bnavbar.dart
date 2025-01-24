import 'package:anvaya/Guidelines/guidelinespage.dart';
import 'package:anvaya/chatbot%20page/chatbotpage.dart';
import 'package:anvaya/community/leader_page.dart';
import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/home%20page/home.dart';
import 'package:anvaya/profile/profile.dart';
import 'package:anvaya/volunteeringpage/volunteerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:super_icons/super_icons.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _NavbarState();
}

class _NavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;

  final List<Widget> pages = [
    Home(),
    Volunteerpage(),
    Chatbotpage(),
    LeaderboardPage(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserData();
    });
  }

  /// Fetches user data from Firestore.
  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      setState(() {
        userData = null;
      });
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = {'role': 'User', ...userDoc.data()!};
        });
        return;
      }

      final foodBankDoc = await FirebaseFirestore.instance
          .collection('FoodBanks')
          .doc(userId)
          .get();

      if (foodBankDoc.exists) {
        setState(() {
          userData = {'role': 'FoodBank', ...foodBankDoc.data()!};
        });
        return;
      }

      setState(() {
        userData = null;
      });

      getLocation();
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userData = null;
      });
    }
  }

  /// Gets the user's current location.
/// Gets the user's current location and updates it in Firestore.
Future<void> getLocation() async {
  try {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled");
      return;
    }

    // Request location permission if not granted
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("Location permissions are denied");
        return;
      }
    }

    // Get the user's current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("Current Position: ${position.latitude}, ${position.longitude}");

    // Store the user's location in Firestore
    await storeLocation(position);

    // Show success feedback to the user via a SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location updated successfully!'))
      );
    }

  } catch (e) {
    print("Error getting location: $e");
    // Optionally, show an error message to the user if needed
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update location. Please try again.'))
      );
    }
  }
}

/// Stores the user's location in Firestore.
Future<void> storeLocation(Position position) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userLocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Check user role and update location in the respective collection
    if (userData?['role'] == 'User') {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'location': userLocation});
      print("User location stored successfully");
    } else if (userData?['role'] == 'FoodBank') {
      await FirebaseFirestore.instance
          .collection('FoodBanks')
          .doc(userId)
          .update({'location': userLocation});
      print("FoodBank location stored successfully");
    }
  } catch (e) {
    print("Error storing location: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error storing location. Please try again.'))
      );
    }
  }
}



  /// Handles navigation tab changes.
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Guidelinespage()),
            );
          },
          icon: Icon(Icons.info_outline, color: AppColors.titletext),
        ),
        title: Text(
          'A  N  V  A  Y  A',
          style: TextStyle(
            fontFamily: 'interB',
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed:(){ getLocation();
           },
            icon: Icon(SuperIcons.ii_location),
          ),
        ],
      ),
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
              icon: Icon(SuperIcons.is_ranking_1_bold),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(SuperIcons.bs_person_fill),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
              AppColors.primaryColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
              Colors.grey,
          backgroundColor: AppColors.secondaryColor ??
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          elevation: Theme.of(context).bottomNavigationBarTheme.elevation ?? 0,
        ),
      ),
    );
  }
}