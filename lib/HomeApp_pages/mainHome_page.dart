// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/HomeApp_pages/adding_pass.dart';
import 'package:cred_save/HomeApp_pages/search_page.dart';
import 'package:cred_save/components/encryption.dart';
import 'package:cred_save/components/firebase_service/service.dart';
import 'package:cred_save/components/page_animation.dart';
import 'package:cred_save/style_design/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int totalDocuments = 0;
  bool isObscure = true;
  bool obsecureVisible = true;
  String username = '';
  String profileUrl = '';

//username detail
  void _getUserInfo() async {
    var userdata = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = userdata.data()!['username'];
      profileUrl = userdata.data()!['imageurls'];
    });
  }

  @override
  void initState() {
    //gettiing tot doc count
    FirebaseServices.totalDocCollections.get().then((querySnapshot) {
      setState(() {
        totalDocuments = querySnapshot.docs.length;
      });
    });
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 255,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        color: Color.fromARGB(255, 209, 209, 209))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(profileUrl),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'hello,',
                                  style: TextStyle(
                                      fontFamily: 'perigosemibold',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 104, 104, 104)),
                                ),
                                Text(
                                  username,
                                  style: const TextStyle(
                                      fontFamily: 'perigobold',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MyCustomAnimatedRoute(
                                enterWidget: const SearchPassword(),
                              ),
                            );
                          },
                          child: Container(
                            height: 53,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'Keep',
                              style: TextStyle(
                                fontFamily: 'InterSemiBold',
                                fontSize: 35,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              "you're creds",
                              style: TextStyle(
                                fontFamily: 'InterSemiBold',
                                fontSize: 35,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: Text(
                              "save ",
                              style: TextStyle(
                                fontFamily: 'InterSemiBold',
                                fontSize: 35,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Lottie.network(
                            'https://assets5.lottiefiles.com/packages/lf20_96bovdur.json',
                            height: 150,
                            width: 150),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPasswords(),
                      ));
                },
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Color.fromARGB(255, 232, 232, 232),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.lock,
                              size: 55,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      'Passwords',
                                      style: TextStyle(
                                          fontFamily: 'perigo',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Saved',
                                      style: TextStyle(
                                          fontFamily: 'perigo',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                Text(
                                  '$totalDocuments ',
                                  style: const TextStyle(
                                      fontFamily: 'perigo',
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Added',
                    style: TextStyle(
                        fontFamily: 'perigosemibold',
                        fontSize: 20,
                        color: Color.fromARGB(239, 87, 87, 87),
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPasswords(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          fontFamily: 'perigosemibold',
                          fontSize: 15,
                          color: Color.fromARGB(255, 176, 176, 176),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //showing recently added Passwords.
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 380,
                width: 440,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('UserData')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('UserCreds')
                      .orderBy('timestamp', descending: true)
                      .limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((document) {
                        return SafeArea(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 94, ////
                                    width: 600,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 4,
                                              color: Color.fromARGB(
                                                  255, 239, 239, 239))
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 58,
                                              width: 58,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 4,
                                                      color: Color.fromARGB(
                                                          255, 204, 204, 204))
                                                ],
                                              ),
                                              child: Image.network(
                                                document['imageurls'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    document['title'],
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'InterSemiBold',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    document['name'],
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 45, 45, 45),
                                                      fontFamily: 'Inter',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        isObscure == false
                                                            ? document[
                                                                'password']
                                                            : Encryption.decrypt(
                                                                    document[
                                                                        'password'])
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r"."),
                                                                    "●"),
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 58, 58, 58),
                                                          fontFamily: 'Inter',
                                                          fontSize: 9,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
