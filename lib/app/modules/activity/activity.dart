import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myrideuser/app/modules/activity/canceled_screen.dart';
import 'package:myrideuser/app/modules/activity/complete_screen.dart';
import 'package:myrideuser/app/modules/activity/ongoing_screen.dart';
import 'package:myrideuser/app/modules/activity/scheduled_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
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
                    style: PoppinsMedium.copyWith(
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                  const Spacer(),
                  //const Icon(Icons.more_vert),
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
                          slug = "pending";
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

class RideItem extends StatelessWidget {
  final String title;
  final String subTitle;
  //  final String time;
  // final String rightDate;
  final String imageUrl;

  const RideItem({
    super.key,
    required this.title,
    required this.subTitle,

    required this.imageUrl,
    
  });

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            /// LEFT CIRCLE ICON
          (imageUrl != null &&imageUrl!.isNotEmpty)
              ? CircleAvatar(
                  radius: width * 0.09,
                  backgroundColor: ColorResources.whiteColor,
                  child: ClipOval(
                    child: Image.network(
                      '${ApiConstants.imageurl}${imageUrl.toString()}',
                      width: width * 0.16,
                      height: width * 0.16,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/cars.png",
                          width: width * 0.14,
                          height: width * 0.14,
                          fit: BoxFit.cover,
                          color: ColorResources.blueeebutton,
                        );
                      },
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: width * 0.06,
                  backgroundColor: Colors.blue.shade50,
                  child: Image.asset(
                    "assets/images/cars.png",
                    width: width * 0.08,
                    height: width * 0.08,
                    fit: BoxFit.cover,
                    color: ColorResources.blueeebutton,
                  ),
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
                    style: PoppinsReguler.copyWith(
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  // Text(
                  //   subTitle,
                  //   style: TextStyle(
                  //     color: ColorResources.TextColorForGrey,
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),

            /// RIGHT SIDE TIME + DATE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text(
                //   time,
                //   style: PoppinsMedium.copyWith(
                //     color: ColorResources.blackcolor11,
                //   ),
                // ),
                const SizedBox(height: 6),
                Text(
                  formatDate(subTitle),
                  // rightDate,
                  style: TextStyle(
                    color: ColorResources.TextColorForGrey,
                    fontSize: 12,
                  ),
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

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    // 2026-04-27
    String fullDate = DateFormat('yyyy-MM-dd').format(dateTime);

    // 27 April
    String dayMonth = DateFormat('dd MMMM').format(dateTime);

    return "$fullDate  $dayMonth";
  }
}
