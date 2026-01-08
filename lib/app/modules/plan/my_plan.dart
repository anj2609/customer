import 'package:flutter/material.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/drawer.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> plans = [
    {
      "name": "PLATINUM",
      "used": "10 Batteries Consumed",
      "days": "Expired In 15 Days",
      "color": const Color(0xFF63C85B),
    },
    {
      "name": "PLATINUM",
      "used": "10 Batteries Consumed",
      "days": "Expired In 15 Days",
      "color": const Color(0xFF2E63A7),
    },
    {
      "name": "PLATINUM",
      "used": "10 Batteries Consumed",
      "days": "Expired In 15 Days",
      "color": const Color(0xFF5AA9E6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          /// 🔹 Background Image
          Positioned.fill(
            child: Image.asset("assets/images/iPhone2.png", fit: BoxFit.cover),
          ),

          Column(
            children: [
              /// 🔹 HEADER
              SizedBox(
                height: 160,
                width: double.infinity,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              height: 60,
                              width: 100,
                            ),

                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/images/user 1.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: Text(
                              "My Plan",
                              style: opensansSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔹 LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final item = plans[index];
                    return SubscriptionCard(
                      title: item["name"],
                      usedText: item["used"],
                      expiryText: item["days"],
                      headerColor: item["color"],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String usedText;
  final String expiryText;
  final Color headerColor;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.usedText,
    required this.expiryText,
    required this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🔹 MAIN CARD
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                /// 🔹 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "PACKAGE NAME: $title",
                      style: opensansSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                /// 🔹 CENTER TEXT
                Text(
                  usedText,
                  style: opensansSemiBold.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          Positioned(
            bottom: -17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8431E),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      expiryText,
                      style: opensansSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
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
