import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppWidgets{
  static Widget progressIndicator = ElevatedButton(
    style: AppStyles.elevatedButtonStyleFullWidth,
    onPressed: () {},
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  static Widget tableLoadingIndicator = Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Container( decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: BorderRadius.circular(0),
        ),
          height: 30,
          width: double.infinity,),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColor, width: 1),
            borderRadius: BorderRadius.circular(0),
          ),
          width: double.infinity,
          height: 50,
          child: SizedBox( height: 25,width: 25, child:  Text("Fetching data ...")),
        ),
      ],
    ),
  );
}
