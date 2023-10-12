import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/components/firebase_service/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

final TextEditingController _titleController = TextEditingController();
final TextEditingController _contentController = TextEditingController();

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'My ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        'Codes',
                        style: TextStyle(
                          fontFamily: 'InterSemiBold',
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                height: 475,
                                width: 300,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                      )
                                    ]),
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: TextField(
                                            style: const TextStyle(
                                                fontFamily: 'InterSemiBold',
                                                fontSize: 22,
                                                color: Colors.black),
                                            textAlign: TextAlign.center,
                                            controller: _titleController,
                                            decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              hintText: 'Title',
                                              hintStyle: TextStyle(
                                                fontFamily: 'InterSemiBold',
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: SizedBox(
                                            height: 300,
                                            width: 400,
                                            child: TextFormField(
                                              controller: _contentController,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              decoration: const InputDecoration
                                                      .collapsed(
                                                  hintText: 'Description'),
                                              maxLines: 10,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final String title =
                                                _titleController.text;
                                            final String content =
                                                _contentController.text;
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('Notes')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('BackUpCodes')
                                                  .add({
                                                "title": title,
                                                "content": content,
                                              });

                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 5.0,
                                                      color: Color.fromARGB(
                                                          255, 238, 238, 238))
                                                ]),
                                            child:
                                                const Icon(Icons.save_rounded),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: 55,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            'New Item',
                            style: TextStyle(
                                fontFamily: 'Inter', color: Colors.black),
                          ),
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /////
            Container(
              height: 400,
              width: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseServices.getUserNotesSnapshot(context),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (document != null) {
                                setState(() {
                                  _titleController.text = document['title'];
                                  _contentController.text = document['content'];
                                });
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                  builder: (context, setState) {
                                    return Center(
                                      child: Container(
                                        height: 475,
                                        width: 300,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                topRight: Radius.circular(40),
                                                bottomLeft:
                                                    Radius.circular(40)),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 5.0,
                                                color: Color.fromARGB(
                                                    255, 240, 240, 240),
                                              )
                                            ]),
                                        child: Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: TextField(
                                                      controller:
                                                          _titleController,
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        hintText: 'Title',
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                                  child: SizedBox(
                                                    height: 300,
                                                    width: 400,
                                                    child: TextField(
                                                      controller:
                                                          _contentController,
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        hintText: 'Title',
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                      maxLines: 10,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        final String title =
                                                            _titleController
                                                                .text;
                                                        final String content =
                                                            _contentController
                                                                .text;
                                                        setState(() {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Notes')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'BackUpCodes')
                                                              .doc(document.id)
                                                              .update({
                                                            "title": title,
                                                            "content": content,
                                                          });
                                                          _titleController
                                                              .text = '';
                                                          _contentController
                                                              .text = '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        234,
                                                                        234,
                                                                        234),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                  blurRadius:
                                                                      5.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          238,
                                                                          238))
                                                            ]),
                                                        child: const Icon(
                                                            Icons.save_rounded),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        final String title =
                                                            _titleController
                                                                .text;
                                                        final String content =
                                                            _contentController
                                                                .text;
                                                        setState(() {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Notes')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'BackUpCodes')
                                                              .doc(document.id)
                                                              .delete();
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        234,
                                                                        234,
                                                                        234),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                  blurRadius:
                                                                      5.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          238,
                                                                          238))
                                                            ]),
                                                        child: const Icon(
                                                          Icons.delete_rounded,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            });
                          },
                          child: Container(
                              height: 300,
                              width: 240,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 237, 237, 237),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5.0,
                                      color: Color.fromARGB(255, 240, 240, 240),
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      data['title'],
                                      style: const TextStyle(
                                          fontFamily: 'InterSemiBold',
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Text(
                                      data['content'],
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
