import 'package:bhiwandi_water_timings/constants/colors.dart';
import 'package:bhiwandi_water_timings/controllers/data_controller.dart';
import 'package:bhiwandi_water_timings/screens/dashboard.dart';
import 'package:bhiwandi_water_timings/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DataController _dataController = Get.put(DataController());

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  Future getAllData() async {
   await _dataController.getAllData();
   if(_dataController.response == 'success'){
     Future.delayed(const Duration(seconds: 1), () {
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(

           builder: (context) => const Dashboard(),
         ),
       );
     });
   }
   else{
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Oops...something went wrong, please try again later'),
       ),
     );
   }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: themeBlueColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              "Bhiwandi  Water \nTimings",
              style: TextStyle(
                  color: whiteColor, fontWeight: FontWeight.bold, fontSize: 35),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: CircularLoader(
              bgContainer: false,
              color: whiteColor,
            ),
          )
        ],
      ),
    );
  }
}
