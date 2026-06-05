import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

class OngoingScreen extends StatelessWidget {
  const OngoingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (controller.bookingActivityList == null ||
            controller.bookingActivityList!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/notdatafound.png", height: 150),
                const SizedBox(height: 10),
                Text(
                  "No Ongoing Rides",
                  style: PoppinsSemiBold.copyWith(
                    color: ColorResources.blackcolor,
                  ),
                ),
              ],
            ),
          );
        }

        final data = controller.bookingActivityList!.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              /// TOP INFO
              Row(
                children: [
                  (data.vehicleType!.image != null &&
                          data.vehicleType!.image!.isNotEmpty)
                      ? CircleAvatar(
                          radius: width * 0.09,
                          backgroundColor: ColorResources.whiteColor,
                          child: ClipOval(
                            child: Image.network(
                              '${ApiConstants.imageurl}${data.vehicleType!.image.toString()}',
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

                  // Container(
                  //   padding: EdgeInsets.all(12),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(
                  //       color: ColorResources.TextColorForGrey,
                  //     ),
                  //   ),
                  //   child: Icon(
                  //     Icons.directions_car,
                  //     color: ColorResources.blueeebutton,
                  //   ),
                  // ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.dropAddress ?? "Larchmont Hotel",
                          style: PoppinsReguler.copyWith(
                            color: ColorResources.blackcolor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatDate(data.createdAt.toString()),
                          //data.createdAt ?? "",
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
                        "₹ ${data.totalFare ?? 0}",
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
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(data.pickupAddress ?? "Pickup Location"),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(data.dropAddress ?? "Drop Location"),
                        ),
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
      },
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
