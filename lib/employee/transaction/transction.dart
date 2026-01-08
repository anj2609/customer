import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/employ_drawer.dart';

class TransactionsScreen extends StatefulWidget {
  final String? hide;
  const TransactionsScreen({super.key, this.hide});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();

  static Widget _transactionItem(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEAF2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.call_received, color: Color(0xFFE91E63)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gold Plan Commission",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: opensansSemiBold.copyWith(fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  "#874521     17 Sep 2023",
                  style: opensansSemiBold.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(amount, style: opensansSemiBold.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployeeScreen(),
      key: _scaffoldKey1,
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            padding: EdgeInsets.only(top: 0),
            color: ColorResources.primarycolor2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.hide == "Hide"
                      ? GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 22,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _scaffoldKey1.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                  Text(
                    "Transactions",
                    style: opensansSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(''),
                  // const Spacer(),
                ],
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Row(
              children: const [
                Expanded(
                  child: SummaryCard(
                    title: "PAID\nCOMMISSION",
                    amount: "₹5,85",
                    icon:
                        'assets/images/arrow-narrow-circle-broken-down-right_svgrepo.com.png',
                    iconColor: Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: "PENDING\nCOMMISSION",
                    amount: "₹10,251",
                    icon: 'assets/images/Frame 87 2.png',
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 215),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Recent Transactions",
                              style: opensansSemiBold.copyWith(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4EE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "View All",
                              style: opensansSemiBold.copyWith(
                                color: Color(0xFFE91E63),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    TransactionsScreen._transactionItem(
                      "Gold Plan Commission",
                      "₹ 218.00",
                    ),
                    TransactionsScreen._transactionItem(
                      "Registration Commission",
                      "₹ 350.00",
                    ),
                    TransactionsScreen._transactionItem(
                      "Gold Plan Commission",
                      "₹ 210.00",
                    ),
                    TransactionsScreen._transactionItem(
                      "Premium Plan Commission",
                      "₹ 810.00",
                    ),
                    TransactionsScreen._transactionItem(
                      "VIP Shaadi Plan Commission",
                      "₹ 780.00",
                    ),
                    TransactionsScreen._transactionItem(
                      "Lead Conversion",
                      "₹ 900.00",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 SUMMARY CARD
class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String icon;
  final Color iconColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 30),
          SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: opensansSemiBold.copyWith(
                  fontSize: 14,
                  color: ColorResources.blackgrey,
                ),
              ),
              Text(
                amount,
                style: opensansSemiBold.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
