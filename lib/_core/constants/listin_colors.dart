import 'package:flutter/material.dart';

class ListinColors {
  static const MaterialColor green =
      MaterialColor(_greenPrimaryValue, <int, Color>{
    50: Color(0xFFF9FCEC),
    100: Color(0xFFF0F8D0),
    200: Color(0xFFE6F3B1),
    300: Color(0xFFDBEE92),
    400: Color(0xFFD4EA7A),
    500: Color(_greenPrimaryValue),
    600: Color(0xFFC7E35B),
    700: Color(0xFFC0DF51),
    800: Color(0xFFB9DB47),
    900: Color(0xFFADD535),
  });
  static const int _greenPrimaryValue = 0xFFCCE663;

  static const MaterialColor greenAccent =
      MaterialColor(_greenAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_greenAccentValue),
    400: Color(0xFFECFFB7),
    700: Color(0xFFE6FF9D),
  });
  static const int _greenAccentValue = 0xFFF9FFEA;

  static const MaterialColor purple =
      MaterialColor(_purplePrimaryValue, <int, Color>{
    50: Color(0xFFEDEAF4),
    100: Color(0xFFD1CBE4),
    200: Color(0xFFB3A8D2),
    300: Color(0xFF9585BF),
    400: Color(0xFF7E6AB2),
    500: Color(_purplePrimaryValue),
    600: Color(0xFF5F499C),
    700: Color(0xFF544092),
    800: Color(0xFF4A3789),
    900: Color(0xFF392778),
  });
  static const int _purplePrimaryValue = 0xFF6750A4;

  static const MaterialColor purpleAccent =
      MaterialColor(_purpleAccentValue, <int, Color>{
    100: Color(0xFFC9BBFF),
    200: Color(_purpleAccentValue),
    400: Color(0xFF7755FF),
    700: Color(0xFF633BFF),
  });
  static const int _purpleAccentValue = 0xFFA088FF;

  static const MaterialColor lavandalight =
      MaterialColor(_lavandalightPrimaryValue, <int, Color>{
    50: Color(0xFFFCFBFF),
    100: Color(0xFFF9F5FF),
    200: Color(0xFFF5EEFF),
    300: Color(0xFFF0E7FF),
    400: Color(0xFFEDE2FF),
    500: Color(_lavandalightPrimaryValue),
    600: Color(0xFFE7D9FF),
    700: Color(0xFFE4D4FF),
    800: Color(0xFFE1CFFF),
    900: Color(0xFFDBC7FF),
  });
  static const int _lavandalightPrimaryValue = 0xFFEADDFF;

  static const MaterialColor lavandalightAccent =
      MaterialColor(_lavandalightAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_lavandalightAccentValue),
    400: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
  });
  static const int _lavandalightAccentValue = 0xFFFFFFFF;

  static const MaterialColor graydark =
      MaterialColor(_graydarkPrimaryValue, <int, Color>{
    50: Color(0xFFE6E6E7),
    100: Color(0xFFC2C1C2),
    200: Color(0xFF99979A),
    300: Color(0xFF706D72),
    400: Color(0xFF514E53),
    500: Color(_graydarkPrimaryValue),
    600: Color(0xFF2D2A30),
    700: Color(0xFF262328),
    800: Color(0xFF1F1D22),
    900: Color(0xFF131216),
  });
  static const int _graydarkPrimaryValue = 0xFF322F35;

  static const MaterialColor graydarkAccent =
      MaterialColor(_graydarkAccentValue, <int, Color>{
    100: Color(0xFF955CFF),
    200: Color(_graydarkAccentValue),
    400: Color(0xFF5200F6),
    700: Color(0xFF4900DC),
  });
  static const int _graydarkAccentValue = 0xFF7429FF;
}
