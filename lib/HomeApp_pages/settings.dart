import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/HomeApp_pages/notes.dart';
import 'package:cred_save/login_signin/forgotpassword_page.dart';
import 'package:cred_save/model/images_data.dart';
import 'package:cred_save/style_design/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../check_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _nameController = TextEditingController();

  bool slidevalue = false;
  bool selected = false;
  String username = '';
  String profileUrl = '';
  int _selectedAvatar = 0;
  final List<String> _avatarPaths = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
    avatar7,
  ];

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
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            const Text(
              'Profile',
              style: TextStyle(
                  fontFamily: 'InterBold',
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    //selection icon
                    Stack(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('UserInfo')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            String imageUrl = data['imageurls'];
                            return Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 1,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              //icon select dialog box
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: (context, setState) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 17),
                                      //profile pic show
                                      child: Container(
                                        height: 700,
                                        width: 500,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 5.0,
                                                          color: Colors.grey),
                                                    ],
                                                  ),

                                                  ////
                                                  child: Stack(children: [
                                                    Image.network(
                                                        _avatarPaths[
                                                            _selectedAvatar],
                                                        fit: BoxFit.cover),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          NetworkImage(_avatarPaths[
                                                              _selectedAvatar]);
                                                        });
                                                      },
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  height: 300,
                                                  width: 400,
                                                  child: ListView(children: [
                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 10,
                                                      children: List.generate(
                                                          _avatarPaths.length,
                                                          (index) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              _selectedAvatar =
                                                                  index;
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  image: NetworkImage(
                                                                      _avatarPaths[
                                                                          index]),
                                                                ),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        5.0,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            241,
                                                                            241,
                                                                            241),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ]),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  height: 60,
                                                  minWidth: 200,
                                                  color: kPrimaryColor,
                                                  child: const Text(
                                                    'Choose',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      final String imageurls =
                                                          _avatarPaths[
                                                              _selectedAvatar];
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'UserInfo')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        "imageurls": imageurls,
                                                      });
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFe8e8e8), blurRadius: 7.0),
                    ]),
                height: 500,
                width: 490,
                child: SafeArea(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        username,
                                        style: const TextStyle(
                                          fontFamily: 'PoppinsBold',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "${FirebaseAuth.instance.currentUser!.email}",
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),

                                  //logout pic
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckPage(),
                                            ));
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Icon(
                                        Icons.logout,
                                        size: 35,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            //functionn
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Account ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //fav forward icon
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Scaffold(
                                              backgroundColor:
                                                  Colors.transparent,
                                              body: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Center(
                                                  child: Container(
                                                    height: 200,
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            child: Text(
                                                                'Username',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'InterSemiBold',
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey)),
                                                          ),
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          //title
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: TextField(
                                                              controller:
                                                                  _nameController,
                                                              decoration:
                                                                  InputDecoration(
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              kPrimaryColor),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                hintText:
                                                                    'Enter your new username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                fillColor:
                                                                    Colors.grey[
                                                                        200],
                                                                filled: true,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Center(
                                                            child:
                                                                MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              height: 45,
                                                              minWidth: 120,
                                                              color:
                                                                  kPrimaryColor,
                                                              child: const Text(
                                                                'Change',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                final String
                                                                    name =
                                                                    _nameController
                                                                        .text;

                                                                setState(() {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'UserInfo')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      .update({
                                                                    "username":
                                                                        name,
                                                                  });
                                                                  //testing

                                                                  _nameController
                                                                      .text = '';

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            //share
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.backup_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'BackUp Codes',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //changepassword  pic
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NotesPage(),
                                          ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //preferences
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: 450,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    'Preferences',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            //dark mode
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.dark_mode_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Dark Mode ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  FlutterSwitch(
                                    height: 30,
                                    width: 60,
                                    activeColor: kPrimaryColor,
                                    inactiveColor: const Color.fromARGB(
                                        255, 233, 233, 233),
                                    onToggle: (bool value) {
                                      setState(() {
                                        selected = true;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25.0),
                                                  child: Container(
                                                    height: 120,
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        image:
                                                            const DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'assets/images/background.jpg',
                                                                ),
                                                                fit: BoxFit
                                                                    .cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: const Center(
                                                      child: Text(
                                                          'Dark Mode  will be Available Soon...',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'InterSemiBold',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      });
                                    },
                                    value: selected,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            //Language
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.share_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Share ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            //settings
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: 450,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            //ABout
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(Icons.settings,
                                          color: Colors.grey),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'About',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/background.jpg'),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5.0,
                                                    color: Color.fromARGB(
                                                        255, 219, 219, 219))
                                              ]),
                                          height: 200,
                                          width: 500,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Center(
                                                child: Text(
                                                  'CredSave',
                                                  style: TextStyle(
                                                      fontFamily: 'InterBold',
                                                      fontSize: 45,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                'version v1.0.0',
                                                style: TextStyle(
                                                    fontFamily: 'InterSemiBold',
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //support
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(Icons.support,
                                          color: Colors.grey),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Support',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                                color: Colors.white,
                                                height: 100,
                                                width: 400,
                                                child: const Center(
                                                    child: Text(
                                                        'Available Soon...')));
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            //logout
                            GestureDetector(
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CheckPage(),
                                      ));
                                });
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 9,
                                          ),
                                          Icon(Icons.logout_rounded,
                                              color: kPrimaryColor),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'LogOut',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
