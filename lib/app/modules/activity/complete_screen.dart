import 'package:evfual/app/modules/activity/ridedetail_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/data/controller/complete_controller.dart';
import 'package:evfual/data/modal/complete_model.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompleteController());
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        child: Obx(
          () => ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 20,
            ),
            itemCount: controller.completedList.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade200, thickness: 1),
            itemBuilder: (context, index) {
              final item = controller.completedList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    RideDetailsScreen(),
                    transition: Transition.leftToRight,
                    duration: Duration(milliseconds: 0),
                  );
                },

                child: CompleteCard(item: item),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CompleteCard extends StatelessWidget {
  final CompleteModel item;

  const CompleteCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          /// Left Circular Icon
          Container(
            width: width * 0.13,
            height: width * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorResources.TextColorForGrey, width: 1),
            ),
            child: Center(
              child:
                  // Text('data')
                  Image.asset(
                    item.icon,
                    height: 15,
                    //size: 22,
                    //  color: const Color(0xFF4A90E2), // soft blue
                  ),
            ),
          ),

          const SizedBox(width: 14),

          /// Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: PoppinsSemiBold.copyWith(
                    color: ColorResources.blackcolor11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.date,

                  style: PoppinsReguler.copyWith(
                    color: ColorResources.TextColorForGrey,
                  ),
                  // TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          /// Amount + Payment Method
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: PoppinsSemiBold.copyWith(
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.method,
                style: PoppinsReguler.copyWith(
                  color: ColorResources.TextColorForGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
