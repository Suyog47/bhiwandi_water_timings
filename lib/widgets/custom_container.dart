import 'package:bhiwandi_water_timings/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({Key? key, required this.child,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          border: Border.all(color: greyColor, width: 2.0),
          borderRadius: BorderRadius.circular(5)),
      child: Center(child: child),
    );
  }
}
