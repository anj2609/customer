import 'package:get/get.dart';
import 'package:myrideuser/app/modules/activity/canceled_screen.dart';
import 'package:myrideuser/app/modules/activity/complete_screen.dart';
import 'package:myrideuser/app/modules/activity/ongoing_screen.dart';
import 'package:myrideuser/app/modules/activity/scheduled_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["Ongoing", "Scheduled", "Completed", "Canceled"];

  @override
  void initState() {
    super.initState();
    Get.find<ProfileController>().getActivityData(
      context: context,
      typeOfSlug: 'ongoing',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/splashscreen.png',
                      height: 20,
                      color: ColorResources.blueeebutton,
                    ),
                  ),
                  Text(
                    "Activity",
                    style: PoppinsSemiBold.copyWith(
                      fontSize: 16,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ],
              ),
            ),

            /// ✅ TABS
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedTab == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });

                      String slug = "";

                      switch (index) {
                        case 0:
                          // Was "pending" — a different ride state from
                          // "ongoing" everywhere else in this app (track-ride
                          // status values: pending = still finding a driver,
                          // ongoing = ride in progress). initState() above
                          // already correctly fetches this same "Ongoing" tab
                          // with 'ongoing' on first load; tapping the tab
                          // itself was silently switching it to show pending
                          // bookings instead.
                          slug = "ongoing";
                          break;
                        case 1:
                          slug = "scheduled";
                          break;
                        case 2:
                          slug = "completed";
                          break;
                        case 3:
                          slug = "cancelled";
                          break;
                      }

                      Get.find<ProfileController>().getActivityData(
                        context: context,
                        typeOfSlug: slug.toString(),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorResources.blueeebutton
                            : ColorResources.whiteColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: ColorResources.TextColorForGrey,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: PoppinsReguler.copyWith(
                          color: isSelected
                              ? ColorResources.whiteColor
                              : ColorResources.blackcolor,
                        ),
                        // TextStyle(
                        //   color: isSelected ? Colors.white : Colors.black87,
                        // ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (selectedTab == 0) {
                    return OngoingScreen();
                  } else if (selectedTab == 1) {
                    return ScheduledScreen();
                  } else if (selectedTab == 2) {
                    return CompletedScreen();
                  } else {
                    return CanceledScreen();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
