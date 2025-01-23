import 'package:anvaya/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy('points', descending: true) // Sort by points (highest first)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'user_name': data['user_name'] ?? 'Unknown',
        'points': data['points'] ?? 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'L E A D E R B O A R D',
            style:
                TextStyle(color: AppColors.primaryColor, fontFamily: 'intersB'),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchLeaderboardData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final leaderboard = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final user = leaderboard[index];
                    String displayName = user['user_name'];
                    if (currentUser!=null && user['user_name'] == currentUser.displayName) {
                      displayName = "You";
                    }
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: ListTile(
                        tileColor: AppColors.nonselected,
                        leading: CircleAvatar(
                          child: Text('${index + 1}'), // Rank
                          backgroundColor: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey
                                  : index == 2
                                      ? Colors.brown
                                      : AppColors.primaryColor,
                          foregroundColor: AppColors.secondaryColor,
                        ),
                        title: Text(displayName),
                        trailing: Text(
                          '${user['points']} pts',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
