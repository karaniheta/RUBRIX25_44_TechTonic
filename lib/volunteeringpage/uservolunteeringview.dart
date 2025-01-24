import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Uservolunteeringview extends StatefulWidget {
  const Uservolunteeringview({super.key});

  @override
  State<Uservolunteeringview> createState() => _UservolunteeringviewState();
}

class _UservolunteeringviewState extends State<Uservolunteeringview> {
  Future<List<Map<String, dynamic>>> fetchVolunteeringOpportunities() async {
    List<Map<String, dynamic>> opportunities = [];

    // Get all documents in the FoodBanks collection
    QuerySnapshot foodBanksSnapshot =
        await FirebaseFirestore.instance.collection('FoodBanks').get();

    for (var foodBankDoc in foodBanksSnapshot.docs) {
      // Access the subcollection for each FoodBank document
      QuerySnapshot subcollectionSnapshot = await foodBankDoc.reference
          .collection('volunteeringOpportunities')
          .get();

      for (var subDoc in subcollectionSnapshot.docs) {
        // Add subcollection data and include the document ID
        Map<String, dynamic> data = subDoc.data() as Map<String, dynamic>;
        data['id'] = subDoc.id; // Add the document ID to the map
        opportunities.add(data);
      }
    }

    return opportunities;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Open Volunteering oppurtunites',
        style: TextStyle(
          color: AppColors.titletext,
          fontSize: 20,
          fontFamily: 'interB'
        ),),
        SizedBox(height: 20,),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchVolunteeringOpportunities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
          
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
          
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No volunteering opportunities found.'));
                }
                final opportunities = snapshot.data!;
          
                return ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity = opportunities[index];
                    final opportunityId = opportunity['vid']; // Document ID
                    final foodBankId = opportunity['foodbank_uid']; // FoodBank ID
          
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      opportunity['foodbank_name'],
                                      style: TextStyle(
                                        fontFamily: 'intersB',
                                        color: AppColors.titletext,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Spacer(),
                                    FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(AppColors.selectedtile)
                                      ),
                                      onPressed: () => optInToOpportunity(
                                        foodBankId,
                                        opportunityId, // Pass opportunity ID
                                        opportunity['title'],
                                        opportunity['description'],
                                      ),
                                      child: Text(
                                        'Commit',
                                        style: TextStyle(
                                          fontFamily: 'intersB',
                                          fontSize: 14,
                                          color: AppColors.navbarcolorbg,
                                         
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  opportunity['title'],
                                  style: TextStyle(
                                    fontFamily: 'intersR',
                                    color: AppColors.titletext,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${opportunity['description']}',
                                  style: TextStyle(
                                    color: AppColors.titletext,
                                    fontSize: 12,
                                    fontFamily: 'interR',
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Positioned(
                              bottom: -20,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                                decoration: BoxDecoration(
                                  color: AppColors.selectedtile,
                                  border: Border.all(
                                    width: 4,
                                    color: AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Vacancies : ${opportunity['vacancies'].toString()}',
                                  style: TextStyle(
                                    fontFamily: 'interR',
                                    color: AppColors.navbarcolorbg,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  void optInToOpportunity(String foodBankId, String opportunityId, String title,
      String description) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Add to user's volunteering opportunities
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('volunteeringOpportunities')
        .doc(opportunityId) // Use the same opportunity ID
        .set({
      'foodBankId': foodBankId,
      'title': title,
      'description': description,
      'timestamp' : Timestamp.now()
    });

    // Update applicants in the FoodBanks collection
    FirebaseFirestore.instance
        .collection('FoodBanks')
        .doc(foodBankId)
        .collection('volunteeringOpportunities')
        .doc(opportunityId) // Use the same opportunity ID
        .update({
      'applicants': FieldValue.arrayUnion([
        {'userId': userId}
      ]),
    });
  }
}
