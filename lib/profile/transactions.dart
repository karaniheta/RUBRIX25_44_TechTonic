// import 'dart:math';

// import 'package:anvaya/constants/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Transactions extends StatefulWidget {
//   const Transactions({super.key});

//   @override
//   State<Transactions> createState() => _TransactionsState();
// }

// class _TransactionsState extends State<Transactions> {
//   User? user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Transactions"),
//         backgroundColor: AppColors.secondaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(10),
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('Transactions').snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text('No transactions found.'));
//               }

//               final allTransactions = snapshot.data!.docs;

//               // Filter transactions for the current user
//               final userTransactions = allTransactions.where((doc) {
//                 final transaction = doc.data() as Map<String, dynamic>;
//                 return transaction['receiverId'] == user!.uid || transaction['donorId'] == user!.uid;
//               }).toList();

//               userTransactions.sort((a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));

//               if (userTransactions.isEmpty) {
//                 return Center(child: Text('No transactions for this user.'));
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: userTransactions.length,
//                 itemBuilder: (context, index) {
//                   final transaction = userTransactions[index].data() as Map<String, dynamic>;
//                   return TransactionCard(
//                     transaction: transaction,
//                     user: user,
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TransactionCard extends StatelessWidget {
//   final Map<String, dynamic> transaction;
//   final User? user;

//   const TransactionCard({required this.transaction, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
//         .format((transaction['time'] as Timestamp).toDate());
//     final code;
//     final ispending = transaction['iscomplete']==false;

//     final isReceiver = transaction['receiverId'] == user!.uid;

//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Container(
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: ispending?[const Color.fromARGB(255, 227, 230, 200), const Color.fromARGB(255, 199, 199, 129)]:
//             (isReceiver
//                 ? [Colors.green.shade100, Colors.green.shade300]
//                 : [Colors.blue.shade100, Colors.blue.shade300]),
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                    ispending?'Pending':(isReceiver ? 'Received' : 'Donated'),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: ispending? const Color.fromARGB(255, 168, 139, 12):(isReceiver ? Colors.green.shade800 : Colors.blue.shade800),
//                   ),
//                 ),
//                 if (isReceiver&&ispending)
//                   Text(
//                     '${transaction['code']}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: ispending? const Color.fromARGB(255, 168, 139, 12): (isReceiver ? Colors.green.shade800 : Colors.blue.shade800),
//                     ),
//                   ),
                
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.shopping_bag, color: Colors.black54),
//                 SizedBox(width: 5),
//                 Expanded(
//                   child: Text(
//                     transaction['productName'] ?? 'Unknown Product',
//                     style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: 'interR',fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.black54),
//                 SizedBox(width: 5),
//                 Text(
//                   'Date: $formattedDate',
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(
        title: Text("Transactions"),
        backgroundColor: AppColors.secondaryColor,
      ),
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

              userTransactions.sort((a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));

              if (userTransactions.isEmpty) {
                return Center(child: Text('No transactions for this user.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = userTransactions[index].data() as Map<String, dynamic>;
                  return TransactionCard(
                    transaction: transaction,
                    user: user,
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

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final User? user;

  const TransactionCard({required this.transaction, required this.user});

  void _verifyCode(BuildContext context) {
    TextEditingController codeController = TextEditingController();

Future<void> addPointsToDonorAfterTransaction(String donorId) async {
  try {
    // References to both collections
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final foodbankCollection = FirebaseFirestore.instance.collection('Foodbanks');

    bool isDonorFound = false;

    // Check the 'Users' collection
    final userDoc = await userCollection.doc(donorId).get();
    if (userDoc.exists) {
      await userCollection.doc(donorId).update({
        'points': FieldValue.increment(50),
      });
      print("Points added to donor in 'Users' collection.");
      isDonorFound = true;
    }

    // If not found in 'Users', check the 'Foodbank' collection
    if (!isDonorFound) {
      final foodbankDoc = await foodbankCollection.doc(donorId).get();
      if (foodbankDoc.exists) {
        await foodbankCollection.doc(donorId).update({
          'points': FieldValue.increment(50),
        });
        print("Points added to donor in 'Foodbank' collection.");
        isDonorFound = true;
      }
    }

    if (!isDonorFound) {
      print("Donor ID not found in either collection.");
    }
  } catch (e) {
    print("Failed to add points to donor: $e");
  }
}


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Verify Code"),
          content: TextField(
            controller: codeController,
            decoration: InputDecoration(hintText: "Enter the code"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String enteredCode = codeController.text.trim();
                if (int.parse(enteredCode) == transaction['code']) {
                  // Update Firestore to mark transaction as complete
                  await FirebaseFirestore.instance
                      .collection('Transactions')
                      .doc(transaction['transactionId'])
                      .update({'iscomplete': true});
                      addPointsToDonorAfterTransaction(transaction['donorId']);
                      

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transaction marked as complete!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect code!")),
                  );
                }
                Navigator.pop(context);
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format((transaction['time'] as Timestamp).toDate());
    final ispending = transaction['iscomplete'] == false;
    final isReceiver = transaction['receiverId'] == user!.uid;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ispending
                ? [
                    const Color.fromARGB(255, 227, 230, 200),
                    const Color.fromARGB(255, 199, 199, 129)
                  ]
                : (isReceiver
                    ? [Colors.green.shade100, Colors.green.shade300]
                    : [Colors.blue.shade100, Colors.blue.shade300]),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ispending
                      ? 'Pending'
                      : (isReceiver ? 'Received' : 'Donated'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ispending
                        ? const Color.fromARGB(255, 168, 139, 12)
                        : (isReceiver
                            ? Colors.green.shade800
                            : Colors.blue.shade800),
                  ),
                ),
                if (transaction['donorId'] == user!.uid && ispending)
                  ElevatedButton(
                    onPressed: () => _verifyCode(context),
                    child: Text("Verify"),
                  ),
                if (isReceiver && ispending)
                  Text(
                    '${transaction['code']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ispending
                          ? const Color.fromARGB(255, 168, 139, 12)
                          : (isReceiver
                              ? Colors.green.shade800
                              : Colors.blue.shade800),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.black54),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    transaction['productName'] ?? 'Unknown Product',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontFamily: 'interR',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black54),
                SizedBox(width: 5),
                Text(
                  'Date: $formattedDate',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
