import 'package:get/get.dart';

class Navigate {

  void toDashboard([Map? data]) {
    Get.toNamed('/dashboard');
  }

  void toFeedback([Map? data]) {
    Get.toNamed('/feedback');
  }
}
