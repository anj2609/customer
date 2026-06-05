

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorResources.whiteColor,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        actions: [Icon(Icons.more_vert, color: ColorResources.blackcolor)],
        title: Text(
          "Ride Details",

          style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11),
        ),
        //flexibleSpace:
        elevation: 0,
        backgroundColor: ColorResources.whiteColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 15),

              /// 🔹 MAIN CARD
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Center(
                      child: Text(
                        "Your Scheduled Ride",
                        style: PoppinsSemiBold.copyWith(
                          color: ColorResources.blackcolor11,
                        ),
                        //  TextStyle(
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w600,
                        // ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Center(
                      child: Text(
                        "Monday, Mar 21 - 16:00 PM",
                        style: PoppinsMedium.copyWith(
                          color: ColorResources.TextColorForGrey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // /// 🔹 BLUE INFO BAR
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child:  Row(
                    //     children: [
                    //       Icon(Icons.info, color: Colors.white, size: 18),
                    //       SizedBox(width: 8),
                    //       Expanded(
                    //         child: Text(
                    //           "We'll notify you when a driver's found",
                    //           style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 15),

                    /// 🔹 CAB DETAIL BOX
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/cab.png", height: 40),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Cab Economy (Non-AC)\n3-5 mins  •  4 passengers",
                              style: PoppinsReguler.copyWith(
                                color: ColorResources.blackcolor11,
                              ),
                            ),
                          ),

                          Text(
                            "₹ 448",
                            style: PoppinsSemiBold.copyWith(
                              color: ColorResources.blackcolor11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 ROUTE BOX
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Bobst Library",
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Larchmont Hotel",

                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 DETAILS CARD
                    _infoRow("Status", "Scheduled", isBadge: true),
                    _infoRow("Payment", "MyRide Wallet"),
                    _infoRow("Date", "Mar 21, 2026"),
                    _infoRow("Time", "16:00 PM"),
                    _infoRow("Transaction ID", "TRX12222240941"),
                    _infoRow("Booking ID", "BKG720469"),

                    const SizedBox(height: 15),

                    /// 🔹 FARE SUMMARY
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        children: [
                          _FareRow("Trip Fair", "₹ 560"),
                          Divider(),
                          _FareRow("Discount (25%)", "₹ 112"),
                          Divider(),
                          _FareRow("Total Paid", "₹ 448", bold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 SHARE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showDriverFoundSheet(context);
                        },
                        child: const Text(
                          "Share Receipt",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 CANCEL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Cancel Ride",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDriverFoundSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            /// MAIN CONTAINER
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "We’ve found the driver!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 15),

                  /// DRIVER ROW
                  Row(
                    children: [
                      /// DRIVER IMAGE
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// DRIVER DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Troska Sangam  ⭐ 4.8",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Tata Tigor, White  ·  TR 05 CB 2446",
                              style: PoppinsReguler.copyWith(
                                color: ColorResources.TextColorForGrey,
                              ),
                              //  TextStyle(
                              //   color: Colors.grey,
                              //   fontSize: 12,
                              // ),
                            ),
                          ],
                        ),
                      ),

                      /// CHAT BUTTON
                      Container(
                        height: 45,
                        width: 45,
                        decoration:  BoxDecoration(
                          color:ColorResources.blueeebutton,
                          shape: BoxShape.circle,
                        ),
                        child:Image.asset("assets/images/circle.png")
                        //  const Icon(
                        //   Icons.chat_bubble_outline,
                        //   color: Colors.white,
                        // ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  CustomPrimaryButton(
                    text: "Share Receipt",
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OtpScreen(type: "Sign in"),
                      //   ),
                      // );
                    },
                  ),

                  /// SHARE BUTTON
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 55,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.blue,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //     ),
                  //     onPressed: () {},
                  //     child:  Text(
                  //       "Share Receipt",
                  //       style:PoppinsSemiBold.copyWith(
                  //   color: ColorResources.whiteColor,
                  // ),
                  //       // TextStyle(fontSize: 16),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            /// TOP FLOATING ICON
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: ColorResources.blueeebutton,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/images/useraccount.png"),

              /// Icon(Icons.person, color: Colors.white, size: 55),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 INFO ROW
  Widget _infoRow(String title, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          isBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String title;
  final String price;
  final bool bold;

  const _FareRow(this.title, this.price, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Text(
          price,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
