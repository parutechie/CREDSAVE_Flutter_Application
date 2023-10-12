import 'dart:io';
import 'dart:ui' as ui;

import 'dart:typed_data';
import 'package:cred_save/components/encryption.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/components/searching_info.dart';
import 'package:cred_save/model/images_data.dart';
import 'package:cred_save/style_design/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class SearchPassword extends StatefulWidget {
  const SearchPassword({super.key});

  @override
  State<SearchPassword> createState() => _SearchPasswordState();
}

class _SearchPasswordState extends State<SearchPassword>
    with TickerProviderStateMixin {
  bool backPressed = false;
  final GlobalKey _containerKey = GlobalKey();

  //animation controller
  late AnimationController controllerToIncreasingCurve;
  late AnimationController controllerToDecreasingCurve;
  late Animation<double> animationToIncreasingCurve;
  late Animation<double> animationToDecreasingCurve;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController firstAniCon;
  late Animation firstAni;
  late Future resultsLoaded;
  bool isObscure = true;
  bool isFavorite = true;
  double turns = 0.0;
  // ignore: non_constant_identifier_names
  bool ObsecureText = true;
  bool isClicked = false;
  bool obsecureVisible = true;
  int _selectedAvatar = 0;
  List _allResults = [];
  List _resultsList = [];

  final List<String> _avatarPaths = [
    adobe,
    amazon,
    apple,
    behance,
    discord,
    dribble,
    dropbox,
    facebook,
    figma,
    github,
    gmail,
    google,
    icloud,
    instagram,
    linkedin,
    messenger,
    microsoft,
    netflix,
    outlook,
    paypal,
    pinrest,
    prime,
    reddit,
    skype,
    snapchat,
    spotify,
    stackoverflow,
    steam,
    telegram,
    ticktok,
    tumblr,
    twitch,
    twitter,
    udemy,
    vimeo,
    yahoo,
    youtube,
    zoom
  ];

  //share function
  Future<void> _shareImage() async {
    RenderRepaintBoundary boundary = _containerKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    final file = await new File('$tempPath/image.png').create();
    await file.writeAsBytes(pngBytes);

    await Share.shareFiles(
      [file.path],
      text: 'Check out this image!',
    );
  }

  //Get User UID
  var firebaseUser = FirebaseAuth.instance.currentUser;
  //geting document id for future edits
  final docUser = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("UserData")
      .doc();

  @override
  void initState() {
    controllerToIncreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controllerToDecreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationToIncreasingCurve = Tween<double>(begin: 500, end: 0).animate(
      CurvedAnimation(
        parent: controllerToIncreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    animationToDecreasingCurve = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: controllerToDecreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    controllerToIncreasingCurve.forward();

    firstAniCon = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    );

    firstAni = Tween<double>(begin: 0.741, end: 0).animate(
      CurvedAnimation(
          parent: firstAniCon,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic),
    );
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    controllerToIncreasingCurve.dispose();
    controllerToDecreasingCurve.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUserStreamSnapshot();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = PasswordInfo.fromSnapshot(tripSnapshot).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUserStreamSnapshot() async {
    final firebaseUsers = FirebaseAuth.instance.currentUser!.uid;
    var data = await FirebaseFirestore.instance
        .collection("UserData")
        .doc(firebaseUsers)
        .collection('UserCreds')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  //update methd
  Future<void> _updating([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _nameController.text = documentSnapshot['name'];
      _passwordController.text =
          Encryption.decrypt(documentSnapshot['password']);
    }
    await showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          Tween<Offset> tween;
          tween = Tween(begin: const Offset(-1, -1), end: Offset.zero);
          return SlideTransition(
            position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
            ),
            child: child,
          );
        },
        pageBuilder: (context, _, __) =>
            StatefulBuilder(builder: (context, setState) {
              return Center(
                child: Container(
                  height: 700,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'UPDATE',
                              style: TextStyle(
                                fontFamily: 'PoppinsBold',
                                fontSize: 34,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //selection icon
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 5.0, color: Colors.grey),
                                  ],
                                ),
                                ////
                                child: Stack(children: [
                                  Image.network(_avatarPaths[_selectedAvatar],
                                      fit: BoxFit.cover),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        NetworkImage(
                                            _avatarPaths[_selectedAvatar]);
                                      });
                                    },
                                  ),
                                ]),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    //icon select dialog box
                                    showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 17),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: ListView(children: [
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 10,
                                                    children: List.generate(
                                                        _avatarPaths.length,
                                                        (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedAvatar =
                                                                index;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
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
                                            ),
                                          ),
                                        ),
                                      ),
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
                          const SizedBox(height: 50),

                          //title
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Title',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //username
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Name',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //password
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Password',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          //create button
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            height: 60,
                            minWidth: 200,
                            color: kPrimaryColor,
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              final String title = _titleController.text;
                              final String name = _nameController.text;
                              final String password =
                                  Encryption.encrypt(_passwordController.text);
                              final String imageurls =
                                  _avatarPaths[_selectedAvatar];
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('UserData')
                                    .doc(firebaseUser!.uid)
                                    .collection('UserCreds')
                                    .doc(documentSnapshot!.id)
                                    .update({
                                  "imageurls": imageurls,
                                  "title": title,
                                  "name": name,
                                  "password": password
                                });
                                //testing
                                _titleController.text = '';
                                _nameController.text = '';
                                _passwordController.text = '';

                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  //delete method
  Future<void> _delete(String userId) async {
    await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('UserCreds')
        .doc(userId)
        .delete();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Deleted!')));
  }

  //read data
  Future<void> _readData([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _nameController.text = documentSnapshot['name'];
      _passwordController.text =
          Encryption.decrypt(documentSnapshot['password']);
    }
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        transitionAnimationController: firstAniCon,
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 900,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color.fromARGB(255, 207, 207, 207),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //selection icon
                        Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Color.fromARGB(255, 204, 204, 204))
                            ],
                          ),
                          child: Image.network(
                            documentSnapshot!['imageurls'],
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 20),
                        //title
                        Text(
                          documentSnapshot['title'],
                          style: const TextStyle(
                              fontFamily: 'perigobold',
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          documentSnapshot['name'],
                          style: const TextStyle(
                              fontFamily: 'perigo',
                              fontSize: 18,
                              color: Colors.grey),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        //password
                        TextField(
                          showCursor: true,
                          readOnly: true,
                          obscureText: ObsecureText,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Password',
                            suffixIcon: const Icon(Icons.copy),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 30),
                        //reveal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ObsecureText = !ObsecureText;
                                    });
                                  },
                                  child: ObsecureText
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.visibility_off_rounded),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          ObsecureText = !ObsecureText;
                                        });
                                      },
                                      child: ObsecureText
                                          ? const Text(
                                              'Reveal password ',
                                              style: TextStyle(
                                                fontFamily: 'periogo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const Text(
                                              'Hide password ',
                                              style: TextStyle(
                                                fontFamily: 'periogo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //edit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _updating(documentSnapshot);
                                      },
                                      child: const Text(
                                        'Edit ',
                                        style: TextStyle(
                                          fontFamily: 'periogo',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //share
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.ios_share_rounded,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //shareing
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return Scaffold(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    body: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: RepaintBoundary(
                                                          key: _containerKey,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            height: 550,
                                                            width: 330,
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0xffF3F2F2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                SizedBox(
                                                                  height: 175,
                                                                  width: 175,
                                                                  child: Image
                                                                      .network(
                                                                    documentSnapshot[
                                                                        'imageurls'],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  documentSnapshot[
                                                                      'title'],
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'SfPro',
                                                                      fontSize:
                                                                          49,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                QrImage(
                                                                  data: documentSnapshot[
                                                                      'password'],
                                                                  version:
                                                                      QrVersions
                                                                          .auto,
                                                                  size: 200.0,
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      _shareImage(),
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216),
                                                                        borderRadius: BorderRadius.circular(50),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                              blurRadius: 5.0,
                                                                              color: Color.fromARGB(255, 231, 231, 231))
                                                                        ]),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .share_rounded),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }));
                                      },
                                      child: const Text(
                                        'Share ',
                                        style: TextStyle(
                                          fontFamily: 'periogo',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //delete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _delete(documentSnapshot.id);
                                        Navigator.pop(context);
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          _delete(documentSnapshot.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Delete ',
                                          style: TextStyle(
                                            fontFamily: 'periogo',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
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
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backPressed = true;
        controllerToDecreasingCurve.forward();
        return true;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          backPressed == false
              ? animationToIncreasingCurve.value
              : animationToDecreasingCurve.value,
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 180,
                width: 500,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5.0,
                          color: Color.fromARGB(255, 220, 220, 220))
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Search ',
                                  style: TextStyle(
                                      fontFamily: 'InterBold',
                                      fontSize: 20,
                                      color: Colors.grey),
                                ),
                                Text(
                                  'Passwords',
                                  style: TextStyle(
                                      fontFamily: 'InterBold',
                                      fontSize: 20,
                                      color: Color.fromARGB(210, 0, 0, 0)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            hintText: 'search...',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Recently Added',
                  style: TextStyle(
                      fontFamily: 'perigosemibold',
                      fontSize: 15,
                      color: Color.fromARGB(239, 87, 87, 87),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _resultsList.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          _resultsList[index];
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () => _readData(documentSnapshot),
                              child: Container(
                                height: 95,
                                width: 600,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Color.fromARGB(
                                              255, 228, 228, 228))
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18)),
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
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
                                            documentSnapshot['imageurls'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                documentSnapshot['title'],
                                                style: const TextStyle(
                                                  fontFamily: 'InterSemiBold',
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                documentSnapshot['name'],
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 45, 45, 45),
                                                  fontFamily: 'Inter',
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    isObscure == false
                                                        ? documentSnapshot[
                                                            'password']
                                                        : Encryption.decrypt(
                                                                documentSnapshot[
                                                                    'password'])
                                                            .replaceAll(
                                                                RegExp(r"."),
                                                                "●"),
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 58, 58, 58),
                                                      fontFamily: 'Inter',
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //favourite toggle pemdkjf
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFavorite = !isFavorite;
                                        });
                                      },
                                      child: isFavorite
                                          ? Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Colors.grey[300],
                                            )
                                          : const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.redAccent,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
