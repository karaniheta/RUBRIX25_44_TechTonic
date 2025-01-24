import 'package:anvaya/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  var points;
  String couponCode = '';
  String couponTitle = '';
  String companyName = '';
  bool isRedeemable = false;

  @override
  void initState() {
    super.initState();
    fetchUserPoints();
    fetchCouponDetails();
  }

  Future<void> fetchUserPoints() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    final foodbankdoc = await FirebaseFirestore.instance.collection('FoodBanks').doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        points = userDoc.data()!['points'] ;
        isRedeemable = points >= 100;
      });
    }
    else if (foodbankdoc.exists) {
      setState(() {
        points = foodbankdoc.data()!['points'] ;
        isRedeemable = points >= 100;
      });
    }
    else {
  setState(() {
    points = null;
    isRedeemable = false;
  });
}
  }

  Future<void> fetchCouponDetails() async {
    // You can change the 'someCouponId' to the actual coupon document ID you need to fetch.
    final couponDoc = await FirebaseFirestore.instance.collection('Coupon').doc('8OSoe58RcrhqG72Nsv6d').get();

    if (couponDoc.exists) {
      setState(() {
        companyName = couponDoc.data()!['companyname'] ?? '';
        couponCode = couponDoc.data()!['code'] ?? '';
        couponTitle = couponDoc.data()!['title'] ?? '';
      });
    }
  }

  void redeemCoupon() async {
    if (points < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need at least 100 points to redeem this coupon')),
      );
    } else {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Update points (deduct 100 points)
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'points': points - 100,
      });

      // Optionally, mark the coupon as redeemed (you can update a 'redeemed' field in the coupon document if needed)
      // await FirebaseFirestore.instance.collection('Coupon').doc('someCouponId').update({
      //   'redeemed': true, // or other logic to track coupon usage
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon redeemed! 100 points deducted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Rewards',
          style: TextStyle(fontFamily: 'interB', color: AppColors.titletext),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Green Points Box
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                child: Container(
                  height: 150,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Color(0xFF69ADB2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: 
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your Points",
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$points points",
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.star, // Star icon as the asterisk symbol
                            color: AppColors.secondaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                      
                     
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
        
            // Coupon Details Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 350,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xFF69ADB2), // Border color
                    width: 2, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.nonselected,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name
                    Text(
                      "Company Name: $companyName",
                      style: TextStyle(
                        color: AppColors.titletext,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Coupon Code
                    Text(
                      "Coupon Code: $couponCode",
                      style: TextStyle(
                        color: AppColors.titletext,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Coupon Title
                    Text(
                      "Title: $couponTitle",
                      style: TextStyle(
                        color: AppColors.titletext,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isRedeemable ? redeemCoupon : null,
                      child: Text(isRedeemable ? "Redeem Coupon" : "Insufficient Points"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


