import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'capitalize.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _posts_buy =
      FirebaseFirestore.instance.collection('posts_buy').snapshots();

  final Stream<QuerySnapshot> _posts_sell =
      FirebaseFirestore.instance.collection('posts_sell').snapshots();

  String postSearch = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(7, 7, 7, 3),
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 65, vertical: 25),
              child: Container(
                padding: EdgeInsets.all(7),
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  tabs: [
                    Tab(
                      child: Text('Buyers',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                    Tab(
                      child: Text('Sellers',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(15, 15, 21, 1),
                    borderRadius: BorderRadius.circular(7)),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                postSearch = val;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search,
                                    color: Colors.white.withOpacity(0.58)),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.58),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(16, 16, 16, 1),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _posts_buy,
                        builder: (context, snapshots) {
                          return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                              ? Center(child: CircularProgressIndicator())
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshots.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var data = snapshots.data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        if (postSearch.isEmpty) {
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
                                                        NetworkImage(
                                                            data['photo']),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(data['name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(data['postName'],
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      125,
                                                                      125,
                                                                      125,
                                                                      1),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    onTap: () {
                                                      showAnimatedDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  side: BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          48,
                                                                          48,
                                                                          48,
                                                                          0.35))),
                                                              titleTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                      12, 12, 12, 1),
                                                              contentTextStyle: TextStyle(
                                                                  color: Color.fromRGBO(
                                                                      181, 181, 181, 1),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w400),
                                                              title: Center(child: Text('Information')),
                                                              content: Container(
                                                                height: 275,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        data[
                                                                            'desc'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'https://t.me/${data['telegram']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.send),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Telegram', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'mailto:${data['gmail']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.mail),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Gmail', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.yellow,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                        animationType:
                                                            DialogTransitionType
                                                                .slideFromTopFade,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        duration: Duration(
                                                            seconds: 1),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .info_circle_fill,
                                                              size: 17),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text('More info',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          );
                                        }
                                        if (data['postName']
                                            .toString()
                                            .startsWith(
                                                postSearch.capitalize())) {
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
                                                        NetworkImage(
                                                            data['photo']),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(data['name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(data['postName'],
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      125,
                                                                      125,
                                                                      125,
                                                                      1),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    onTap: () {
                                                      showAnimatedDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  side: BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          48,
                                                                          48,
                                                                          48,
                                                                          0.35))),
                                                              titleTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                      12, 12, 12, 1),
                                                              contentTextStyle: TextStyle(
                                                                  color: Color.fromRGBO(
                                                                      181, 181, 181, 1),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w400),
                                                              title: Center(child: Text('Information')),
                                                              content: Container(
                                                                height: 175,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        data[
                                                                            'desc'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'https://t.me/${data['telegram']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.send),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Telegram', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'mailto:${data['gmail']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.mail),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Gmail', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.yellow,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                        animationType:
                                                            DialogTransitionType
                                                                .slideFromTopFade,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        duration: Duration(
                                                            seconds: 1),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .info_circle_fill,
                                                              size: 17),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text('More info',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                postSearch = val;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search,
                                    color: Colors.white.withOpacity(0.58)),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.58),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(16, 16, 16, 1),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _posts_sell,
                        builder: (context, snapshots) {
                          return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                              ? Center(child: CircularProgressIndicator())
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshots.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var data = snapshots.data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        if (postSearch.isEmpty) {
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
                                                        NetworkImage(
                                                            data['photo']),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(data['name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(data['postName'],
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      125,
                                                                      125,
                                                                      125,
                                                                      1),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    onTap: () {
                                                      showAnimatedDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  side: BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          48,
                                                                          48,
                                                                          48,
                                                                          0.35))),
                                                              titleTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                      12, 12, 12, 1),
                                                              contentTextStyle: TextStyle(
                                                                  color: Color.fromRGBO(
                                                                      181, 181, 181, 1),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w400),
                                                              title: Center(child: Text('Information')),
                                                              content: Container(
                                                                height: 275,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        data[
                                                                            'desc'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'https://t.me/${data['telegram']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.send),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Telegram', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'mailto:${data['gmail']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.mail),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Gmail', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.yellow,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                        animationType:
                                                            DialogTransitionType
                                                                .slideFromTopFade,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        duration: Duration(
                                                            seconds: 1),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .info_circle_fill,
                                                              size: 17),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text('More info',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          );
                                        }
                                        if (data['postName']
                                            .toString()
                                            .startsWith(
                                                postSearch.capitalize())) {
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
                                                        NetworkImage(
                                                            data['photo']),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(data['name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(data['postName'],
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      125,
                                                                      125,
                                                                      125,
                                                                      1),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    onTap: () {
                                                      showAnimatedDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  side: BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          48,
                                                                          48,
                                                                          48,
                                                                          0.35))),
                                                              titleTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                      12, 12, 12, 1),
                                                              contentTextStyle: TextStyle(
                                                                  color: Color.fromRGBO(
                                                                      181, 181, 181, 1),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w400),
                                                              title: Center(child: Text('Information')),
                                                              content: Container(
                                                                height: 175,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        data[
                                                                            'desc'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'https://t.me/${data['telegram']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.send),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Telegram', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        onTap:
                                                                            () {
                                                                          launch(
                                                                              'mailto:${data['gmail']}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.mail),
                                                                              SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text('My Gmail', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.yellow,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                        animationType:
                                                            DialogTransitionType
                                                                .slideFromTopFade,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        duration: Duration(
                                                            seconds: 1),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .info_circle_fill,
                                                              size: 17),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text('More info',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                );
                        },
                      ),
                    ],
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
