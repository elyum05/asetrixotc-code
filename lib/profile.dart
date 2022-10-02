import 'dart:io';

import 'package:asetrix_app/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Stream<QuerySnapshot> _userPosts = FirebaseFirestore.instance
      .collection('${FirebaseAuth.instance.currentUser!.email}_posts')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 15, 21, 1),
        elevation: 0,
        centerTitle: true,
        title: Text('My profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w500)),
      ),
      backgroundColor: Color.fromRGBO(7, 7, 7, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 28),
                  child: CircleAvatar(
                    radius: 49,
                    backgroundImage: NetworkImage(
                        '${FirebaseAuth.instance.currentUser!.photoURL}'),
                  ),
                ),
                Text('${FirebaseAuth.instance.currentUser!.email}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                          '${FirebaseAuth.instance.currentUser!.displayName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      alignment: Alignment.center,
                      width: 215,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(7, 7, 7, 0.65),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        await FirebaseServices().googleSignOut();
                        exit(0);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.logout, color: Colors.white),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 231, 46, 46),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromRGBO(15, 15, 21, 1),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(52),
                    bottomLeft: Radius.circular(52))),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('My posts',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _userPosts,
            builder: (context, snapshots) {
              return (snapshots.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 25),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(data['photo']),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(data['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        Text(data['postName'],
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    125, 125, 125, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400))
                                      ],
                                    ),
                                    Spacer(),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    side: BorderSide(
                                                        color: Color.fromRGBO(
                                                            48, 48, 48, 0.35))),
                                                titleTextStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                backgroundColor: Color.fromRGBO(
                                                    12, 12, 12, 1),
                                                contentTextStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        181, 181, 181, 1),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                title: Center(
                                                    child: Text('Information')),
                                                content: Container(
                                                  height: 275,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(data['desc'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          onTap: () {
                                                            launch(
                                                                'https://t.me/${data['telegram']}');
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons.send),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                    'My Telegram',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ],
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12,
                                                                vertical: 3),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          onTap: () {
                                                            launch(
                                                                'mailto:${data['gmail']}');
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons.mail),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text('My Gmail',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ],
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .yellow,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          },
                                          animationType: DialogTransitionType
                                              .slideFromTopFade,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                      child: Container(
                                        child: Icon(
                                            CupertinoIcons.info_circle_fill,
                                            size: 17),
                                        padding: EdgeInsets.all(15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    side: BorderSide(
                                                        color: Color.fromRGBO(
                                                            48, 48, 48, 0.35))),
                                                titleTextStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                backgroundColor: Color.fromRGBO(
                                                    12, 12, 12, 1),
                                                contentTextStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        181, 181, 181, 1),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                title: Center(
                                                    child: Text('Attention!')),
                                                content: Container(
                                                  height: 125,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          'Do you want to delete your post?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.75),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Container(
                                                              width: 110,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(18),
                                                              child: Text(
                                                                  'Close',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              var userPosts =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          '${FirebaseAuth.instance.currentUser!.email}_posts');
                                                              userPosts
                                                                  .doc(
                                                                      '${FirebaseAuth.instance.currentUser!.uid}#${data['id']}')
                                                                  .delete();
                                                              var posts_buy =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'posts_buy');
                                                              var posts_sell =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'posts_sell');
                                                              posts_buy
                                                                  .doc(
                                                                      '${FirebaseAuth.instance.currentUser!.email}#${data['id']}')
                                                                  .delete();
                                                              posts_sell
                                                                  .doc(
                                                                      '${FirebaseAuth.instance.currentUser!.email}#${data['id']}')
                                                                  .delete();
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Container(
                                                              width: 110,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(18),
                                                              child: Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          231,
                                                                          46,
                                                                          46),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          },
                                          animationType: DialogTransitionType
                                              .slideFromTopFade,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 231, 46, 46),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(16, 16, 16, 1),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            );
                          }),
                    );
            },
          ),
        ],
      ),
    );
  }
}
