import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cred_save/model/images_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future _addUserDetail(
  String username,
  String email,
  String image,
) async {
  await FirebaseFirestore.instance
      .collection('UserInfo')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
    "username": username,
    "email": email,
    "image": image,
    "imageurls": avatar7
  });
}

class GoogleService {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
        _addUserDetail(
          FirebaseAuth.instance.currentUser!.displayName!,
          FirebaseAuth.instance.currentUser!.email!,
          FirebaseAuth.instance.currentUser!.photoURL!,
        );
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message);
      rethrow;
    }
  }
}
