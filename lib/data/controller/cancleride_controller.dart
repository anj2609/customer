import 'package:get/get.dart';

class CancelRideController extends GetxController {
  var selectedReason = 0.obs;

  final List<String> reasons = [
    "Change in plans",
    "Waiting for long time",
    "Unable to contact driver",
    "Driver denied to go to destination",
    "Driver denied to come to pickup",
    "Wrong address shown",
    "The price is not reasonable",
    "Emergency situation",
    "Booking mistake",
    "Poor weather conditions",
    "Other",
  ];

  void selectReason(int index) {
    selectedReason.value = index;
  }
}