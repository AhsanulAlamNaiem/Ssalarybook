import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/constants/appResources.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

PreferredSize homeScreenAppBar({required User user, List<Widget>? action = null , Widget? leading = null}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(260), // Adjust the height as needed
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), // Bottom left corner rounded
            bottomRight: Radius.circular(15), // Bottom right corner rounded
          ),
          child: Column( children: [AppBar(
            iconTheme: const IconThemeData(color:Colors.white),
            backgroundColor: AppColors.mainColor,
            centerTitle: true,
            leading: leading,
            actions: action,
          ),
            Container(
                height:200,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.mainColor),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: 130, // Diameter = 2 * radius
                          height: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/user.png"),
                              fit: BoxFit.fitHeight, // Ensures the image fits properly
                            ),)),
                      Text(user.name, style: AppStyles.textOnMainColorheading,),
                      Text(user.designation, style: AppStyles.textH3w,),
                      SizedBox(height: 20,)
                    ]
                ))
          ]
          )
      )
  );
}
