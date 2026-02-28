

import 'package:evfual/app/modules/Deshboard/findingdriver_screen.dart';
import 'package:flutter/material.dart';

class PromoVoucherScreen extends StatefulWidget {
  const PromoVoucherScreen({super.key});

  @override
  State<PromoVoucherScreen> createState() => _PromoVoucherScreenState();
}

class _PromoVoucherScreenState extends State<PromoVoucherScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> vouchers = [
    {
      "title": "Best Deal: 20% OFF",
      "subtitle": "EOVP25 . No min. Spend . Valid till 31/03/2026",
    },
    {
      "title": "15% OFF: New User Promotion",
      "subtitle": "NUP15K . Min. spend ₹350 . valid till 15/05/2026",
    },
    {
      "title": "10% OFF & 10% Cashback",
      "subtitle": "100FFC . Min. spend ₹350 . Valid till 30/12/2026",
    },
    {
      "title": "8% OFF & 8% Cashback",
      "subtitle": "80FF8C . Min. spend ₹500 . Valid till 30/12/2026",
    },
    {
      "title": "12% Cashback",
      "subtitle": "C12BACK . Min. spend ₹750 . Valid till 30/12/2026",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Promos / Vouchers",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),

      body: Column(
        children: [
          /// TOP CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Promo Input Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Have a Promo Code?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter code here",
                                  filled: true,
                                  fillColor: const Color(0xfff1f1f1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff1BA7C9),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Redeem",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Voucher List
                  ListView.builder(
                    itemCount: vouchers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool selected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xff1BA7C9)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              /// Left Icon
                              Container(
                                height: 44,
                                width: 44,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff1BA7C9),
                                ),
                                child: const Icon(
                                  Icons.local_offer,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// Texts
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vouchers[index]["title"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vouchers[index]["subtitle"]!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Tick Icon
                              if (selected)
                                const Icon(
                                  Icons.check,
                                  color: Color(0xff1BA7C9),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Bottom OK Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FindingDriverUI()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff1BA7C9),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      
      
      
        ],
      ),
    );
  }
}



