
import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FoodRescueStats extends StatefulWidget {
  @override
  _FoodRescueStatsState createState() => _FoodRescueStatsState();
}

class _FoodRescueStatsState extends State<FoodRescueStats>
    with SingleTickerProviderStateMixin {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  double goalWeight = 100;
  late AnimationController _controller =AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for explicit animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _controller,
          child: Text(
            "Food Rescue Stats",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .where('donorId', isEqualTo: userid)
            .where('iscomplete', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: FadeTransition(
                opacity: _controller,
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _controller,
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Transactions Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          // Calculate stats
          final transactions = snapshot.data!.docs;
          int totalDonations = transactions.length;
          double totalFoodRescued = totalDonations * 2;
          double avgFoodPerDonation = totalDonations > 0
              ? totalFoodRescued / totalDonations
              : 0.0;
          double progress = (totalFoodRescued / goalWeight).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Header
                ScaleTransition(
                  scale: _controller,
                  child: Icon(
                    Icons.fastfood_rounded,
                    size: 100,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16),

                // Total Food Rescued with Circular Progress Indicator
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 8.0,
                  percent: progress,
                  animation: true,
                  animationDuration: 1500,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Text(
                            "${totalFoodRescued.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          );
                        },
                      ),
                      Text(
                        "kg Rescued",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  progressColor: AppColors.primaryColor,
                  backgroundColor: Colors.grey[300] ?? Colors.grey,
                ),
                SizedBox(height: 16),

                // Donations Made
                FadeTransition(
                  opacity: _controller,
                  child: Column(
                    children: [
                      Text(
                        "Donations Made",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          "$totalDonations",
                          key: ValueKey(totalDonations),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Average Food Saved per Donation
                Column(
                  children: [
                    FadeTransition(
                      opacity: _controller,
                      child: Text(
                        "Average Food Saved per Donation",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                          begin: 0.0, end: avgFoodPerDonation), // Smooth update
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Animated Button
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       // Increment mock data for demonstration
                //       goalWeight += 20;
                //     });
                //   },
                //   child: AnimatedContainer(
                //     duration: const Duration(milliseconds: 500),
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                //     decoration: BoxDecoration(
                //       color: AppColors.primaryColor,
                //       borderRadius: BorderRadius.circular(10),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.2),
                //           blurRadius: 8,
                //           spreadRadius: 2,
                //         )
                //       ],
                //     ),
                //     child: Text(
                //       "Update Goal",
                //       style: TextStyle(color: Colors.white, fontSize: 18),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
