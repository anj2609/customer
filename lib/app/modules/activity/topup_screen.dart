import 'package:evfual/app/modules/activity/topupdetail_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.whiteColor,

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        itemCount: 8,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(
                TopUpDetailsScreen(),
                transition: Transition.leftToRight,
                duration: Duration(milliseconds: 0),
              );
              //  Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => const TopUpDetailsScreen(),
              //       ),
              //     );
            },
            child: _topUpTile(width),
          );
        },
      ),
    );
  }

  static Widget _topUpTile(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          /// Circle Plus Icon
          Container(
            width: width * 0.13,
            height: width * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(Icons.add, color: ColorResources.blueeebutton),
          ),

          const SizedBox(width: 14),

          /// Left Side Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Top Up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  "Dec 20, 2025 · 08:49 AM",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// Right Side Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                "₹ 489",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                "Mastercard",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
