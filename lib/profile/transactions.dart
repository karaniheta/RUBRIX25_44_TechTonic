import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class Transactions extends StatefulWidget {
//   const Transactions({super.key});

//   @override
//   State<Transactions> createState() => _TransactionsState();
// }

// class _TransactionsState extends State<Transactions> {
//   User? user = FirebaseAuth.instance.currentUser;

//   @override

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text('Transactions Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//                       // height: 200,
//                       width: double.infinity, // Full width of the screen
//                       padding: EdgeInsets.all(10),
//                       child: Expanded(
//                         child: StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('Transactions')
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                             if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
//                               return Center(
//                                   child: Text('Oops! Seems like there are no donations at the moment :('));
//                             }
        
//                             if (snapshot.hasError) {
//                               return Center(
//                                   child: Text('Error: ${snapshot.error}'));
//                             }
        
//                             final transactions = snapshot.data!.docs;
        
//                             return GridView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 1, // Number of columns
//                                 crossAxisSpacing: 10, // Horizontal spacing
//                                 mainAxisSpacing: 10, // Vertical spacing
//                                 childAspectRatio:
//                                     6 / 5, // Aspect ratio of each item
//                               ),
//                               itemCount: transactions.length,
//                               itemBuilder: (context, index) {
//                                 final transaction = transactions[index].data()
//                                     as Map<String, dynamic>;
//                                     if((transaction['receiverId'] == user!.uid)||(transaction['donorId'] == user!.uid)){
//                                 return FutureBuilder<Widget>(
//                                   future: 
//                                   Transactcard(context, transaction, user),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState == ConnectionState.waiting) {
//                                       return Center(child: CircularProgressIndicator());
//                                     } else if (snapshot.hasError) {
//                                       return Center(child: Text('Error: ${snapshot.error}'));
//                                     } else {
//                                       return snapshot.data!;
//                                     }
//                                   },
//                                 );
//                                 };
//                               },
//                             );
        
//                             // ListView.builder(
//                             //   physics: NeverScrollableScrollPhysics(),
//                             //   shrinkWrap: true,
//                             //   itemCount: products.length,
//                             //   itemBuilder: (context, index) {
//                             //     final product =
//                             //         products[index].data() as Map<String, dynamic>;
        
//                             //     return
//                             //     Productcard(product);
//                             //   },
//                             // );
//                           },
//                         ),
//                       ),
        
//                     ),
//       )


//       );
//     // );
//   }
// }

// Future<Widget> Transactcard(BuildContext context, Map<String, dynamic> transaction, User? user) async {

//   if (transaction['receiverId'] == user!.uid) {
//     return Card(
//       child: Column(
//         children: [
//           Text('Received'),
//           Text('${transaction['productName']}'),
//           Text('Date: ${transaction['time']}'),
//         ],
//       ),
//     );
//   }
// else{
//   return Card(
//     child: Column(
//       children: [
//           Text('Donated'),
//           Text('${transaction['productName']}'),
//           Text('Date: ${transaction['time']}'),

//       ],
//     ),
//   );}
// }

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Transactions').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No transactions found.'));
              }

              final allTransactions = snapshot.data!.docs;

              // Filter transactions for the current user
              final userTransactions = allTransactions.where((doc) {
                final transaction = doc.data() as Map<String, dynamic>;
                return transaction['receiverId'] == user!.uid || transaction['donorId'] == user!.uid;
              }).toList();

              if (userTransactions.isEmpty) {
                return Center(child: Text('No transactions for this user.'));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Single column
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3/1,
                ),
                itemCount: userTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = userTransactions[index].data() as Map<String, dynamic>;
                  return FutureBuilder<Widget>(
                    future: Transactcard(context, transaction, user),
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
            },
          ),
        ),
      ),
    );
  }
}

Future<Widget> Transactcard(BuildContext context, Map<String, dynamic> transaction, User? user) async {

  final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
      .format((transaction['time'] as Timestamp).toDate());
  if (transaction['receiverId'] == user!.uid) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Received',
            style: TextStyle(
              fontSize: 26,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),),
            Text('${transaction['productName']}'),
            Text('Date: ${formattedDate}'),
          ],
        ),
      ),
    );
  } else {
    return Card(
      child: Column(
        children: [
          Text('Donated'),
          Text('${transaction['productName']}'),
          Text('Date: ${formattedDate}'),
        ],
      ),
    );
  }
}
