import 'package:flutter/material.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/drawer.dart';

class SubscirptinPlan extends StatefulWidget {
  const SubscirptinPlan({super.key});

  @override
  State<SubscirptinPlan> createState() => _SubscirptinPlanState();
}

class _SubscirptinPlanState extends State<SubscirptinPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  final List<PlanModel> plans = [
    PlanModel(
      title: "PLAN 999",
      subtitle: "[ Ideal For 30+ Swaps ]",
      price: 999,
      days: 30,
      rate: 99,
      freeSwaps: 5,
      topColor: const Color(0xFF6CF47A),
      midColor: const Color(0xFFBDF5B8),
      buttonColor: const Color(0xFF8EF081),
    ),
    PlanModel(
      title: "PLAN 1499",
      subtitle: "[ Ideal For 45+ Swaps ]",
      price: 1499,
      days: 45,
      rate: 79,
      freeSwaps: 7,
      topColor: const Color(0xFFFFE08A),
      midColor: const Color(0xFFFFEDB7),
      buttonColor: const Color(0xFFFFD56A),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/iPhone2.png", fit: BoxFit.cover),
          ),

          Column(
            children: [
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
                              "Subscription Plan",
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

              /// 🔹 LIST SECTION
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return PlanCard(
                      plan: plans[index],
                      onSubscribe: () {
                        debugPrint("Subscribed ${plans[index].title}");
                      },
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

class PlanModel {
  final String title;
  final String subtitle;
  final int price;
  final int days;
  final int rate;
  final int freeSwaps;
  final Color topColor;
  final Color midColor;
  final Color buttonColor;

  PlanModel({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.days,
    required this.rate,
    required this.freeSwaps,
    required this.topColor,
    required this.midColor,
    required this.buttonColor,
  });
}

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onSubscribe;

  const PlanCard({super.key, required this.plan, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // ---------------- CARD ----------------
          Container(
            padding: const EdgeInsets.only(bottom: 45), // 🔑 button space
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOP
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: plan.topColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        plan.title,
                        style: opensansSemiBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        plan.subtitle,
                        style: opensansSemiBold.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // PRICE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: plan.midColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₹${plan.price}",
                        style: opensansSemiBold.copyWith(fontSize: 38),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "/ For ${plan.days} Days",
                        style: opensansSemiBold.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),

                // RATE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: plan.midColor.withOpacity(.7),
                  child: Center(
                    child: Text(
                      "RATE PER SWAP : ₹${plan.rate}",
                      style: opensansSemiBold.copyWith(fontSize: 16),
                    ),
                  ),
                ),

                // FREE SWAPS
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Free Swaps: ${plan.freeSwaps}",
                        style: opensansSemiBold.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.list_alt),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------- BUTTON (OUTSIDE) ----------------
          Positioned(
            bottom: -22,
            child: GestureDetector(
              onTap: onSubscribe,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: plan.buttonColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Subscribe Now",
                  style: opensansSemiBold.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
