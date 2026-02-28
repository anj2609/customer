import 'package:evfual/app/modules/activity/activity.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/data/controller/canceled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CanceledScreen extends StatefulWidget {
  CanceledScreen({super.key});

  @override
  State<CanceledScreen> createState() => _CanceledScreenState();
}

class _CanceledScreenState extends State<CanceledScreen> {
  final ActivityController controller = Get.put(ActivityController());
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              SizedBox(height: height * 0.02),

              /// Tabs

              /// List
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.activityList.length,
                    itemBuilder: (context, index) {
                      final item = controller.activityList[index];

                      return _activityCard(item, width, height);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityCard(item, double width, double height) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => RideDetailsScreen()),
        // );
      },

      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            /// Icon
            CircleAvatar(
              radius: width * 0.06,
              backgroundColor: Colors.blue.shade50,
              child: Icon(
                item.icon == "car" ? Icons.directions_car : Icons.pedal_bike,
                color: ColorResources.blueeebutton,
              ),
            ),

            SizedBox(width: width * 0.04),

            /// Title & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.date,
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.status,
                    style: TextStyle(fontSize: width * 0.03, color: Colors.red),
                  ),
                ],
              ),
            ),

            /// Amount
            Text(
              item.amount,
              style: TextStyle(
                fontSize: width * 0.038,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
