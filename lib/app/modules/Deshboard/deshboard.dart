import 'package:flutter/material.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomAppDrawer(),
      backgroundColor: ColorResources.primarycolor3,
      body: Column(
        children: [
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// 🔹 Background Image
                Image.asset("assets/images/Frame 3.png", fit: BoxFit.cover),

                /// 🔹 Optional dark overlay (text readable rahe)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                /// 🔹 Content on top
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// MENU + PROFILE
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  "assets/images/user 1.png",
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "DASHBOARD",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Welcome User",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nearest Swap Stations",
                    style: opensansSemiBold.copyWith(fontSize: 17),
                  ),

                  const SizedBox(height: 16),

                  _stationCard(isHighlighted: true),
                  _stationCard(),

                  //  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "View More",
                        style: opensansSemiBold.copyWith(color: Colors.green),
                      ),
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

  Widget _stationCard({bool isHighlighted = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDBFBE8), Color(0xFFFFFFFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "AKS Swap Station",
                style: opensansSemiBold.copyWith(
                  fontSize: 15,
                  color: ColorResources.blueeebutton,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "1.5 Km",
                  style: opensansSemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.orange, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "IThum Tower A, Noida Sector 62, Uttar Pradesh. (201301)",
                  style: opensansSemiBold.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),

          SizedBox(height: 5),

          Row(
            children: [
              Icon(Icons.directions, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text(
                "Get Direction",
                style: opensansSemiBold.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
