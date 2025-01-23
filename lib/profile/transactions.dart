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

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format((transaction['time'] as Timestamp).toDate());

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
            colors: isReceiver
                ? [Colors.green.shade100, Colors.green.shade300]
                : [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isReceiver ? 'Received' : 'Donated',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isReceiver ? Colors.green.shade800 : Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.black54),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    transaction['productName'] ?? 'Unknown Product',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
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
