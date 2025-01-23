// import 'package:flutter/material.dart';

// class Impact extends StatefulWidget {
//   const Impact({super.key});

//   @override
//   State<Impact> createState() => _ImpactState();
// }

// class _ImpactState extends State<Impact> {
//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text('Impact'),
//   //     ),
//   //     body: Center(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: const <Widget>[
//   //           Text(
//   //             'Your donations',
//   //           ),


//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   final double totalFoodRescued = 1200; // Example total rescued weight
//   final int totalDonations = 25; // Example number of donations

//   @override
//   Widget build(BuildContext context) {
//     double avgFoodPerDonation = totalFoodRescued / totalDonations;

//     return Scaffold(
//       appBar: AppBar(title: Text("Food Rescue Stats")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Total Food Rescued",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "${totalFoodRescued.toStringAsFixed(2)} kg",
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//             SizedBox(height: 16),
//             LinearProgressIndicator(
//               value: 0.75, // Example progress
//               backgroundColor: Colors.grey[300],
//               color: Colors.green,
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Donations Made",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "$totalDonations",
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Average Food Saved per Donation",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "${avgFoodPerDonation.toStringAsFixed(2)} kg",
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class FoodRescueStats extends StatefulWidget {
  @override
  _FoodRescueStatsState createState() => _FoodRescueStatsState();
}

class _FoodRescueStatsState extends State<FoodRescueStats> {
  // Mock data (replace with dynamic data in a real app)
  double totalFoodRescued = 1200; // Example total rescued weight
  int totalDonations = 25; // Example number of donations
  double goalWeight = 1600; // Example goal for food rescue (for progress calculation)

  @override
  Widget build(BuildContext context) {
    double avgFoodPerDonation = totalFoodRescued / totalDonations; // Calculate average food saved per donation
    double progress = totalFoodRescued / goalWeight; // Progress percentage

    return Scaffold(
      appBar: AppBar(title: Text("Food Rescue Stats")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation
            // SizedBox(
            //   height: 150,
            //   // child: Lottie.asset('assets/animations/food_rescue.json'),
            // ),
            SizedBox(height: 16),

            // Total Food Rescued with Circular Progress Indicator
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 3.0,
              percent: progress.clamp(0.0, 1.0), // Clamp progress between 0 and 1
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${totalFoodRescued.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ).animate().fadeIn().scale(duration: Duration(seconds: 1)),
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
            Text(
              "Donations Made",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "$totalDonations",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ).animate().fadeIn(duration: Duration(seconds: 1)),
            SizedBox(height: 16),

            // Average Food Saved per Donation
            Text(
              "Average Food Saved per Donation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              avgFoodPerDonation.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ).animate().fadeIn().scale(duration: Duration(seconds: 1)),
            SizedBox(height: 24),

            // Update Button (Example to Demonstrate State Update)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Mock update: Increment rescued food and donations
                  totalFoodRescued += 100;
                  totalDonations += 5;
                });
              },
              child: Text("Update Stats"),
            ),
          ],
        ),
      ),
    );
  }
}
