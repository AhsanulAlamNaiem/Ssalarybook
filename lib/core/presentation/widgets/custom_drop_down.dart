
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomDropDown extends StatefulWidget{
  String label;
  List<String> items;
  Function updater;
  bool isLoading;
  CustomDropDown({required this.label,required this.items,required this.updater,this.isLoading=false});

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<CustomDropDown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5), // Rounded corners
          border: Border.all(
              color: AppColors.fontColorGray, width: 1), // Border styling
        ),
        child: widget.items==[]? CircularProgressIndicator():
        DropdownButton<String>(
          value: selectedItem,
          // style: AppStyles.textH2,
          hint: widget.isLoading?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select ${widget.label}"),
              SizedBox(height: 10,width: 10,child: CircularProgressIndicator(color: AppColors.fontColorGray,))],):
          Text("Select ${widget.label}"),
          items: widget.items.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
              widget.updater(newValue);
            });
          },
        ));
  }
}