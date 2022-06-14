import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';


ThemeData lightmode = ThemeData(
  primarySwatch:customColor, // تغيير لون الزراير في الابلكيشن
  fontFamily: 'Jannah',
  floatingActionButtonTheme: FloatingActionButtonThemeData(

    backgroundColor: defaultColor,
    foregroundColor: Colors.white24,
  ),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      backwardsCompatibility: false, // للتحكم فال status bar

      systemOverlayStyle: SystemUiOverlayStyle(

          statusBarColor: Colors.black,

          statusBarIconBrightness : Brightness.light

      ),

      backgroundColor: Colors.white,

      elevation: 0.0,

      iconTheme: IconThemeData(

        color: Colors.black,

      ),

      titleTextStyle: TextStyle(
        fontFamily: 'Jannah',

        color: Colors.black,

        fontWeight: FontWeight.w800,

        fontSize: 30.0,



      )

  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(

    type: BottomNavigationBarType.fixed,

    selectedItemColor: defaultColor,

    elevation: 30.0,

  ),

  textTheme: TextTheme(

    bodyText1: TextStyle(

      fontFamily: 'Jannah',

      color: Colors.black,

      fontWeight: FontWeight.w600,

      fontSize: 18.0,

    ),

      subtitle1: TextStyle(
        fontSize:14.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.5,
      )



  ) ,

);

ThemeData darkmode = ThemeData(

  fontFamily: 'Jannah',
  primarySwatch: customColor,
  scaffoldBackgroundColor: HexColor('313739'),

  appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      backwardsCompatibility: false, // للتحكم فال status bar

      systemOverlayStyle: SystemUiOverlayStyle(

          statusBarColor: Colors.black,

          statusBarIconBrightness : Brightness.light

      ),

      backgroundColor: HexColor('313739'),

      elevation: 0.0,

      iconTheme: IconThemeData(

        color: Colors.white,

      ),

      titleTextStyle: TextStyle(
        fontFamily: 'Jannah',

        color: Colors.white,

        fontWeight: FontWeight.bold,

        fontSize: 30.0,



      )

  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(

    type: BottomNavigationBarType.fixed,

    backgroundColor: Colors.black45,

    unselectedItemColor: Colors.grey,

    selectedItemColor: defaultColor,

    elevation: 30.0,

  ),

  textTheme: TextTheme(


    bodyText1: TextStyle(

      color: Colors.white,

      fontWeight: FontWeight.w600,

      fontSize: 18.0,

    ),

    subtitle1: TextStyle(
      fontSize:14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 0.5,
    )



  ) ,


);