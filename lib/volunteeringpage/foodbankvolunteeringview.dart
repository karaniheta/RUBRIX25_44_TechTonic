import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodBankVolunteeringView extends StatefulWidget {
  @override
  _FoodBankVolunteeringViewState createState() =>
      _FoodBankVolunteeringViewState();
}

class _FoodBankVolunteeringViewState extends State<FoodBankVolunteeringView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final foodBankId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'My Volunteering dashboard',
                style: TextStyle(
                    fontFamily: 'interB',
                    color: AppColors.titletext,
                    fontSize: 20),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    final opportunity =
                        opportunities[index].data() as Map<String, dynamic>;

                    return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      opportunity['title'],
                                      style: TextStyle(
                                          fontFamily: 'intersB',
                                          color: AppColors.navbarcolorbg,
                                          fontSize: 18),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed:
                                          opportunities[index].reference.delete,
                                      icon: Icon(Icons.delete),
                                      color: AppColors.navbarcolorbg,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  opportunity['description'],
                                  style: TextStyle(
                                      fontFamily: 'interR',
                                      color: AppColors.navbarcolorbg,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                
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
                                            color: AppColors.navbarcolorbg),
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Text(
                                      'Vacancies : ${opportunity['vacancies'].toString()}',
                                      style: TextStyle(
                                          fontFamily: 'interR',
                                          color: AppColors.navbarcolorbg,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                            ]
                          ),
                        ));
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
        return Container(
          height: 350,
          child: Form(
              key: _formKey,
              child: Card(
                elevation: 2,
                color: AppColors.navbarcolorbg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Add new vacancy',
                            style: TextStyle(
                                fontFamily: 'interB',
                                fontSize: 22,
                                color: AppColors.selectedtile),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppColors.titletext,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Container(
                          child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                  labelText: 'Vacency Title',
                                  labelStyle: TextStyle(
                                      fontFamily: 'interR',
                                      color: AppColors.text,
                                      fontSize: 14)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title cant be blank';
                                }
                                return null;
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Container(
                          child: TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                      fontFamily: 'interR',
                                      color: AppColors.text,
                                      fontSize: 14)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Description cant be blank';
                                }
                                return null;
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Container(
                          child: TextFormField(
                              controller: _vacanciesController,
                              decoration: InputDecoration(
                                  labelText: 'Number of Vacencies',
                                  labelStyle: TextStyle(
                                      fontFamily: 'interR',
                                      color: AppColors.text,
                                      fontSize: 14)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title cant be blank';
                                }
                                return null;
                              }),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.titletext,
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: TextButton(
                            onPressed: () {
                              addVacancy(
                                  _titleController.text,
                                  _descriptionController.text,
                                  int.parse(_vacanciesController.text));
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Post Vacancy',
                              style: TextStyle(
                                fontFamily: 'interB',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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

    _titleController.clear();
    _descriptionController.clear();
    _vacanciesController.clear();
  }
}
