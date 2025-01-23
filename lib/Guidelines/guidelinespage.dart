import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';

class Guidelinespage extends StatefulWidget {
  const Guidelinespage({super.key});

  @override
  State<Guidelinespage> createState() => _GuidelinespageState();
}

class _GuidelinespageState extends State<Guidelinespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guidelines',
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
                            text: '              Guidelines for Donors',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 20,
                              fontFamily: 'interB'
                            )
                      
                      
                        ),
                        TextSpan(
                            text: '\n\n1.Food Quality Requirements:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        TextSpan(
                          text:'\n -> Donate fresh, edible, and safe food items.\n -> Ensure all food is free from spoilage, mold, or contamination.\n -> Label food with clear descriptions (type, ingredients, and preparation date).',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                         TextSpan(
                            text: '\n\n2.Packaging Standards:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                             TextSpan(
                          text:'\n -> Use food-grade, tamper-proof containers for cooked and perishable items.\n -> Avoid leaking or damaged packaging.\n -> For raw produce, place in clean, breathable bags or crates.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n3.Expiration Date Compliance:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        
                       
                       
                        TextSpan(
                          text:'\n -> Only donate items with at least 24–48 hours before expiration.\n -> For prepared or cooked food, include the preparation date and time.\n -> Do not donate expired or past-due items.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                         TextSpan(
                            text: '\n\n4.Storage and Transport:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                         
                        TextSpan(
                          text:'\n -> Maintain proper temperature during transport:\n     a)Cold foods: ≤ 40°F (4°C).\n     b)Hot foods: ≥ 140°F (60°C).\n -> Use insulated boxes, ice packs, or hot bags as needed.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n5.Safety Practices:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        TextSpan(
                          text:'\n -> Separate raw and cooked food to prevent cross-contamination.\n -> Wash and clean raw produce before donation.\n -> Avoid donating food with allergens unless clearly labeled.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n6.Donation Transparency:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                      
                        TextSpan(
                          text:'\n -> Include detailed information about:\n     a)Food type (e.g., vegetarian, non-vegetarian,  gluten-free).\n     b)Ingredients to help recipients with dietary   restrictions.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                       
                          
                        
                        
                         
                    
                       
                        
                         
                        
                        
                        ]
                      
                        )
                        
                      ),
                      
                      
                    ),
                    
              ),
              Divider(
                thickness: 1.5,
              ),
              Center(
                child: Padding(padding: const EdgeInsets.fromLTRB(20,5,20,5),
                      child: Text.rich(
                        TextSpan(children:[
                          TextSpan(
                            text: '              Guidelines for Recipients',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 20,
                              fontFamily: 'interB'
                            )
                      
                      
                        ),
                        TextSpan(
                            text: '\n\n1.Food Inspection:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        TextSpan(
                          text:'\n -> Inspect all food upon receipt for signs of spoilage, mold, or damage.\n -> Verify expiration dates and preparation details.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                         TextSpan(
                            text: '\n\n2.Storage and Preservation:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                             TextSpan(
                          text:'\n -> Immediately store perishables:\n     a)Refrigerate at ≤ 40°F (4°C) for dairy, meat, and similar items.\n     b)Freeze food if not consumed within 24 hours.\n -> Keep dry goods in cool, dry places away from sunlight.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n3.Handling Cooked Food:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        
                       
                       
                        TextSpan(
                          text:'\n -> Reheat cooked food to at least 165°F (74°C) before consumption.\n -> Consume prepared or cooked food within the recommended time frame.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                         TextSpan(
                            text: '\n\n4.Allergy Awareness:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                         
                        TextSpan(
                          text:'\n -> Check food labels or donor-provided information for potential allergens.\n -> Do not consume food with unknown or unclear ingredients.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n5.Safe Usage:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                        TextSpan(
                          text:'\n -> Avoid accepting or consuming food that:\n     a)Smells off or has an unusual texture.\n     b)Has broken seals or damaged packaging.\n -> Discard any food that was not stored or transported safely.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                            text: '\n\n6.Feedback to Donors:',
                            style: TextStyle(
                              color: AppColors.titletext,
                              fontSize: 18,
                              fontFamily: 'intersB'
                            ),),
                      
                        TextSpan(
                          text:'\n -> Provide feedback on food quality and safety to help maintain donation standards.\n -> Report unsafe or rejected food via the app for quality monitoring.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                        TextSpan(
                          text:'\n\nBy splitting the guidelines into donor and receiver roles, both parties can ensure safe food practices while contributing to the goal of reducing food waste.',
                          style: TextStyle(
                            fontFamily: 'interR',
                            fontSize: 16
                          )
                        
                        ),
                       
                          
                        
                        
                         
                    
                       
                        
                         
                        
                        
                        ]
                      
                        )
                        
                      ),
                      ),
              ),
              Center(
                child: Text('Thank You',
                style: TextStyle(
                  fontFamily: 'interB',
                  fontSize: 22
                ),),
                
              )
            
          ],
          
        ),
      ),

    );
  }
}