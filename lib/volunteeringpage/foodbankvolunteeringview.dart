import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodBankVolunteeringView extends StatefulWidget {
  @override
  _FoodBankVolunteeringViewState createState() => _FoodBankVolunteeringViewState();
}

class _FoodBankVolunteeringViewState extends State<FoodBankVolunteeringView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final foodBankId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        children: [
          Row(
            children: [
              Text('Volunteering dashboard',
              style: TextStyle(
                fontFamily: 'interB',
                color: AppColors.primaryColor,
                fontSize: 20
              ),),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0,0, 0),
                child: IconButton(
                  onPressed: () => _showAddVacancyDialog(),
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('FoodBanks')
                  .doc(foodBankId)
                  .collection('volunteeringOpportunities')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
      
                final opportunities = snapshot.data!.docs;
      
                return ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity = opportunities[index].data() as Map<String, dynamic>;
      
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(opportunity['title']),
                        subtitle: Text(opportunity['description']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            opportunities[index].reference.delete();
                          },
                          child: Text('Clear'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVacancyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Vacancy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _vacanciesController,
                decoration: InputDecoration(labelText: 'Vacancies'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addVacancy(
                  _titleController.text,
                  _descriptionController.text,
                  int.parse(_vacanciesController.text),
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addVacancy(String title, String description, int vacancies) {
    final foodBankId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('FoodBanks')
        .doc(foodBankId)
        .collection('volunteeringOpportunities')
        .add({
          'title': title,
          'description': description,
          'vacancies': vacancies,
          'applicants': [],
        });
  }
}
