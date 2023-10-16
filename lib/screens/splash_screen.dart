import 'package:BWT/constants/colors.dart';
import 'package:BWT/controllers/data_controller.dart';
import 'package:BWT/controllers/internet_controller.dart';
import 'package:BWT/screens/internet_connectivity_screen.dart';
import 'package:BWT/utils/navigations.dart';
import 'package:BWT/utils/shared_preference_data.dart';
import 'package:BWT/utils/snackbars.dart';
import 'package:BWT/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DataController _dataController = Get.put(DataController());
  final InternetController _internetController = Get.put(InternetController());

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  Future getAllData() async {
    await _internetController.checkInternet();
    if(_internetController.isInternetActive.value) {
      _dataController.selectedArea = await SharedPreferenceData().getData();
      await _dataController.getAllData();

      if (_dataController.response == 'success') {
        Future.delayed(const Duration(seconds: 1), () {
          Navigate().toDashboard(context);
        });
      } else {
        CustomSnackBar().alert(
            "Oops...something went wrong, Load the app again", context,
            color: redColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const InternetCheck(
      child: Scaffold(
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
      ),
    );
  }
}
