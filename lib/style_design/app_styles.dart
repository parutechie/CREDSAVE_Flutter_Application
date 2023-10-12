import 'package:flutter/material.dart';
import 'size_configs.dart';

Color kPrimaryColor = const Color(0xffd78dfa);
Color kSecondaryColor = const Color(0xff141414);
Color kteritaryColor = const Color(0xffffffff);

final kTitle = TextStyle(
  fontFamily: 'Klasik',
  fontSize: SizeConfig.blockSizeH! * 7,
  color: kSecondaryColor,
);

final kBodyText1 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontWeight: FontWeight.bold,
);

final kBodyText2 = TextStyle(
  color: kteritaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontFamily: 'Klasik',
);

final kBodyText3 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontFamily: 'Klasik',
);
