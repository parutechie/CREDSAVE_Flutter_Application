import 'package:flutter/cupertino.dart';

import '../style_design/app_styles.dart';

class OnBoarding {
  final String image;
  final Widget richtext;

  OnBoarding({
    required this.image,
    required this.richtext,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    image: 'assets/images/onboarding_image_1.png',
    richtext: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: kBodyText3, children: [
        const TextSpan(text: 'Manage Your '),
        TextSpan(
          text: 'Passwords\n',
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        const TextSpan(text: 'All In one Place!'),
      ]),
    ),
  ),
  OnBoarding(
    image: 'assets/images/onboarding_image_2.png',
    richtext: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: kBodyText3, children: [
        const TextSpan(text: 'A '),
        TextSpan(
          text: 'Password ',
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        const TextSpan(text: 'Manager That\n'),
        const TextSpan(text: 'Syncs Across Devices'),
      ]),
    ),
  ),
  OnBoarding(
    image: 'assets/images/onboarding_image_3.png',
    richtext: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: kBodyText3, children: [
        const TextSpan(text: 'Never Forget a \n'),
        TextSpan(
          text: 'Password',
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        const TextSpan(text: ' Anymore'),
      ]),
    ),
  ),
];
