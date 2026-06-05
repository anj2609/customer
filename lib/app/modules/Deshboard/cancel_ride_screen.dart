import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class CancelRideScreen extends StatefulWidget {
  final dynamic bookingId;

  const CancelRideScreen({super.key, required this.bookingId});

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  int? selected;

  @override
  void initState() {
    super.initState();
    print('Booking Id ${widget.bookingId}');
    Get.find<BookingController>().cancelationListApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorResources.blackcolor),
          onPressed: () => Get.back(),
        ),
        title: Text("Cancel Ride", style: PoppinsBold.copyWith()),
      ),

      body: Column(
        children: [
          SizedBox(height: height * 0.02),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Why are you cancelling?",
                style: PoppinsReguler.copyWith(),
              ),
            ),
          ),

          SizedBox(height: height * 0.02),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: GetBuilder<BookingController>(
                builder: (controller) {
                  if (controller.cancelationList.isEmpty) {
                    return Center(child: PremiumBlurLoader());
                  }

                  return ListView.builder(
                    itemCount: controller.cancelationList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selected,
                              activeColor: const Color(0xFF1FA2C3),
                              onChanged: (value) {
                                setState(() {
                                  selected = value;
                                });
                              },
                            ),

                            Expanded(
                              child: Text(
                                controller.cancelationList[index].name ?? "",
                                style: PoppinsReguler.copyWith(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),

      /// Fixed Bottom Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: CustomPrimaryDyanamicButton(
            text: "Confirm",
            onTap: () {
              /// Validation
              if (selected == null) {
                Get.snackbar(
                  "Alert",
                  "Please select cancellation reason",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              try {
                 showDialog(
                      context:Get.context!,
                      barrierDismissible: false,
                      builder: (_) => PremiumBlurLoader(),
                    );
                Get.find<BookingController>().cancelRideApi(
                  context: context,
                  bookingid: widget.bookingId,

                  reseonId: Get.find<BookingController>()
                      .cancelationList[selected!]
                      .id,
                );
              } catch (e) {
                debugPrint('ride cancle Error: $e');
              } finally {
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
              }

              // Get.find<BookingController>().cancelRideApi(
              //   context: context,
              //   bookingid: widget.bookingId,

              //   /// index send karne ki jagah reason id bhejo
              //   reseonId: Get.find<BookingController>()
              //       .cancelationList[selected!]
              //       .id,
              // );
            },
          ),
        ),
      ),
    );
  }
}
