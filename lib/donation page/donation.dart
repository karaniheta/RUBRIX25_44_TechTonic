import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_icons/super_icons.dart';

class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
  
}

class _DonationState extends State<Donation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool? isveg = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Your Donations',
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
                      .collection('Products')
                      .where('owner_id', isEqualTo: ownerId)
                      // .orderBy('time_created', descending: true)
                      // .doc(foodBankId)
                      // .collection('volunteeringOpportunities')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('You dont have any donations yet'));
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final products = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product =
                            products[index].data() as Map<String, dynamic>;

                        return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        product['name'],
                                        style: TextStyle(
                                            fontFamily: 'intersB',
                                            color: AppColors.navbarcolorbg,
                                            fontSize: 18),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Deletecon(products[index].id);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: AppColors.navbarcolorbg,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    product['description'],
                                    style: TextStyle(
                                        fontFamily: 'interR',
                                        color: AppColors.navbarcolorbg,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    'exp date ${product['exp_date']}',
                                    style: TextStyle(
                                        fontFamily: 'interR',
                                        color: AppColors.navbarcolorbg,
                                        fontSize: 14),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.selectedtile,
                                        border: Border.all(
                                            color: AppColors.navbarcolorbg),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Quantity : ${product['units'].toString()}',
                                      style: TextStyle(
                                          fontFamily: 'interR',
                                          color: AppColors.navbarcolorbg,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void Deletecon(String documentId) {
    
    void deleteProductByPath(String documentId) async {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Donation?'),
          content: Text('Are you sure you want to delete this donation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                deleteProductByPath(documentId);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddVacancyDialog() {
    // setState(() {
      
    // });
    showDialog(
      
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          // height: 30,
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
                            'Add new donation',
                            style: TextStyle(
                                fontFamily: 'interB',
                                fontSize: 22,
                                color: AppColors.selectedtile),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                    isveg = null;
                              _nameController.clear();
                              _descriptionController.clear();
                              _vacanciesController.clear();
                              _dobController.clear();


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
                              controller: _nameController,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      fontFamily: 'interR',
                                      color: AppColors.text,
                                      fontSize: 14)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name cant be blank';
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
                                };
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
                                  labelText: 'Quantity',
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _dobController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(SuperIcons.bs_calendar),
                              labelText: 'Date of Expiry'),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate:DateTime(2100),
                            );
                            if (pickedDate != null) {
                              _dobController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                            }
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter the expiry date'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButton<bool>(
                          
                          hint: Text('Select Type'),
                          value: isveg,
                          items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text('Veg'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Non-Veg'),
                          ),
                        ], onChanged: (value) {
                          // if (mounted) {
                            setState(() {
                              isveg = value;
                            }
                            );
                          // }
                        }),
                      ),
                      SizedBox(
                        height: 20,
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
                                  _nameController.text,
                                  _descriptionController.text,
                                  int.parse(_vacanciesController.text),
                                   _dobController.text.toString(),

                                  );
                              Navigator.pop(context);
                              _nameController.clear();
                              _descriptionController.clear();
                              _vacanciesController.clear();
                              _dobController.clear();
                              isveg = null;
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Add Donation',
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

  void addVacancy(String title, String description, int quantity, String date) {
    final ownerid = FirebaseAuth.instance.currentUser!.uid;
    final product = FirebaseFirestore.instance.collection('Products').doc();

    product.set({
      'image': 'https://bhukkadcompany.com/wp/wp-content/uploads/2024/06/21-Best-Pizzas-in-Mumbai-You-Must-Try-A-Pizza-Lovers-Paradise-1-710x473.png',
      'product_id': product.id,
      'owner_id': ownerid,
      'name': title,
      'description': description,
      'units': quantity,
      'time_created': Timestamp.now(),
      'isveg': isveg,
      'exp_date':date,
      // 'image':
      // 'applicants': [],
    });
  }
}
