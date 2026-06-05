import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';

class TopUpDetailsScreen extends StatelessWidget {
  const TopUpDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: ColorResources.blueeebutton,
            child: Text(
              "My Ride",
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ),
        ),
        title: Text(
          "Top Up Details",
          style: PoppinsMedium.copyWith(color: ColorResources.blackcolor11),
        ),
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: ColorResources.blackcolor),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Column(
          children: [
            /// Top Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: height * 0.04,
                horizontal: width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  /// Circle + Icon
                  Container(
                    width: width * 0.18,
                    height: width * 0.18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorResources.TextColorForGrey),
                    ),
                    child:  Icon(Icons.add, color: ColorResources.blueeebutton, size: 30),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Amount
                   Text(
                    "₹ 489",
                   style:  PoppinsMedium.copyWith(
                    color: ColorResources.blackcolor11,
                  ),
                  ),

                  SizedBox(height: height * 0.01),

                   Text(
                    "MyRide Wallet",
                    style:  PoppinsSemiBold.copyWith(
                    color: ColorResources.blackcolor11,
                  ),
                  ),

                  SizedBox(height: height * 0.005),

                   Text(
                    "From Mastercard (... 4682)",
                    style:   PoppinsReguler.copyWith(
                    color: ColorResources.TextColorForGrey,
                  ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.025),

            /// Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: height * 0.025,
                horizontal: width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _detailRow("Status", "Completed", isStatus: true),
                  _detailRow("Payment", "MyRide Wallet"),
                  _detailRow("Date", "Mar 21, 2026"),
                  _detailRow("Time", "16:00 PM"),
                  _detailRow(
                    "Transaction ID",
                    "TRX12222240941",
                    showCopy: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.04),

            /// Share Receipt Button
            Container(
              width: double.infinity,
              height: height * 0.065,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: ColorResources.blueeebutton),
              ),
              child:  Center(
                child: Text(
                  "Share Receipt",
                  style: 
                  PoppinsReguler.copyWith(
                    color: ColorResources.blueeebutton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _detailRow(
    String title,
    String value, {
    bool isStatus = false,
    bool showCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isStatus
                    ? Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                         // color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ColorResources.blueeebutton),
                        ),
                        child:  Text(
                          "Completed",
                          style:  PoppinsReguler.copyWith(
                    color: ColorResources.blueeebutton,
                  ),
                          // TextStyle(color: ColorResources.blueeebutton, fontSize: 12),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                if (showCopy) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.copy, size: 16, color: Colors.grey),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
