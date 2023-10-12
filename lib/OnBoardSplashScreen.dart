// ignore_for_file: file_names

import 'package:cred_save/check_page.dart';
import 'package:cred_save/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'style_design/app_styles.dart';
import 'model/onboard_data.dart';
import 'style_design/size_configs.dart';

class OnBoardSplashScreen extends StatefulWidget {
  const OnBoardSplashScreen({super.key});

  @override
  State<OnBoardSplashScreen> createState() => _OnBoardSplashScreenState();
}

class _OnBoardSplashScreenState extends State<OnBoardSplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: const Duration(milliseconds: 400),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : kSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Future setseenOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seenOnboard = await prefs.setBool('seenOnboard', true);
  }

  @override
  void initState() {
    super.initState();
    setseenOnboard();
  }

  @override
  Widget build(BuildContext context) {
    //initialize size
    SizeConfig().init(context);
    // ignore: unused_local_variable
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(style: kBodyText1, children: [
                        TextSpan(
                          text: 'CRED',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Klasik',
                            fontSize: SizeConfig.blockSizeH! * 7,
                          ),
                        ),
                        TextSpan(
                          text: "SAVE",
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontFamily: 'Klasik',
                            fontSize: SizeConfig.blockSizeH! * 7,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    SizedBox(
                      height: sizeV * 50,
                      child: Image.asset(
                        onboardingContents[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: onboardingContents[index].richtext,
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  currentPage == onboardingContents.length - 1
                      ? MyTextButton(
                          buttonName: 'Get Started',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckPage(),
                              ),
                            );
                          },
                          bgColor: kPrimaryColor,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: List.generate(
                                onboardingContents.length,
                                (index) => dotIndicator(index),
                              ),
                            ),
                            OnBoardNavBtn(
                              name: 'Next',
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            )
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

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    required this.bgColor,
  }) : super(key: key);
  final String buttonName;
  final VoidCallback onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        height: SizeConfig.blockSizeH! * 15.5,
        width: SizeConfig.blockSizeH! * 80,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
          ),
          child: Text(
            buttonName,
            style: kBodyText2,
          ),
        ),
      ),
    );
  }
}

class OnBoardNavBtn extends StatelessWidget {
  const OnBoardNavBtn({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        splashColor: const Color.fromARGB(31, 229, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            name,
            style: kBodyText1,
          ),
        ));
  }
}
