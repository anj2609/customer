import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/data/controller/swap_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/config/utils/style.dart';

class SwapHistory extends StatefulWidget {
  const SwapHistory({super.key});

  @override
  State<SwapHistory> createState() => _SwapHistoryState();
}

class _SwapHistoryState extends State<SwapHistory> {
  final SwapController swaipcontroller = Get.put(SwapController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    swaipcontroller.getSwapHistory();
  }
  final List<Map<String, String>> historyList = [
    {
      "rec": "24 Nov 22",
      "bs": "#786542",
      "swap": "24 Nov 22",
      "st": "Noida\nSector. 62",
    },
    {
      "rec": "24 Nov 22",
      "bs": "#786542",
      "swap": "24 Nov 22",
      "st": "Indirapuram",
    },
    {
      "rec": "24 Nov 22",
      "bs": "#786542",
      "swap": "24 Nov 22",
      "st": "Ghaziabad",
    },
    {
      "rec": "24 Nov 22",
      "bs": "#786542",
      "swap": "24 Nov 22",
      "st": "Gautam Budh\nNagar",
    },
    {
      "rec": "24 Nov 22",
      "bs": "#786542",
      "swap": "24 Nov 22",
      "st": "Noida\nSector. 83",
    },
  ];

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
                          "Swap History",
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
                    right: 10,
                    left: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF10224C),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        /// 🔹 HEADER
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D1B3F),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: const [
                              _HeaderText("Rec. Date"),
                              _HeaderText("B. S.No"),
                              _HeaderText("Swap Date"),
                              _HeaderText("Swap St."),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Obx(() {
                            if (swaipcontroller.swapList.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Swap History Found !',
                                  style: opensansSemiBold.copyWith(
                                    fontSize: 13.5,
                                    color: ColorResources.primarycolor,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: swaipcontroller.swapList.length,
                              itemBuilder: (context, index) {
                                final item = swaipcontroller.swapList[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: index.isOdd
                                        ? const Color(0xFFE6F1FF)
                                        : Colors.white,
                                    border: const Border(
                                      bottom: BorderSide(
                                        color: Color(0xFF10224C),
                                        width: 0.8,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      _RowText(item["swap_date"]!),
                                      _RowText(item["battery_serial_no"]!),
                                      _RowText(item["swap_date"]!),
                                      _RowText(item["address"]!),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final String text;
  const _RowText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: opensansSemiBold.copyWith(fontSize: 11.5, color: Colors.black),
      ),
    );
  }
}
