import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/recived_interst.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:vivashri/widgets/image_view.dart';

class ShortlistedScreen extends StatefulWidget {
  const ShortlistedScreen({super.key});

  @override
  State<ShortlistedScreen> createState() => _ShortlistedScreenState();
}

class _ShortlistedScreenState extends State<ShortlistedScreen> {
  int selectedFilter = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final inboxCtrl = Get.put(InboxReceivedController());
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

  final userbyuserController = Get.put(UserbyUserDetailController());
  final sentCtrl = Get.put(SentInterestController());

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

  final usercontroller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final u = usercontroller.userData.value!;

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
                        '${u.shortlisted} Profile',
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (inboxCtrl.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.primarycolor2,
                        ),
                      );
                    }

                    if (inboxCtrl.shotlisttedList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Data Found!",
                          style: opensansSemiBold.copyWith(),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: inboxCtrl.shotlisttedList.length,
                      itemBuilder: (context, index) {
                        final item = inboxCtrl.shotlisttedList[index];
                        final user = item.partnerId;
                        String age = calculateAgeInYears(user?.dob);
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
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 9 / 11,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          user!.photo != null
                                              ? "${ApiConstants.imageurl}${user.photo!}"
                                              : "",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Image.asset(
                                                  user.gender == "Male"
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
                                          // color: Colors.white.withOpacity(0.85),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                buildPhotoList(user);
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (_) =>
                                                      PhotoSliderDialog(
                                                        photos: photosmatch,
                                                      ),
                                                );
                                              },
                                              child: Image.asset(
                                                'assets/images/imagecount.png',
                                                height: 40,
                                              ),
                                            ),
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
                                      child: Image.asset(
                                        'assets/images/Group 285.png',
                                        height: 25,
                                      ),
                                    ),

                                    // BOTTOM TEXT CONTENT (ON IMAGE)
                                    Positioned(
                                      bottom: 14,
                                      left: 14,
                                      right: 14,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // TAGS
                                          Row(
                                            children: [
                                              _darkTag(
                                                "Profile managed by Self",
                                              ),
                                              const SizedBox(width: 6),
                                              _darkTagonline("Online"),
                                            ],
                                          ),

                                          const SizedBox(height: 5),

                                          Row(
                                            children: [
                                              Text(
                                                "${user.name ?? ""}",
                                                style: opensansMedium.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "(ID: ${user.profileId ?? ""})",
                                                style: opensansMedium.copyWith(
                                                  color: ColorResources
                                                      .primarycolor2,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 4),

                                          // DETAILS L1
                                          Text(
                                            "• $age, ${user.height}” • ${user.religion?.name ?? ""} • ${user.subCaste?.name ?? ""} • ${user.manglik ?? ""}",
                                            style: opensansMedium.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),

                                          // DETAILS L2
                                          Text(
                                            "• ${user.occupation?.name ?? ""} • Earns ₹${user.annualIncome ?? ""} Lacs p.a • ${user.locState?.name ?? ""}",
                                            style: opensansMedium.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,

                                      right: 14,
                                      child: user.shortlistsent == false
                                          ? GestureDetector(
                                              onTap: () {
                                                sentCtrl.sendshortlisted(
                                                  user.id.toString(),
                                                );
                                              },
                                              child: Image.asset(
                                                'assets/images/shortlist (1).png',
                                                height: 50,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                sentCtrl.removeshortlisted(
                                                  user.id.toString(),
                                                );
                                              },
                                              child: Image.asset(
                                                'assets/images/shortlist 2.png',
                                                height: 50,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),

                              // ----------------- BOTTOM BUTTONS -----------------
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Builder(
                                        builder: (_) {
                                          final status = user.interestsentstatus
                                              ?.toString()
                                              .trim();

                                          if (status == null ||
                                              status.isEmpty) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  sentCtrl.sendInterest(
                                                    user.id.toString(),
                                                  ),
                                              child: Image.asset(
                                                'assets/images/Frame 63 2.png',
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.05,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }

                                          if (status == "Pending") {
                                            return GestureDetector(
                                              onTap: () {
                                                Get.snackbar(
                                                  "Pending",
                                                  'Your request is already pending.',
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              },
                                              // onTap: () => sentCtrl.sendInterest(u.id.toString()),
                                              child: Image.asset(
                                                'assets/images/Frame 63 (1).png',
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.05,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }

                                          if (status == "Accepted") {
                                            return GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                'assets/images/Group 85 (1).png',
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.04,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }

                                          return GestureDetector(
                                            onTap: () => print(
                                              "Unknown status: $status",
                                            ),
                                            child: Image.asset(
                                              'assets/images/Frame 63 2.png',
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.05,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    user.interestsentstatus == "Accepted"
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                'assets/images/viewprofile (1).png',
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.040,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                userbyuserController
                                                    .fetchUserDetail(
                                                      user.id.toString(),
                                                    );
                                                Get.to(
                                                  UserProfileDetailsPage(),
                                                  duration: Duration(
                                                    milliseconds: ApiConstants
                                                        .screenTransitionTime,
                                                  ),
                                                  transition:
                                                      Transition.rightToLeft,
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
                        // _profileCard(w, h);
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
              "Shortlisted",
              style: opensansMedium.copyWith(
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
