import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class LeadDetailsPage extends StatelessWidget {
  const LeadDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Lead Details",
          style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEAD CARD
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 222, 239, 249),
                    Color.fromARGB(255, 243, 213, 226),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Santosh Kumar",
                            style: opensansSemiBold.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "ID: #786 2548",
                            style: opensansSemiBold.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Pending",
                          style: opensansSemiBold.copyWith(
                            color: Colors.red,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _infoRow("Email ID", "santosh@gmail.com"),
                  _infoRow("Mobile No.", "+91-9873985748"),
                  _infoRow("Created Date", "June 12, 2025"),
                  _infoRow(
                    "Address",
                    "6th Floor, Bihar State Building Construction Corporation Campus, Noida Road, Gandhi Nagar, Patna - 800010.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// FOLLOW UP HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Follow Up:",
                  style: opensansSemiBold.copyWith(fontSize: 16),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Add Follow Up",
                      style: opensansSemiBold.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// FOLLOW UP CARDS
            followUpCard(
              remark:
                  "He give me time for call him tomorrow. i will call him for next updated.",
              date: "June 12, 2025",
              status: "Pending",
              statusColor: Colors.red,
            ),

            followUpCard(
              remark:
                  "Today we had a positive one-hour conversation on the phone about our services. he will pay tomorrow.",
              date: "June 12, 2025",
              status: "In process",
              statusColor: Colors.blue,
            ),

            followUpCard(
              remark: "Client finalized and paid amount of Rs. 5999",
              date: "June 12, 2025",
              status: "In process",
              statusColor: Colors.blue,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// BOTTOM BUTTON
      bottomSheet: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),

          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC1326D),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Convert To Member",
                style: opensansSemiBold.copyWith(
                  fontSize: 16,

                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// INFO ROW
  Widget _infoRow(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                title,
                style: opensansSemiBold.copyWith(color: Colors.black87),
              ),
            ),
            Text(":  "),
            Expanded(
              child: Text(
                value,
                style: opensansSemiBold.copyWith(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FOLLOW UP CARD
  Widget followUpCard({
    required String remark,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 218, 231, 245),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Remarks:", style: opensansSemiBold.copyWith()),
          const SizedBox(height: 4),
          Text(
            remark,
            style: opensansSemiBold.copyWith(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/calender_svgrepo.com.png',
                    height: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(date, style: opensansSemiBold.copyWith(fontSize: 11)),
                ],
              ),
              Text(
                status,
                style: opensansSemiBold.copyWith(color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
