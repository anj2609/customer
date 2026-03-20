import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';

class OngoingScreen extends StatelessWidget {
  const OngoingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          /// TOP INFO
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorResources.TextColorForGrey),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: ColorResources.blueeebutton,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Larchmont Hotel",
                      style: PoppinsReguler.copyWith(
                        color: ColorResources.blackcolor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Today, Mar 21 2026  ·  09:41 AM",
                      style: PoppinsSemiBold.copyWith(
                        color: ColorResources.TextColorForGrey,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹ 448",
                    style: PoppinsSemiBold.copyWith(
                      color: ColorResources.blackcolor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "MyRide Wallet",
                    style: PoppinsSemiBold.copyWith(
                      color: ColorResources.blackcolor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// ROUTE BOX
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorResources.TextColorForGrey),
            ),
            child: Column(
              children: const [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text("Bobst Library")),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text("Larchmont Hotel")),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorResources.blueeebutton),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Track Route",
                style: PoppinsSemiBold.copyWith(
                  color: ColorResources.blueeebutton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
