import 'package:bhiwandi_water_timings/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  void alert(String msg, BuildContext context, {Color color = greenColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(
          msg,
          style: const TextStyle(
              fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
