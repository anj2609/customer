
import 'package:evfual/app/modules/activity/activity.dart';
import 'package:evfual/app/modules/activity/ridedetail_screen.dart';
import 'package:flutter/material.dart';

class ScheduledScreen extends StatelessWidget {
  const ScheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RideDetailsScreen()),
        );
       
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          RideItem(
            title: "Larchmont Hotel",
            icon: Icons.directions_car,
            time: "16:00 PM",
            subTitle: "Today, Mar 20, 2026  ·  09:41 AM",
            rightDate: "Mar 21",
          ),

          RideItem(
            title: "Strand Book Store",
            icon: Icons.two_wheeler,
            time: "10:30 AM",
            subTitle: "Mar 18, 2026  ·  11:02 AM",
            rightDate: "Mar 19",
          ),

          RideItem(
            title: "Angelika Film Center &...",
            icon: Icons.two_wheeler,
            time: "19:00 PM",
            subTitle: "Feb 21, 2026  ·  10:00 AM",
            rightDate: "Feb 28",
          ),

          RideItem(
            title: "Beacon,s Closet",
            icon: Icons.directions_car,
            time: "14:30 PM",
            subTitle: "Feb 16, 2026  ·  13:45 PM",
            rightDate: "Feb 18",
          ),
        ],
      ),
    );
  }
}



