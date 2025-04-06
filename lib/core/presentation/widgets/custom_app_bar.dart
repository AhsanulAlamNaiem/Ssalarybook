import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

PreferredSize customAppBar({required String title, List<Widget>? action = null , Widget? leading = null}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(50), // Adjust the height as needed
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), // Bottom left corner rounded
            bottomRight: Radius.circular(15), // Bottom right corner rounded
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color:Colors.white),
            backgroundColor: AppColors.mainColor,
            title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(height: 20,),
                  Text(title, style: AppStyles.textOnMainColorheading,)
                ]
            ),
            centerTitle: true,
            leading: leading,
            actions: action,
          )));
}
