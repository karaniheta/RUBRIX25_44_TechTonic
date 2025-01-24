import 'dart:math';
import 'package:async/async.dart';
import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/donation%20page/donation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:super_icons/super_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String address = "Loading address..."; // Default address text
  late Stream<Map<String, dynamic>?> userLocationStream;

  @override
  void initState() {
    super.initState();

    // Initialize the location stream to listen to the user’s location
    userLocationStream = UserService.fetchUserData();
  }

  // Method to get address from coordinates
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Failed to get address: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section with Background
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '📍',
                    style: TextStyle(
                      color: AppColors.titletext,
                      fontSize: 16,
                      fontFamily: 'intersB',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Using StreamBuilder to display real-time address updates
                  StreamBuilder<Map<String, dynamic>?>(
                    stream: userLocationStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading address...');
                      }
                      if (snapshot.hasError) {
                        return Text('Error fetching location');
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Text('Location data not found');
                      }

                      final userDoc = snapshot.data!;
                      final location = userDoc['location'];
                      double latitude = location['latitude'];
                      double longitude = location['longitude'];

                      return FutureBuilder<String>(
                        future: getAddressFromCoordinates(latitude, longitude),
                        builder: (context, addressSnapshot) {
                          if (addressSnapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading address...');
                          }
                          if (addressSnapshot.hasError) {
                            return Text('Error fetching address');
                          }
                          return Text(
                            addressSnapshot.data ?? "Address not found",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 16,
                              fontFamily: 'intersB',
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to Anvaya',
                    style: TextStyle(
                      color: AppColors.titletext,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your one stop solution for all your needs',
                    style: TextStyle(
                      color: AppColors.titletext,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Location Section
            SizedBox(height: 20),

            // Donate Button Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Donation()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Donate now!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),

            // Popular Products Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Donation Listing',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Products')
                          .where('owner_id', isNotEqualTo: ownerId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No products available.'));
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final products = snapshot.data!.docs;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 6 / 6,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index].data()
                                as Map<String, dynamic>;
                            return FutureBuilder<Widget>(
                              future: ProductCard(context, product),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Widget> ProductCard(BuildContext context, product) async {
  final user = await FirebaseFirestore.instance
      .collection('Users')
      .doc(product['owner_id'])
      .get();
  final foodbank = await FirebaseFirestore.instance
      .collection('FoodBanks')
      .doc(product['owner_id'])
      .get();

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.white,
    elevation: 6,
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage('assets/pizza.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),

          // Text Section
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(SuperIcons.bx_food_tag,
                          color: product['isveg'] ? Colors.green : Colors.red),
                      SizedBox(height: 5),
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Expires on: ${product['exp_date']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  // Contact Section
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 232, 232, 232),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(SuperIcons.mg_phone_call_line,
                                color: Colors.black, size: 18),
                            SizedBox(width: 5),
                            Text(
                              user.exists
                                  ? '${user['user_phoneNumber']}'
                                  : '${foodbank['foodbank_phoneNumber']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            receivedialog(context, product);
                          },
                          child: Text(
                            'Receive',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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

void receivedialog(BuildContext context, product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Receive Product'),
        content: Text('Are you sure you want to receive this product?'),
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

Future<void> Updatetransaction(product) async {
  final owner = FirebaseAuth.instance.currentUser!;
  final transaction =
      FirebaseFirestore.instance.collection('Transactions').doc();
  final code = Random().nextInt(8999) + 1000;
  transaction.set({
    'transactionId': transaction.id,
    'receiverId': owner.uid,
    'productId': product['product_id'],
    'productName': product['name'],
    'donorId': product['owner_id'],
    'foodbankId': 'temp',
    'time': Timestamp.now(),
    'unit': product['units'],
    'iscomplete': false,
    'code': code,
  });

  deleteproduct(product);
}

Future<void> deleteproduct(product) async {
  await FirebaseFirestore.instance
      .collection('Products')
      .doc(product['product_id'])
      .delete();
}



class UserService {
  // This method returns a Stream<Map<String, dynamic>> that includes data from both collections
  static Stream<Map<String, dynamic>?> fetchUserData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // If the user is not authenticated, return an empty stream.
      return Stream.value(null);
    }

    // Create streams for both Users and FoodBanks collections (if both are needed)
    Stream<DocumentSnapshot> userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots();
    
    Stream<DocumentSnapshot> foodBankStream = FirebaseFirestore.instance
        .collection('FoodBanks')
        .doc(userId)
        .snapshots();

    // Merge the two streams using StreamZip if necessary
    return StreamZip([userStream, foodBankStream]).map((List<DocumentSnapshot> documents) {
      DocumentSnapshot userDoc = documents[0];
      DocumentSnapshot foodBankDoc = documents[1];

      if (userDoc.exists) {
        return {'role': 'User', ...userDoc.data() as Map<String, dynamic>};
      } else if (foodBankDoc.exists) {
        return {'role': 'FoodBank', ...foodBankDoc.data() as Map<String, dynamic>};
      }
      return null; // Return null if neither document is found
    });
  }

  // Method to update user location in Firestore
  static Future<void> updateUserLocation(double latitude, double longitude) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (userId == null) {
      print("No user is currently logged in.");
      return;
    }

    try {
      // Get a reference to the user document
      final userDocRef = FirebaseFirestore.instance.collection('Users').doc(userId);

      // Update the user's location in Firestore
      await userDocRef.set({
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        },
      }, SetOptions(merge: true)); // merge: true ensures we don't overwrite other fields in the document.

      print("Location updated successfully!");
    } catch (e) {
      // Handle any errors that occur during the update
      print("Error updating user location: $e");
    }
  }

  // Stream to get real-time user location updates
  static Stream<Map<String, dynamic>?> getUserLocation() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // If the user is not authenticated, return an empty stream.
      return Stream.value(null);
    }

    // Listen to the user's document for real-time changes
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return {
          'location': data['location'],
        };
      }
      return null;
    });
  }
}



