import 'package:flutter/material.dart';
import 'package:vivashri/app/modules/Deshboard/deshboard.dart';
import 'package:vivashri/app/modules/chat/chatscreen.dart';
import 'package:vivashri/app/modules/connect/connectscreen.dart';
import 'package:vivashri/app/modules/match/matchscreen.dart';
import 'package:vivashri/config/utils/colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    MatchesScreen(),
    ConnectScreen(),
    ChatScreen(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),

      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  Widget _buildCustomBottomBar() {
    final items = [
      _BottomItem(img: "assets/images/Vector.png", label: "Home"),
      _BottomItem(
        img: "assets/images/Engagement Rings - iconSvg.co.png",
        label: "Matches",
      ),
      _BottomItem(
        img: "assets/images/envelope_svgrepo.com.png",
        label: "Connect",
      ),
      _BottomItem(img: "assets/images/Vector (1).png", label: "Chat"),
      _BottomItem(
        img: "assets/images/Frame 15.png",
        label: "",
      ), // Premium Zone image only
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = _currentIndex == index;

            if (index == 4) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: Container(
                  child: Image.asset(
                    item.img,
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                    color: ColorResources.primarycolor3,
                  ),
                ),
              );
            }

            // ---------------- OTHER BOTTOM ITEMS ----------------
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.img,
                        height: 24,
                        width: 24,
                        color: selected
                            ? ColorResources.primarycolor3
                            : ColorResources.blackgrey,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? ColorResources.primarycolor3
                              : ColorResources.blackgrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomItem {
  final String img;
  final String label;

  _BottomItem({required this.img, required this.label});
}
