import 'package:evfual/data/modal/activitt_model.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  var selectedTab = 2.obs; // 0 = Scheduled, 1 = Completed, 2 = Cancelled

  var activityList = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void loadData() {
    activityList.value = [
      ActivityModel(
        title: "Madison Square...",
        date: "Dec 20, 2025 · 08:49 AM",
        status: "Canceled & Refunded",
        amount: "₹ 489",
        icon: "car",
      ),
      ActivityModel(
        title: "Hudson River Pd...",
        date: "Dec 17, 2025 · 03:42 PM",
        status: "Canceled & Refunded",
        amount: "₹ 665",
        icon: "bike",
      ),
      ActivityModel(
        title: "The Altman Buil...",
        date: "Dec 15, 2025 · 08:59 PM",
        status: "Canceled & Refunded",
        amount: "₹ 324",
        icon: "bike",
      ),
      ActivityModel(
        title: "Chelsea Market",
        date: "Dec 12, 2025 · 02:25 PM",
        status: "Canceled & Refunded",
        amount: "₹ 586",
        icon: "car",
      ),
    ];
  }
}