import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

HexColor defaultColor = HexColor('0EC5AF');

//*Important*: this is Custom Color for Primary Swatch:
const MaterialColor customColor = MaterialColor(
  customColorValue,
  <int, Color>{
    50: Color(0xFF0ED0B9),
    100: Color(0xFF0ED0B9),
    200: Color(0xFF0ED0B9),
    300: Color(0xFF0ED0B9),
    400: Color(0xFF0ED0B9),
    500: Color(customColorValue),
    600: Color(0xFF0ED0B9),//0ED0B9
    700: Color(0xFF0ED0B9),
    800: Color(0xFF0ED0B9),
    900: Color(0xFF0ED0B9),
  },
);

const int customColorValue = 0xFF0ED0B9;