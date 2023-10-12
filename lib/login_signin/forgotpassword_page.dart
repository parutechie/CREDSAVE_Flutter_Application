import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style_design/app_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPasswordController = TextEditingController();

  @override
  void dispose() {
    _forgotPasswordController.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _forgotPasswordController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Reset Link has been sent to you'r Email"),
            );
          });
    } on FirebaseAuthException {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('No User Found in this Email'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/images/forgot.png',
              height: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Password recovery',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'InterBold',
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'If you have forgotten your password, simply type your e-mail address.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            //email textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _forgotPasswordController,
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
                  prefixIcon: const Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
                  ),
                  hintText: '@credsave.email.com',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: GestureDetector(
                onTap: PasswordReset,
                child: Container(
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Color.fromARGB(255, 246, 246, 246),
                        )
                      ]),
                  child: Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: kteritaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
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
