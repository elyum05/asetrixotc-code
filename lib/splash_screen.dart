import 'package:asetrix_app/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navHome() async {
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginpage()));
  }

  @override
  void initState() {
    navHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
      body: Center(
        child: Text('ASETRIX',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Anurati',
                fontSize: 16,
                letterSpacing: 28)),
      ),
    );
  }
}
