import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Uservolunteeringview extends StatefulWidget {
  const Uservolunteeringview({super.key});

  @override
  State<Uservolunteeringview> createState() => _UservolunteeringviewState();
}

class _UservolunteeringviewState extends State<Uservolunteeringview> {
   @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collectionGroup('volunteeringOpportunities').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Errors: ${snapshot.error}'));
        }

        final opportunities = snapshot.data!.docs;

        return ListView.builder(
          itemCount: opportunities.length,
          itemBuilder: (context, index) {
            final opportunity = opportunities[index].data() as Map<String, dynamic>;
            final foodBankId = opportunities[index].reference.parent.parent!.id;

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(opportunity['title']),
                subtitle: Text(opportunity['description']),
                trailing: ElevatedButton(
                  onPressed: () {
                    optInToOpportunity(
                      foodBankId,
                      opportunities[index].id,
                      opportunity['title'],
                      opportunity['description'],
                    );
                  },
                  child: Text('Opt In'),
                ),
              ),
            );
          },
        );
      },
    );
}

  void optInToOpportunity(String foodBankId, String opportunityId, String title, String description) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('volunteeringOpportunities')
        .doc(opportunityId)
        .set({
          'foodBankId': foodBankId,
          'title': title,
          'description': description,
          'status': 'pending',
        });

    FirebaseFirestore.instance
        .collection('FoodBanks')
        .doc(foodBankId)
        .collection('volunteeringOpportunities')
        .doc(opportunityId)
        .update({
          'applicants': FieldValue.arrayUnion([{'userId': userId}]),
        });
  }
}