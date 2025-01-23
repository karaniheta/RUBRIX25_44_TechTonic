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
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    // Fetch and sort data
    List<Map<String, dynamic>> leaderboard = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'user_name': data['user_name'] ?? 'Unknown',
        'points': data['points'] ?? 0,
      };
    }).toList();

    // Sort first by points (descending), then by name (alphabetical)
    leaderboard.sort((a, b) {
      int pointsComparison = b['points'].compareTo(a['points']); // Descending
      if (pointsComparison == 0) {
        return a['user_name'].compareTo(b['user_name']); // Alphabetical
      }
      return pointsComparison;
    });

    return leaderboard;
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
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'intersB',
              fontSize: 20,
            ),
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

              // Separate top 3 and others
              final topThree = leaderboard.take(3).toList();
              final others = leaderboard.skip(3).toList();

              return Expanded(
                child: Column(
                  children: [
                    // Podium layout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Second place
                        if (topThree.length > 1)
                          buildPodiumTile(
                            rank: 2,
                            user: topThree[1],
                            height: 140,
                            color: Colors.grey,
                          ),

                        // First place
                        if (topThree.isNotEmpty)
                          buildPodiumTile(
                            rank: 1,
                            user: topThree[0],
                            height: 180,
                            color: Colors.amber,
                          ),

                        // Third place
                        if (topThree.length > 2)
                          buildPodiumTile(
                            rank: 3,
                            user: topThree[2],
                            height: 120,
                            color: Colors.brown,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Rest of the leaderboard
                    Expanded(
                      child: ListView.builder(
                        itemCount: others.length,
                        itemBuilder: (context, index) {
                          final user = others[index];
                          String displayName = user['user_name'];
                          if (currentUser != null &&
                              user['user_name'] == currentUser.displayName) {
                            displayName = "You";
                          }
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              tileColor: AppColors.nonselected,
                              leading: CircleAvatar(
                                child: Text('${index + 4}'), // Rank
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.secondaryColor,
                              ),
                              title: Text(displayName),
                              trailing: Text(
                                '${user['points']} pts',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildPodiumTile({
    required int rank,
    required Map<String, dynamic> user,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          user['user_name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: height,
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Rank $rank',
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                '${user['points']} pts',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
