import 'dart:math';
import 'package:asetrix_app/capitalize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:asetrix_app/firebase_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final Stream<QuerySnapshot> _user = FirebaseFirestore.instance
      .collection('${FirebaseAuth.instance.currentUser!.email}')
      .snapshots();

  final postName = TextEditingController();
  final tgUsername = TextEditingController();
  final desc = TextEditingController();

  Random random = Random();

  final List<String> items = [
    'I want to Buy',
    'I want to Sell',
  ];
  String? selectedValue;

  bool _validate = false;

  @override
  void dispose() {
    postName.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Add Order',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
      backgroundColor: Color.fromRGBO(7, 7, 7, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownPadding: EdgeInsets.all(7),
                    dropdownDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 22, 21, 31),
                        borderRadius: BorderRadius.circular(15)),
                    hint: Text(
                      'Buy or sell?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonHeight: 40,
                    buttonWidth: 140,
                    itemHeight: 40,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 12, 12, 15),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                    borderRadius: BorderRadius.circular(15))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 12, 12, 15),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: postName,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Short post name: ',
                    errorText: _validate ? 'The field is required!' : null,
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.65))),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 12, 12, 15),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: tgUsername,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Telegram username without "@": ',
                    errorText: _validate ? 'The field is required!' : null,
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.65))),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Container(
              height: 100,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 12, 12, 15),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: desc,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Description for the post:',
                    errorText: _validate ? 'The field is required!' : null,
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.65))),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 58, vertical: 25),
            child: InkWell(
              onTap: () {
                setState(() {
                  desc.text.isEmpty ? _validate = true : _validate = false;
                  postName.text.isEmpty ? _validate = true : _validate = false;
                  tgUsername.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
                if (selectedValue == 'I want to Buy') {
                  var db = FirebaseFirestore.instance.collection('posts_buy');
                  int id = random.nextInt(77777);
                  db
                      .doc('${FirebaseAuth.instance.currentUser!.email}#${id}')
                      .set({
                    'name': '${FirebaseAuth.instance.currentUser!.displayName}',
                    'postName': postName.text,
                    'desc': desc.text,
                    'photo': '${FirebaseAuth.instance.currentUser!.photoURL}',
                    'telegram': tgUsername.text,
                    'gmail': '${FirebaseAuth.instance.currentUser!.email}',
                    'id': id.toString()
                  });
                  var userPosts = FirebaseFirestore.instance.collection(
                      '${FirebaseAuth.instance.currentUser!.email}_posts');
                  userPosts
                      .doc('${FirebaseAuth.instance.currentUser!.uid}#${id}')
                      .set({
                    'name': '${FirebaseAuth.instance.currentUser!.displayName}',
                    'postName': postName.text,
                    'desc': desc.text,
                    'photo': '${FirebaseAuth.instance.currentUser!.photoURL}',
                    'telegram': tgUsername.text,
                    'gmail': '${FirebaseAuth.instance.currentUser!.email}',
                    'id': id.toString()
                  });
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                  color: Color.fromRGBO(48, 48, 48, 0.35))),
                          titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                          backgroundColor: Color.fromRGBO(12, 12, 12, 1),
                          contentTextStyle: TextStyle(
                              color: Color.fromRGBO(181, 181, 181, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          title: Center(child: Text('Success!')),
                          content: Text(
                              'Your post has been added successfully!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)));
                    },
                    animationType: DialogTransitionType.slideFromTopFade,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 1),
                  );
                } else if (selectedValue == 'I want to Sell') {
                  var db = FirebaseFirestore.instance.collection('posts_sell');
                  int id = random.nextInt(77777);
                  db
                      .doc('${FirebaseAuth.instance.currentUser!.email}#${id}')
                      .set({
                    'name': '${FirebaseAuth.instance.currentUser!.displayName}',
                    'postName': postName.text,
                    'desc': desc.text,
                    'photo': '${FirebaseAuth.instance.currentUser!.photoURL}',
                    'telegram': tgUsername.text,
                    'gmail': '${FirebaseAuth.instance.currentUser!.email}',
                    'id': id.toString()
                  });
                  var userPosts = FirebaseFirestore.instance.collection(
                      '${FirebaseAuth.instance.currentUser!.email}_posts');
                  userPosts
                      .doc('${FirebaseAuth.instance.currentUser!.uid}#${id}')
                      .set({
                    'name': '${FirebaseAuth.instance.currentUser!.displayName}',
                    'postName': postName.text,
                    'desc': desc.text,
                    'photo': '${FirebaseAuth.instance.currentUser!.photoURL}',
                    'telegram': tgUsername.text,
                    'gmail': '${FirebaseAuth.instance.currentUser!.email}',
                    'id': id.toString()
                  });
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                  color: Color.fromRGBO(48, 48, 48, 0.35))),
                          titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                          backgroundColor: Color.fromRGBO(12, 12, 12, 1),
                          contentTextStyle: TextStyle(
                              color: Color.fromRGBO(181, 181, 181, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          title: Center(child: Text('Success!')),
                          content: Text(
                              'Your post has been added successfully!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)));
                    },
                    animationType: DialogTransitionType.slideFromTopFade,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 1),
                  );
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('Add post',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500))
                  ],
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
