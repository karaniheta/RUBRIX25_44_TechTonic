import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/donation%20page/donation.dart';
import 'package:flutter/material.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => Donation()));
            
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
          width: double.infinity, // Full width of the screen
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Number of columns
              crossAxisSpacing: 10, // Horizontal spacing
              mainAxisSpacing: 10, // Vertical spacing
              childAspectRatio: 3 / 2, // Aspect ratio of each item
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Productcard();
            },
          ),
            )
          ],
        ),
          )
        ]),
      ));
  }
}

// class ProductCard extends StatelessWidget {
//   final String title;
//   final IconData icon;

//   const ProductCard({
//     Key? key,
//     required this.title,
//     required this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(icon, size: 40, color: Colors.blue),
//           SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//  }

Widget Productcard() {
  return Card(
    
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    
    color: const Color.fromARGB(255, 255, 255, 255),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children:[ 
        Expanded(
          flex: 2,
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/pizza.png'),
              fit: BoxFit.cover,
            ),
          ),
              ),
        ),
    
      Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(SuperIcons.bx_food_tag, color: Colors.green),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              // SizedBox(height: 5),
              // Text(
              //   'Product Description',
              //   style: TextStyle(
              //     fontSize: 10,
              //   ),
              // ),
              // SizedBox(height: 5),
              Text(
                'Price: Rs.100',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
                              ],
              ),

            ],
          ),
        ),
      ),
      ]
    ),
  );
}

// }
