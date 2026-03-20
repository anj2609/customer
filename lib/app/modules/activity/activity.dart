import 'package:evfual/app/modules/Deshboard/deshboard.dart';
import 'package:evfual/app/modules/activity/canceled_screen.dart';
import 'package:evfual/app/modules/activity/complete_screen.dart';
import 'package:evfual/app/modules/activity/ongoing_screen.dart';
import 'package:evfual/app/modules/activity/scheduled_screen.dart';
import 'package:evfual/app/modules/activity/topup_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    "Ongoing",
    "Scheduled",
    "Completed",
    "Canceled",
    "Top Up",
  ];

  //

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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: ColorResources.blueeebutton,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/splashscreen.png'),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                   Text(
                    "Activity",
                    style: PoppinsMedium.copyWith(color: ColorResources.blackcolor11),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert),
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
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: 
                        isSelected
                            ? ColorResources.blueeebutton
                            : ColorResources.whiteColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: ColorResources.TextColorForGrey),
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

            /// ✅ TAB BODY SWITCH
            Expanded(
              child: Builder(
                builder: (context) {
                  if (selectedTab == 0) {
                    return OngoingScreen();
                  } else if (selectedTab == 1) {
                    return ScheduledScreen();
                  } else if (selectedTab == 2) {
                    return CompletedScreen();
                  } else if (selectedTab == 3) {
                    return CanceledScreen();
                  } else {
                    return TopUpScreen();
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

class RideItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final String rightDate;
  final IconData icon;

  const RideItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.time,
    required this.rightDate,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            /// LEFT CIRCLE ICON
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(icon, color: ColorResources.blueeebutton),
            ),

            const SizedBox(width: 12),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: PoppinsReguler.copyWith(color: ColorResources.blackcolor11),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    style:  TextStyle(color: ColorResources.TextColorForGrey, fontSize: 12),
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE TIME + DATE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: PoppinsMedium.copyWith(color: ColorResources.blackcolor11),
                ),
                const SizedBox(height: 6),
                Text(
                  rightDate,
                  style:  TextStyle(color: ColorResources.TextColorForGrey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        Divider(color: ColorResources.TextColorForGrey),
      ],
    );
  }
}
