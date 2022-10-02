import 'package:asetrix_app/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:asetrix_app/firebase_services.dart';

class Loginpage extends StatefulWidget {
  Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backl.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 158),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Welcome to the\n',
                          style: TextStyle(
                              height: 1.58,
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ASETRIX OTC.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700))
                          ]),
                    ),
                  ),
                ],
              ),
              alignment: Alignment.center,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 95),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () async {
                  await FirebaseServices().signInWithGoogle();
                  var db = FirebaseFirestore.instance.collection(
                      '${FirebaseAuth.instance.currentUser!.email}');
                  db.doc(FirebaseAuth.instance.currentUser!.uid).set({
                    'orders': FieldValue.increment(0),
                  }, SetOptions(merge: true));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Body()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                    width: 275,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', height: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Login with Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        border: Border.all(
                            color: Color.fromRGBO(115, 115, 115, 1)
                                .withOpacity(0.15)),
                        borderRadius: BorderRadius.circular(15))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
