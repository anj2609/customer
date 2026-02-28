
import 'package:evfual/data/modal/complete_model.dart';
import 'package:get/get.dart';


class CompleteController extends GetxController {
  var completedList = <CompleteModel>[].obs;

  @override
  void onInit() {
    fetchCompletedData();
    super.onInit();
  }

  void fetchCompletedData() {
    completedList.value = [
      CompleteModel(
        icon:"assets/images/cardire.png",
        title: "Jefferson Market Libr...",
        date: "Nov 30, 2025 · 09:41 AM",
        amount: "₹ 489",
        method: "MyRide Wallet",
      ),
      CompleteModel(
         icon:"assets/images/motor.png",
        title: "Cinema Village",
        date: "Nov 29, 2025 · 11:36 AM",
        amount: "₹ 665",
        method: "Cash",
      ),
      CompleteModel(
        icon:"assets/images/cardire.png",
        title: "New York University",
        date: "Nov 15, 2025 · 06:59 PM",
        amount: "₹ 324",
        method: "Google Pay",
      ),
      CompleteModel(
        icon:"assets/images/motor.png",
        title: "Independent Training...",
        date: "Nov 03, 2025 · 02:25 PM",
        amount: "₹ 586",
        method: "Visa",
      ),
      CompleteModel(
       icon:"assets/images/cardire.png",
        title: "Boqueria Soho",
        date: "Oct 25, 2025 · 10:15 AM",
        amount: "₹ 224",
        method: "Paytm",
      ),
    ];
  }
}

