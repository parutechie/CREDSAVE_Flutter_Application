import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/components/encryption.dart';
import 'package:cred_save/components/firebase_service/service.dart';
import 'package:cred_save/style_design/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../model/images_data.dart';

class AddPasswords extends StatefulWidget {
  const AddPasswords({super.key});

  @override
  State<AddPasswords> createState() => _AddPasswordsState();
}

class _AddPasswordsState extends State<AddPasswords>
    with TickerProviderStateMixin {
  //controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey _containerKey = GlobalKey();
  late AnimationController firstAniCon;
  late Animation firstAni;
  late String tester = '';

  int _selectedAvatar = 0;
  bool obsecureText = true;
  bool isObscure = true;
  bool obsecureVisible = true;
  bool _isSelected = false;

  @override
  void initState() {
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
  }

  @override
  void dispose() {
    firstAniCon.dispose();
    super.dispose();
  }

  //Image data
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

  //Get User UID
  var firebaseUser = FirebaseAuth.instance.currentUser;
  //geting document id for future edits
  final docUser = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("UserData")
      .doc();

  //share function
  Future<void> _shareImage() async {
    RenderRepaintBoundary boundary = _containerKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    final file = await File('$tempPath/image.png').create();
    await file.writeAsBytes(pngBytes);

    // ignore: deprecated_member_use
    await Share.shareFiles(
      [file.path],
      text: 'Check out this image!',
    );
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
                                  child: Image.network(
                                    documentSnapshot!['imageurls'],
                                    fit: BoxFit.cover,
                                  )),
                              if (_isSelected)
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
                                    setState(() {
                                      _isSelected = true;
                                    });
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
                                    .doc(documentSnapshot.id)
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

  //Create mthd
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _nameController.text = documentSnapshot['name'];
      _passwordController.text = documentSnapshot['password'];
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
                              'CREATE',
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
                              'Create',
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
                              final String uuid = firebaseUser!.uid;
                              final String imageurls =
                                  _avatarPaths[_selectedAvatar];
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('UserData')
                                    .doc(firebaseUser!.uid)
                                    .collection('UserCreds')
                                    .add({
                                  "imageurls": imageurls,
                                  "title": title,
                                  "name": name,
                                  "password": password,
                                  "id": docUser.id,
                                  "uid": uuid,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                              });
                              //await _users.add({"name": name, "password": password});
                              _titleController.text = '';
                              _nameController.text = '';
                              _passwordController.text = '';
                              Navigator.of(context).pop();
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
                          obscureText: obsecureText,
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
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FlutterClipboard.copy(
                                        _passwordController.text);
                                    Fluttertoast.showToast(
                                      msg: "Copied  to ClipBoard!",
                                      fontSize: 10,
                                      backgroundColor: Colors.grey[200],
                                      textColor: Colors.black,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  });
                                },
                                child: const Icon(Icons.copy)),
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
                                      obsecureText = !obsecureText;
                                    });
                                  },
                                  child: obsecureText
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
                                          obsecureText = !obsecureText;
                                        });
                                      },
                                      child: obsecureText
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    SizedBox(
                      height: 51,
                    ),
                    Text(
                      'My',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'InterBold',
                        color: Colors.black,
                        fontSize: 24,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () => _create(),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey[300], shape: BoxShape.circle),
                        child: const Icon(
                          Icons.add,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Stack(
              children: [
                StreamBuilder(
                  stream: FirebaseServices.getUserStreamSnapshot(context),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      if (streamSnapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Lottie.network(
                                        'https://assets7.lottiefiles.com/private_files/lf30_cgfdhxgx.json',
                                        height: 300)),
                              ]),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: GestureDetector(
                                      onTap: () => _readData(
                                          documentSnapshot), //_update(documentSnapshot),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) =>
                                                  _delete(documentSnapshot.id),
                                              icon: Icons.delete,
                                              backgroundColor: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ],
                                        ),
                                        startActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) =>
                                                  _updating(documentSnapshot),
                                              icon: Icons.edit,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          height: 100,
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
                                              borderRadius:
                                                  BorderRadius.circular(18)),
                                          margin: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 65,
                                                width: 65,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                  // image: DecorationImage(
                                                  //   image: NetworkImage(
                                                  //     documentSnapshot['imageurls'],
                                                  //   ),
                                                  //   fit: BoxFit.scaleDown,
                                                  // ),
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
                                                width: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      documentSnapshot['title'],
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'InterSemiBold',
                                                        fontSize: 21,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      documentSnapshot['name'],
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 45, 45, 45),
                                                        fontFamily: 'Inter',
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
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
                                                                      RegExp(
                                                                          r"."),
                                                                      "●"),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    58,
                                                                    58,
                                                                    58),
                                                            fontFamily: 'Inter',
                                                            fontSize: 7,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
