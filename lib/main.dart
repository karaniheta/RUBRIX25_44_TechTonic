import 'package:anvaya/bottom%20navbar/bnavbar.dart';
import 'package:anvaya/constants/app_theme.dart';
import 'package:anvaya/constants/colors.dart';
import 'package:anvaya/firebase_options.dart';
import 'package:anvaya/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future <void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anvaya',
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      // home:LoginPage(),
            home:SplashScreen(),

    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavbar()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
    appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.titletext,
          title: Text(
            'A  N  V  A  Y  A',
            style:
                TextStyle(fontFamily: 'interB', color: AppColors.primaryColor),
          )
          
          ),

          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 400,
                    child: Image.asset('assets/applogo.png'))
                ],
              ),
            ),
          ),
          backgroundColor: AppColors.titletext,
    );
  }
}

