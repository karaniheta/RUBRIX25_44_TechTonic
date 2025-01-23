import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
    final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(),
      body:
    
    Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        children: [
          Row(
            children: [
              Text('Your Donations',
              style: TextStyle(
                fontFamily: 'interB',
                color: AppColors.titletext,
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
                  .collection('Products')
                  .where('owner_id', isEqualTo: ownerId)
                  // .doc(foodBankId)
                  // .collection('volunteeringOpportunities')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
      
                final products = snapshot.data!.docs;
      
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index].data() as Map<String, dynamic>;
      
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(product['product_name'],
                                style: TextStyle(
                                  fontFamily: 'intersB',
                                  color: AppColors.navbarcolorbg,
                                  fontSize: 18
                                ),),

                                Spacer(),

                                IconButton(onPressed: (){},
                                // Deletecon(),
                                
                                  icon: Icon(Icons.delete), color: AppColors.navbarcolorbg,)
                              ],
                            ),

                            SizedBox(height: 10,),

                            Text(product['product_description'],
                            style: TextStyle(
                              fontFamily: 'interR',
                              color: AppColors.navbarcolorbg,
                              fontSize: 14
                            ),),

                            SizedBox(height: 10,),

                            Container(
                              padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                              decoration: BoxDecoration(
                                color: AppColors.selectedtile,
                                border: Border.all(color: AppColors.navbarcolorbg),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('Quantity : ${product['product_units'].toString()}',
                              style: TextStyle(
                                fontFamily: 'interR',
                                color: AppColors.navbarcolorbg,
                                fontSize: 14
                              ),),
                            ),
                          ],
                        ),
                      )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }


  // void Deletecon() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Delete Vacancy'),
  //         content: Text('Are you sure you want to delete this vacancy?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('No'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               products[index].reference.delete();
  //               Navigator.pop(context);
  //             },
  //             child: Text('Yes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
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
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Add new vacancy',
                      style: TextStyle(
                        fontFamily: 'interB',
                        fontSize: 22,
                        color: AppColors.selectedtile
                      ),
                      ),

                      Spacer(),

                      IconButton(onPressed:() {Navigator.pop(context);}, icon: Icon(Icons.close, color: AppColors.titletext,))
                    ],
                  ),

                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Vacency Title',
                        labelStyle: TextStyle(
                          fontFamily: 'interR',
                          color: AppColors.text,
                          fontSize: 14
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cant be blank';
                        }
                        return null;
                      }
                    ),
                  ),),

                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontFamily: 'interR',
                          color: AppColors.text,
                          fontSize: 14
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description cant be blank';
                        }
                        return null;
                      }
                    ),
                  ),),

                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: TextFormField(
                      controller: _vacanciesController,
                      decoration: InputDecoration(
                        labelText: 'Number of Vacencies',
                        labelStyle: TextStyle(
                          fontFamily: 'interR',
                          color: AppColors.text,
                          fontSize: 14
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cant be blank';
                        }
                        return null;
                      }
                    ),
                  ),),
                  Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.titletext,
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed:(){ addVacancy(_titleController.text, _descriptionController.text , int.parse(_vacanciesController.text));},
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
    final ownerid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('Products')
        // .doc(foodBankId)
        // .collection('volunteeringOpportunities')
        .add({
          'owner_id': ownerid,
          'product_name': title,
          'product_description': description,
          'product_units': vacancies,
          // 'applicants': [],
        });
  }
}