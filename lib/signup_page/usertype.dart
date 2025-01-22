import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/signup_page/signorg_page.dart';
import 'package:anvaya/signup_page/signup_page.dart';
import 'package:flutter/material.dart';

class Usertype extends StatelessWidget {
  const Usertype({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        

        children: [
          Padding(padding: EdgeInsets.all(8.0)),
           SizedBox(height: 40),
                      Text('ANVAYA',
                      style: TextStyle(
                        fontFamily: 'interB',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF69adb2))),
                        SizedBox(height: 60,),
                        
                        SizedBox(
                          height: 200, child: Image.asset('assets/applogo.png')),
                          SizedBox(height: 150,),
          Padding(padding: EdgeInsets.all(16),

          
            child: 
            Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage())), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(double.infinity,50 ),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
          
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Container(
                    
                    
                    child: Center(
                      child: Text('SignUp as User',
                      
                      style: TextStyle(
                        fontFamily: 'intersB',
                        fontSize: 22,
                        color: AppColors.secondaryColor
                      ),),
                    ),
                  ),
                )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 1.8,
                    )),
                    Padding(padding: EdgeInsets.all(8.0),
                    child: Text('OR',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 22
                    ),),),
                    Expanded(child: 
                    Divider(
                      thickness: 1.8,
                    ))
                  
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SignorgPage())), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(double.infinity,50 ),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
          
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Container(
                    // width: 180,
                    child: Center(
                      child: Text('SignUp as FoodBank',
                      style: TextStyle(
                        fontFamily: 'intersB',
                        fontSize: 22,
                        color: AppColors.secondaryColor
                      ),),
                    ),
                  ),
                )),
          
              ],
            ),),
        ],
      )

    );
  }
}