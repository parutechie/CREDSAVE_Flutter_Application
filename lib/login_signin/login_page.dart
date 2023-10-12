import 'package:cred_save/login_signin/OneWayAuth/google_login.dart';
import 'package:cred_save/login_signin/register_page.dart';
import 'package:cred_save/style_design/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../home_page.dart';
import 'forgotpassword_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obsecure = true;

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    //show loading scren
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: Lottie.network(
                'https://assets6.lottiefiles.com/packages/lf20_ffQfGn.json')
            // child: SpinKitFadingCircle(
            //   itemBuilder: (BuildContext context, int index) {
            //     return DecoratedBox(
            //       decoration: BoxDecoration(
            //         color: index.isEven
            //             ? kPrimaryColor
            //             : Color.fromARGB(255, 251, 1, 255),
            //       ),
            //     );
            //   },
            // ),
            );
      },
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      //pop the circle
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  //wrong email popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Wrong Email Id'),
        );
      },
    );
  }

  //wrong password popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Wrong Password'),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Container(
              height: 350,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/bac.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                  fontFamily: 'SfPro', fontSize: 80, color: Colors.black),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              'Back!',
              style: TextStyle(
                  fontFamily: 'SfPro', fontSize: 80, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Sign In',
                      context: context,
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                        Tween<Offset> tween;
                        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
                        return SlideTransition(
                          position: tween.animate(
                            CurvedAnimation(
                                parent: animation, curve: Curves.easeInOut),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) => StatefulBuilder(
                        builder: (context, setState) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 650,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 5.0, color: Colors.grey)
                                    ]),
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: SingleChildScrollView(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Center(
                                              child: Text(
                                                "Sign In",
                                                style: TextStyle(
                                                  fontFamily: 'InterBold',
                                                  fontSize: 35,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Lottie.network(
                                                'https://assets8.lottiefiles.com/packages/lf20_y7qo8rnh.json',
                                                height: 200),
                                            //email textfield
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                              child: TextField(
                                                controller: _emailController,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPrimaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  prefixIcon: const Icon(
                                                    Icons.mail_outline,
                                                    color: Colors.grey,
                                                  ),
                                                  hintText: 'Email',
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            //password textfield
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                              child: TextField(
                                                obscureText: _obsecure,
                                                controller: _passwordController,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPrimaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  prefixIcon: const Icon(
                                                    Icons.lock_outline,
                                                    color: Colors.grey,
                                                  ),
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _obsecure = !_obsecure;
                                                      });
                                                    },
                                                    child: Icon(
                                                      _obsecure
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  hintText: 'Password',
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 26.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ForgotPasswordPage(),
                                                          ));
                                                    },
                                                    child: Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 80,
                                            ),
                                            //sign in box
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                              child: GestureDetector(
                                                onTap: signIn,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(23),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Sign In',
                                                      style: TextStyle(
                                                        color: kteritaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.circular(50)),
                    height: 65,
                    width: 190,
                    child: const Center(
                      child: Text(
                        'sign in',
                        style: TextStyle(
                            fontFamily: 'SfPro',
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await GoogleService().signInWithGoogle();

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 235, 235, 235),
                            borderRadius: BorderRadius.circular(20)),
                        height: 65,
                        width: 65,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Image.asset('assets/images/google.png',
                              fit: BoxFit.scaleDown),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 235, 235),
                          borderRadius: BorderRadius.circular(20)),
                      height: 65,
                      width: 65,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/apple.png',
                            fit: BoxFit.scaleDown),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: //note a member? reg new
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontFamily: 'SfPro',
                    color: kSecondaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                  },
                  child: Text(
                    '  Register Now',
                    style: TextStyle(
                      fontFamily: 'SfPro',
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
