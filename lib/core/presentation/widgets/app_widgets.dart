import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../constants/global_app_navigator.dart';

class AppWidgets{
  static final  double _screenWidth = MediaQuery.of(GlobalNavigator.navigatorKey.currentContext!).size.width;

  static Widget progressIndicator = ElevatedButton(
    style: AppStyles.elevatedButtonStyleFullWidth,
    onPressed: () {},
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  static Widget tableLoadingIndicator () {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(0.38 * _screenWidth), // Date column width
          1: FixedColumnWidth(0.27 * _screenWidth), // Entry column width
          2: FixedColumnWidth(0.27 * _screenWidth), // Exit column width
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white, width: 2), // Horizontal borders white
          verticalInside: BorderSide(color: Colors.white, width: 2),   // Vertical borders white
          top: BorderSide(color: Colors.white, width: 2),               // Top border
          bottom: BorderSide(color: Colors.white, width: 2),            // Bottom border
        ),
        children: [
          // Table Header
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.mainColor, // Header row color
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Date',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Entry',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Exit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          // Table Rows

          TableRow(
            decoration: BoxDecoration(color: Colors.red.shade100),
            children: [
              TableCell(child: Center(child: Text("Fetching data ... .")),),
              Container(), Container()
            ]),
          TableRow(
              decoration: BoxDecoration(color: Colors.red.shade100),
              children: [
                Container(),Container(), Container()
              ]),
        ],
      ),
    );

  }
}
