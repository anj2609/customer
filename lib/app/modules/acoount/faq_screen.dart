import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int selectedIndex = 0;

  final List<String> categories = [
    "General",
    "Account",
    "Services",
    "Ride",
  ];

  final List<Map<String, String>> faqList = [
    {
      "question": "What is My Ride?",
      "answer":
          "My Ride is a convenient ride-hailing service that allows you to book rides quickly and easily using your smartphone."
    },
    {"question": "How does My Ride work?", "answer": ""},
    {"question": "Is My Ride free to use?", "answer": ""},
    {"question": "Can I use My Ride offline?", "answer": ""},
    {"question": "Is my data secure with My Ride?", "answer": ""},
    {"question": "Can I export my My Ride data?", "answer": ""},
    {"question": "How do i contact support?", "answer": ""},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "FAQ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),

            /// 🔍 Search Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// 🏷 Category Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// 📋 FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      tilePadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        faqList[index]["question"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      children: faqList[index]["answer"]!.isNotEmpty
                          ? [
                              Text(
                                faqList[index]["answer"]!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ]
                          : [],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}