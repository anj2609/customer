import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class DriverRatingScreen extends StatefulWidget {
  final String bookingid;
  final String drivername;
  final String details;
  final String estimatetime;
  final String distance;
  final String distancekillo;
  final String basefare;
  final String discount;
  final String total;
  final String profile;

  DriverRatingScreen({
    super.key,
    required this.bookingid,
    required this.drivername,
    required this.details,
    required this.estimatetime,
    required this.distance,
    required this.distancekillo,
    required this.basefare,
    required this.discount,
    required this.total,
    required this.profile,
  });

  @override
  State<DriverRatingScreen> createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  int selectedRating = 0;

  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = index;
        });
      },
      child: Icon(
        Icons.star,
        size: 40,
        color: index <= selectedRating ? Colors.amber : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// CLOSE ICON
                Row(children: const [Icon(Icons.close)]),

                SizedBox(height: 10),

                /// DRIVER IMAGE
                widget.profile.isNotEmpty
                    ? CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          "${ApiConstants.imageurl}${widget.profile}",
                        ),
                        // NetworkImage(
                        //   "https://i.pravatar.cc/150?img=12",
                        // ),
                      )
                    : CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=12",
                        ),
                      ),

                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "How was the driver?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Help MyRide do better by rating this trip",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// ⭐ RATING STARS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => buildStar(index + 1)),
                ),

                const SizedBox(height: 20),

                /// INFO CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [Text("Ride"), Text("Economy (Non-AC)")],
                      // ),
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Payment"), Text("MyRide Wallet")],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// FARE SUMMARY
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Trip Fare"),
                          Text("₹ ${widget.basefare}"),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount (20%)"),
                          Text("- ₹ ${widget.discount}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Paid",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹ ${widget.total}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // const SizedBox(height: 10),

                // const Text(
                //   "Hide details",
                //   style: TextStyle(color: Colors.blue),
                // ),

                // const SizedBox(height: 18),

                /// GIVE RATE BUTTON
                ///
                ///
                CustomPrimaryButton(
                  text: "Give Rate",
                  onTap: () async {
                    if (selectedRating == 0) {
                      Get.snackbar(
                        "Rating Required",
                        "Please select a rating before continuing",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    print(
                      "Rating Given: ${widget.bookingid} ${selectedRating}",
                    );

                    try {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (_) => PremiumBlurLoader(),
                      );
                      await Get.find<BookingController>().rateForDriver(
                        context: context,
                        bookingid: widget.bookingid,
                        rateId: selectedRating,
                      );
                    } catch (e) {
                      debugPrint('rating Error: $e');
                    } finally {
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                    }

                    //       // Get.to(
                    //       //   const TipScreen(),
                    //       //   transition: Transition.leftToRight,
                    //       //   duration: const Duration(milliseconds: 300),
                    //       // );
                    //       // Get.to(
                    //       //   Get.to(TipScreen()),
                    //       //   transition: Transition.leftToRight,
                    //       //   duration: Duration(milliseconds: 0),
                    //       // );
                  },
                ),

                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       if (selectedRating == 0) {
                //         Get.snackbar(
                //           "Rating Required",
                //           "Please select a rating before continuing",
                //           snackPosition: SnackPosition.BOTTOM,
                //           backgroundColor: Colors.red,
                //           colorText: Colors.white,
                //         );
                //         return;
                //       }

                //       print("Rating Given: $selectedRating");
                //        Get.find<BookingController>().rateForDriver(
                //     context: context,
                //     bookingid: widget.bookingid,
                //     rateId:selectedRating,
                //   );

                //       // Get.to(
                //       //   const TipScreen(),
                //       //   transition: Transition.leftToRight,
                //       //   duration: const Duration(milliseconds: 300),
                //       // );
                //       // Get.to(
                //       //   Get.to(TipScreen()),
                //       //   transition: Transition.leftToRight,
                //       //   duration: Duration(milliseconds: 0),
                //       // );
                //     },

                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xff19A7CE),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //     ),
                //     child: const Text(
                //       "Give Rate",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
