import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/donation%20page/donation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_icons/super_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.titletext,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to Anvaya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your one stop solution for all your needs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Donation()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Donate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 200,
                    width: double.infinity, // Full width of the screen
                    padding: EdgeInsets.all(10),
                    child: Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Products')
                            .where('owner_id', isNotEqualTo: ownerId)
                            // .orderBy('time_created', descending: true)
                            // .doc(foodBankId)
                            // .collection('volunteeringOpportunities')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text('Oops! Seems like there are no donations at the moment :('));
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          final products = snapshot.data!.docs;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, // Number of columns
                              crossAxisSpacing: 10, // Horizontal spacing
                              mainAxisSpacing: 10, // Vertical spacing
                              childAspectRatio:
                                  6 / 5, // Aspect ratio of each item
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index].data()
                                  as Map<String, dynamic>;
                              return FutureBuilder<Widget>(
                                future: Productcard(context, product),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else {
                                    return snapshot.data!;
                                  }
                                },
                              );
                            },
                          );

                          // ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: products.length,
                          //   itemBuilder: (context, index) {
                          //     final product =
                          //         products[index].data() as Map<String, dynamic>;

                          //     return
                          //     Productcard(product);
                          //   },
                          // );
                        },
                      ),
                    ),

                  )
                ],
              ),
            )
          ]),
        ));
  }
}


Future<Widget> Productcard(BuildContext context, product) async {
   final user = await FirebaseFirestore.instance.collection('Users').doc(product['owner_id']).get();
final foodbank = await FirebaseFirestore.instance.collection('FoodBanks').doc(product['owner_id']).get();
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: const Color.fromARGB(255, 255, 255, 255),
    child: Container(
      // height: 280,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(product['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 3,
          child: Container(
              // margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   flex: 2,
              //   child:
              Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(SuperIcons.bx_food_tag,
                          color: product['isveg'] ? Colors.green : Colors.red),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Expires on: ${product['exp_date']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  )),

              // ),
              // SizedBox(width: 50),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8,top: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon( SuperIcons.mg_phone_call_line,color:  const Color.fromARGB(255, 0, 0, 0),size: 18,),
                        SizedBox(width: 5),
                        Text( user.exists?
                          '${user['user_phoneNumber']}':'${foodbank['foodbank_phoneNumber']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      // margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          receivedialog(context, product);
                        },
                        child: Text(
                          'Recieve',
                          style: TextStyle(
                            fontFamily: 'interB',
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      )),
                ],
              ),
            ],
          )),
        ),
      ]),
    ),
  );

}

void receivedialog(BuildContext context,  product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Recieve Product'),
        content: Text('Are you sure you want to recieve this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              try {
                Updatetransaction(product);
              } catch (e) {
                print(e);
              }
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}


Future<void> Updatetransaction( product) async
{ 
   final owner = FirebaseAuth.instance.currentUser!;
    final transaction = FirebaseFirestore.instance.collection('Transactions').doc();

    transaction.set({
      'transactionId': transaction.id,
      'receiverId': owner.uid,
      'productId': product['product_id'],
      'productName': product['name'],
      'donorId': product['owner_id'],
      'foodbankId': 'temp',
      'time': Timestamp.now(),
      'unit': product['units'],
    });

          await FirebaseFirestore.instance
          .collection('Products')
          .doc(product['product_id'])
          .delete();



}
// }
