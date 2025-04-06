import 'package:beton_book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  // Text Styles
  static const TextStyle textOnMainColorheading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorOnMainColor,
  );

  static const TextStyle textH1 = TextStyle(
      fontSize: 18.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH2 = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH2w = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH3 = TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textH3w = TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textH4 = TextStyle(
      fontSize: 12.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle bodyText = TextStyle(
      fontSize: 11.0,
      color: Colors.black,
      fontWeight: FontWeight.normal
  );

  static const TextStyle bodyTextgray = TextStyle(
      fontSize: 11.0,
      color: AppColors.fontColorGray,
      fontWeight: FontWeight.normal
  );

  static const TextStyle bodyTextBold = TextStyle(
      fontSize: 11.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColorOnMainColor,
  );

  static ButtonStyle  textButtonWhite = TextButton.styleFrom(
      textStyle: textH4
  );

  // Button Styles
  static ButtonStyle elevatedButtonStyleFullWidth = ElevatedButton.styleFrom(
    backgroundColor: AppColors.mainColor,
    textStyle: buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ).copyWith(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)), // Set minimum width to full screen width
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.mainColor,
    textStyle: buttonText,
  );


  static ButtonStyle homePageBUttonStyle = ElevatedButton.styleFrom(
    textStyle: buttonText,
    backgroundColor: Colors.white, // Button background color
    shadowColor: Colors.grey.withOpacity(0.4), // Light ash shadow
    elevation: 6, // Shadow elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ).copyWith(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 80)), // Set minimum width to full screen width
  );




  static  ButtonStyle textButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(0)),
  );

}
