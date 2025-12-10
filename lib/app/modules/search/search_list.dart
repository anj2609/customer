import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/app/modules/search/refine_search.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/modal/matchmodal.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:vivashri/widgets/image_view.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({super.key});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
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
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 12),
                  child: Row(
                    children: [
                      Text(
                        '${searchC.searchlistdata.length} Profile',
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (searchC.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.primarycolor2,
                        ),
                      );
                    }

                    if (searchC.searchlistdata.isEmpty) {
                      return Center(child: Text("No profiles found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: searchC.searchlistdata.length,
                      itemBuilder: (context, index) {
                        final u = searchC.searchlistdata[index];
                        return _profileCard(u);
                      },
                    );
                  }),
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  //   _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 22,
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
              "Search Result",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    BasicSearchPage(hidevalue: 'Hide'),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset(
                  'assets/images/filter_svgrepo.com.png',
                  height: 25,
                  color: ColorResources.blackcolor11,
                ),
              ),
              // const SizedBox(width: 16),
              // Image.asset('assets/images/bell.png', height: 30),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- FILTER BAR ----------------

  String calculateAgeInYears(String? dobString) {
    if (dobString == null || dobString.isEmpty) return "N/A";

    try {
      DateTime dob = DateTime.parse(dobString).toLocal();
      return _getYearsOnly(dob);
    } catch (e) {
      try {
        String onlyDate = dobString.split("T")[0]; // e.g., "1998-01-01"
        List<String> p = onlyDate.split("-");

        DateTime dob = DateTime(
          int.parse(p[0]),
          int.parse(p[1]),
          int.parse(p[2]),
        );

        return _getYearsOnly(dob);
      } catch (e) {
        return "N/A";
      }
    }
  }

  String _getYearsOnly(DateTime dob) {
    DateTime now = DateTime.now();

    int years = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }

    return years.toString();
  }

  List<String> photosmatch = [];

  void buildPhotoList(dynamic u) {
    List<String?> raw = [u.photo, u.photo1, u.photo2, u.photo3, u.photo4];

    photosmatch = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  Widget _profileCard(MatchListData u) {
    String age = calculateAgeInYears(u.dob);

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
                    child: Image.network(
                      u.photo != null
                          ? "${ApiConstants.imageurl}${u.photo!}"
                          : "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          u.gender == "Male"
                              ? "assets/images/9159790.png"
                              : "assets/images/3232.png",
                          fit: BoxFit.contain,
                        );
                      },
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            buildPhotoList(u);
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) =>
                                  PhotoSliderDialog(photos: photosmatch),
                            );
                          },
                          child: Image.asset(
                            'assets/images/imagecount.png',
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Image.asset('assets/images/Group 285.png', height: 25),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 40, 14, 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _darkTag(
                              "Profile managed by ${u.profileFor!.name}",
                            ),
                            const SizedBox(width: 6),
                            _darkTagonline("Online"),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            Text(
                              u.name ?? "",
                              style: opensansMedium.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              u.profileId == null
                                  ? "(ID: --)"
                                  : "(ID: ${u.profileId})",
                              style: opensansMedium.copyWith(
                                color: ColorResources.primarycolor2,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "• ${age} yrs, ${u.height ?? ''}   "
                          "• ${u.religion?.name ?? ''}   "
                          "• ${u.manglik ?? ''}   "
                          "• ${u.highestDegree?.name ?? ''}",
                          style: opensansSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),

                        Text(
                          "• ${u.occupation?.name ?? ''} "
                          "Earns ₹${u.annualincome ?? '0'} Lacs p.a "
                          "• ${u.locState?.name ?? ''}",
                          style: opensansMedium.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/Frame 63.png',
                    height: MediaQuery.of(context).size.height * 0.05,
                    fit: BoxFit.contain,
                  ),
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
                      height: MediaQuery.of(context).size.height * 0.040,
                      fit: BoxFit.contain,
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
