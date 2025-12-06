import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/modal/matchmodal.dart';
import 'package:vivashri/widgets/drawer.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int selectedFilter = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchC = Get.put(SearchmatchController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomAppDrawer(),

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(w),

                _buildFilterBar(),
                Expanded(
                  child: Obx(() {
                    if (searchC.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (searchC.users.isEmpty) {
                      return Center(child: Text("No profiles found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: searchC.users.length,
                      itemBuilder: (context, index) {
                        final u = searchC.users[index];
                        return _profileCard(u);
                      },
                    );
                  }),
                ),

                // Expanded(
                //   child: ListView.builder(
                //     padding: const EdgeInsets.all(12),
                //     itemCount: 5,
                //     itemBuilder: (context, index) {
                //       return _profileCard(w, h);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: ColorResources.blackcolor11,
                  size: 28,
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 245, 242),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Matches",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/search-alt_svgrepo.com.png',
                height: 25,
                color: ColorResources.blackcolor11,
              ),
              const SizedBox(width: 16),
              Image.asset('assets/images/bell.png', height: 30),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- FILTER BAR ----------------
  Widget _buildFilterBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              _filterChip(Icons.tune, "Filters", 0),
              const SizedBox(width: 10),
              _filterChip(null, "My Match", 1),
              const SizedBox(width: 10),
              _filterChip(null, "Today Match", 2),
              const SizedBox(width: 10),
              _filterChip(null, "Near Me", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(IconData? icon, String text, int id) {
    bool active = selectedFilter == id;

    return InkWell(
      onTap: () {
        setState(() => selectedFilter = id);

        if (id == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FilterPage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: active ? ColorResources.primarycolor3 : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 16,
                color: active ? ColorResources.primarycolor3 : Colors.black87,
              ),
            if (icon != null) const SizedBox(width: 6),
            Text(
              text,
              style: opensansMedium.copyWith(
                fontSize: 13.5,
                color: active ? ColorResources.primarycolor3 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(MatchListData u) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 11,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/imageback.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // LEFT PHOTOS BADGE
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/imagecount.png', height: 40),
                        // Icon(Icons.image, size: 16, color: Colors.black87),
                        SizedBox(width: 4),
                        //  Text("1", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),

                // VERIFIED BADGE
                Positioned(
                  top: 12,
                  right: 12,
                  child: Image.asset('assets/images/Group 285.png', height: 25),
                ),

                // BOTTOM TEXT CONTENT (ON IMAGE)
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TAGS
                      Row(
                        children: [
                          _darkTag("Profile managed by Self"),
                          const SizedBox(width: 6),
                          _darkTagonline("Online"),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Text(
                            "Rupali Jha ",
                            style: opensansMedium.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            "(ID: 600155)",
                            style: opensansMedium.copyWith(
                              color: ColorResources.primarycolor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // DETAILS L1
                      Text(
                        "• 22, 5’ 6” • Hindu • Agarwal • Non Manglik",
                        style: opensansMedium.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      // DETAILS L2
                      Text(
                        "• Teacher • Earns ₹15 Lacs p.a • Bihar",
                        style: opensansMedium.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ----------------- BOTTOM BUTTONS -----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset('assets/images/Frame 63.png', height: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        UserProfileDetailsPage(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Image.asset(
                      'assets/images/viewprofile 3.png',
                      height: 34,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkTagonline(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: opensansMedium.copyWith(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _darkTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: opensansMedium.copyWith(color: Colors.white, fontSize: 11),
      ),
    );
  }

  Widget _pinkButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF6C1A2F),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/heart_svgrepo.com.png', height: 20),
          SizedBox(width: 5),
          Text(
            text,
            style: opensansMedium.copyWith(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _lightPinkButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorResources.primarycolor2,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/view_svgrepo.com.png', height: 20),
          SizedBox(width: 5),
          Text(
            text,
            style: opensansMedium.copyWith(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ---------------- FILTER PAGE ----------------
class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filters")),
      body: const Center(child: Text("Filter Options Here")),
    );
  }
}
