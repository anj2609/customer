import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Choose Payment Method",
         style: PoppinsBold.copyWith(
                        color: ColorResources.blackcolor,
                      ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),

              /// Profile Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: height * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    /// Avatar
                    CircleAvatar(
                      radius: width * 0.12,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/150?img=3",
                        //  "https://i.pravatar.cc/300",
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Troska Sangam",
                      style: PoppinsReguler.copyWith(
                        color: ColorResources.blackcolor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "+91 987 654 3210",
                          style: PoppinsReguler.copyWith(
                            color: ColorResources.TextColorForGrey,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.copy,
                          size: 16,
                          color: ColorResources.TextColorForGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              /// Stats Card
              Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _StatItem(Icons.star_border, "4.8", "Rating"),
                    _StatItem(Icons.directions_car, "9,205", "Ride orders"),
                    _StatItem(Icons.access_time, "4.8", "Years"),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              /// Info Card
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    _InfoRow("Member Since", "Dec 20, 2023"),
                    SizedBox(height: 12),
                    _InfoRow("Car Model", "Tata Tigor"),
                    SizedBox(height: 12),
                    _InfoRow("Color", "White"),
                    SizedBox(height: 12),
                    _InfoRow("Plate Number", "TR 05 CB 2446"),
                  ],
                ),
              ),

              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),

      /// Bottom Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Row(
          children: [
            /// Call Button
            Expanded(
              child: CustomIconsButton(
                text: "Call",
                icons: Icons.phone,
                colors: ColorResources.buttonColors,
                onTap: () {},
              ),
            ),

            const SizedBox(width: Dimensions.spacingSize12),

            Expanded(
              child: CustomMessageButton(
                text: "Chat",
                icons: Icons.message,
                colors: ColorResources.blueeebutton,
                onTap: () {
                 Get.toNamed(RouteHelper.getchatScreenScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat Item Widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: PoppinsBold.copyWith(color: ColorResources.blackcolor),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: PoppinsReguler.copyWith(
            color: ColorResources.TextColorForGrey,
          ),
        ),
        Text(
          value,
          style: PoppinsReguler.copyWith(
            color: ColorResources.TextColorForGrey,
          ),
        ),
      ],
    );
  }
}
