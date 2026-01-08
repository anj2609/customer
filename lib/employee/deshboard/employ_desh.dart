import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/employee/deshboard/buttom_desh.dart';
import 'package:vivashri/employee/leads/converted_leads.dart';
import 'package:vivashri/employee/leads/leads.dart';
import 'package:vivashri/employee/leads/leads_details.dart';
import 'package:vivashri/employee/transaction/all_trasaction.dart';
import 'package:vivashri/employee/transaction/transction.dart';
import 'package:vivashri/widgets/custum_header.dart';
import 'package:vivashri/widgets/employ_drawer.dart';

class EmployeeDeshboardScreen extends StatefulWidget {
  const EmployeeDeshboardScreen({super.key});

  @override
  State<EmployeeDeshboardScreen> createState() =>
      _EmployeeDeshboardScreenState();
}

class _EmployeeDeshboardScreenState extends State<EmployeeDeshboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployeeScreen(),
      key: _scaffoldKey1,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          customHeader(_scaffoldKey1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 15,
                    ),
                    child: GridView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.8,
                          ),
                      children: [
                        StatsCard(
                          title: "Total Leads",
                          value: "08",
                          color: Color(0xFFFFB7D8),
                          icon: 'assets/images/calender_svgrepo.com.png',
                          maxLines: 1,
                          onTap: () {
                            Get.to(
                              MyLeadsScreen(initialIndex: false, hide: "Hide"),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                        StatsCard(
                          title: "Converted\nLeads",
                          value: "20",
                          color: Color(0xFF9FE9B8),
                          icon: 'assets/images/document-copy_svgrepo.com.png',
                          maxLines: 2,
                          onTap: () {
                            Get.to(
                              ConvertedLeads(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                        StatsCard(
                          title: "Paid\nCommission",
                          value: "24",
                          color: Color(0xFFFFD682),
                          icon: 'assets/images/task-management_svgrepo.com.png',
                          maxLines: 2,
                          onTap: () {
                            Get.to(
                              AllTransactionsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                        StatsCard(
                          title: "Pending\nCommission",
                          value: "00",
                          color: Color(0xFF70D7DB),
                          icon: 'assets/images/task-list-add_svgrepo.com.png',
                          maxLines: 2,
                          onTap: () {
                            Get.offAll(
                              EmployeButtomScreen(initialIndex: 2),
                              duration: Duration(milliseconds: 0),
                              transition: Transition.rightToLeft,
                            );
                            // Get.to(
                            //   TransactionsScreen(hide: "Hide"),
                            //   duration: Duration(
                            //     milliseconds: ApiConstants.screenTransitionTime,
                            //   ),
                            //   transition: Transition.rightToLeft,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                  addNewLeadButton(),
                  myLeadsCard(),
                  Container(
                    height: 400,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: LeadCard(
                            name: index == 0
                                ? "Santosh Kumar"
                                : "Amitabh Singh Rathod",
                            id: "#786 2548",
                            email: "santosh@gmail.com",
                            phone: "+91-9873985748",
                            date: "June 12, 2025",
                            status: "Pending",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewLeadButton() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            Get.offAll(
              EmployeButtomScreen(initialIndex: 1),
              duration: Duration(milliseconds: 0),
              transition: Transition.rightToLeft,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                "Add New Lead",
                style: opensansSemiBold.copyWith(
                  fontSize: 16,

                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myLeadsCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 12,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
        ),

        child: Row(
          children: [
            Expanded(
              child: Text(
                "My Leads",
                style: opensansSemiBold.copyWith(fontSize: 18),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB33A6A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "View All",
                style: opensansSemiBold.copyWith(
                  color: Color(0xFFB33A6A),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final String icon;
  final int maxLines;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.maxLines,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: opensansSemiBold.copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(icon, height: 25),
                // Icon(icon, size: 22),
              ],
            ),

            Text(value, style: opensansSemiBold.copyWith(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final String name;
  final String id;
  final String email;
  final String phone;
  final String date;
  final String status;

  const LeadCard({
    super.key,
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          LeadDetailsPage(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 222, 239, 249),
              Color.fromARGB(255, 243, 213, 226),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: $id",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    status,
                    style: opensansSemiBold.copyWith(
                      color: Color(0xFFF05A28),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(Icons.email_outlined, email),
                      const SizedBox(height: 6),
                      _infoRow(Icons.phone_iphone, phone),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lead Date:",
                      style: opensansSemiBold.copyWith(
                        fontSize: 12,
                        color: ColorResources.blackgrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: opensansSemiBold.copyWith(
                            fontSize: 12,
                            color: ColorResources.blackgrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ColorResources.blackgrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: opensansSemiBold.copyWith(
              fontSize: 12,
              color: ColorResources.blackgrey,
            ),
          ),
        ),
      ],
    );
  }
}
