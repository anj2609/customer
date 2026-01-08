import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';

class SwapStattions extends StatefulWidget {
  const SwapStattions({super.key});

  @override
  State<SwapStattions> createState() => _SwapStattionsState();
}

class _SwapStattionsState extends State<SwapStattions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 26,
                              ),
                              onPressed: () => Get.back(),
                            ),
                            Image.asset('assets/images/logo.png', height: 55),
                            const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/images/user 1.png",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Swap Stations",
                          style: opensansSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    right: 15,
                    left: 15,
                  ),
                  child: Column(
                    children: [
                      _stationCard(isHighlighted: true),
                      _stationCard(),
                      _stationCard(isHighlighted: true),
                      _stationCard(),
                    ],
                  ),
                ),
              ),
            ],
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
