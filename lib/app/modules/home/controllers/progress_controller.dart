import 'package:get/get.dart';

class ProgressController extends GetxController {
  RxDouble progressValue = 0.0.obs;
  RxString message = 'Loading'.obs;
  RxBool inProgress = false.obs;

  void showProgress(String title, double value) {
    progressValue.value = value;
    message.value = title;
    inProgress.value = true;
    if (value >= 1) {
      inProgress.value = false;
    }
  }
}
