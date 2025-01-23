import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontFamily: 'interB', color: AppColors.titletext),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,5,20,5),
                      child: Text.rich(
                        TextSpan(children:[
                          TextSpan(
                            text: 'Welcome to Anvaya – Turning Food Surplus into Hope!',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 20,
                              fontFamily: 'interB'
                            )
                      
                      
                        ),
                        TextSpan(
                          text:'\n\nFood waste and hunger are two sides of the same global crisis. While millions of tons of edible food are discarded every year, millions of people struggle with hunger and food insecurity. At Anvaya, we aim to bridge this gap by creating a community-driven platform that connects food donors (restaurants, households, suppliers) with recipients (shelters, food banks, community centers).',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        
                       
                        TextSpan(
                            text: '\n\nOur Mission',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            )
                      
                      
                        ),
                        TextSpan(
                          text:'\nTo rescue surplus food, reduce waste, and provide nutritious meals to those in need—while fostering sustainable solutions to combat food insecurity.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                         TextSpan(
                            text: '\n\nHow We Make a Difference',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            )
                      
                      
                        ),
                        TextSpan(
                          text:'\n -> Simple & Seamless Connections: Donors and recipients can easily register, share, and access food donations.\n -> Real-Time Availability: Donors can list surplus food instantly, and recipients can locate donations nearby.\n -> Safety First: Clear verification and food handling guidelines ensure donations are safe and high-quality.\n -> Impact You Can See: Track the amount of food saved, meals served, and communities supported through our impact dashboard.\n -> Volunteer Opportunities: Get involved by helping with pickups, deliveries, or sorting donations to strengthen your community.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\nWhy Choose Us?',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            )
                      
                      
                        ),
                        TextSpan(
                          text:'\nANVAYA is more than just an app; its a movement for change. By working together, we can create a world where:',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          ),
                        
                        
                         
                        
                        ),
                          TextSpan(
                          text:'\n -> No food goes to waste.\n -> No one goes hungry.\n -> Communities grow stronger.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          ),
                        
                        
                         
                        
                        ),
                        TextSpan(
                          text:'\nJoin us in transforming lives—one meal at a time!',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          ),
                        
                        
                         
                        
                        ),
                        
                         
                        
                        
                        ])
                      ),
                    ),
              ),
            
          ],
        ),
      ),

    );
  }
}