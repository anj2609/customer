import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/app/modules/search/refine_search.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/controller/userprofile.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                  size: 24,
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

  List<String> photosblur = [];

  void buildPhotoList22(dynamic u) {
    List<String?> raw = [u.photoBlur];

    photosblur = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  final usercontroller = Get.put(UserDetailController());

  Widget _profileCard(MatchListData u) {
    String age = calculateAgeInYears(u.dob);
    final user = usercontroller.userData.value!;

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
                GestureDetector(
                  onTap: () {
                    userbyuserController.fetchUserDetail(u.id.toString());
                    Get.to(
                      UserProfileDetailsPage(),
                      duration: Duration(
                        milliseconds: ApiConstants.screenTransitionTime,
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: AspectRatio(
                    aspectRatio: 9 / 11,
                    child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        if (u.profilesetting == null)
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              "${ApiConstants.imageurl}${u.photo}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  u.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        if (u.profilesetting?.photoShow == 2)
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              "${ApiConstants.imageurl}${u.photo}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  u.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == null &&
                            u.photorequestcheck == false)
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              "${ApiConstants.imageurl}${u.photoBlur}",

                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  u.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == null &&
                            u.photorequestcheck == true)
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              "${ApiConstants.imageurl}${u.photoBlur}",

                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  u.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == 1 &&
                            u.photorequestcheck == true)
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              "${ApiConstants.imageurl}${u.photo}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  u.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        /////
                        if (u.profilesetting?.photoShow == 2) SizedBox(),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == null &&
                            u.photorequestcheck == false)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/locked-icon.png'),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    sentCtrl.sendphotorequest(u.id.toString());
                                  },
                                  child: Text(
                                    "Request a Photo",
                                    style: opensansSemiBold.copyWith(
                                      color: ColorResources.primarycolor2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == null &&
                            u.photorequestcheck == true)
                          SizedBox(),

                        if (u.profilesetting?.photoShow == 1 &&
                            u.photorequeststatus == 1 &&
                            u.photorequestcheck == true)
                          SizedBox(),
                      ],
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     userbyuserController.fetchUserDetail(u.id.toString());
                //     Get.to(
                //       UserProfileDetailsPage(),
                //       duration: Duration(
                //         milliseconds: ApiConstants.screenTransitionTime,
                //       ),
                //       transition: Transition.rightToLeft,
                //     );
                //   },
                //   child: AspectRatio(
                //     aspectRatio: 9 / 11,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(12),
                //       child: Image.network(
                //         u.photo != null
                //             ? "${ApiConstants.imageurl}${u.photo!}"
                //             : "",
                //         fit: BoxFit.cover,
                //         errorBuilder: (context, error, stackTrace) {
                //           return Image.asset(
                //             u.gender == "Male"
                //                 ? "assets/images/no-image-male2.jpg"
                //                 : "assets/images/no-image-female2.jpg",
                //             fit: BoxFit.contain,
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),
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
                if (u.profilesetting == null)
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
                if (u.profilesetting?.photoShow == 2)
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

                if (u.profilesetting?.photoShow == 1 &&
                    u.photorequeststatus == null &&
                    u.photorequestcheck == false)
                  //blur photo
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
                              buildPhotoList22(u);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) =>
                                    PhotoSliderDialog(photos: photosblur),
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

                if (u.profilesetting?.photoShow == 1 &&
                    u.photorequeststatus == null &&
                    u.photorequestcheck == true)
                  //photo blur
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
                              buildPhotoList22(u);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) =>
                                    PhotoSliderDialog(photos: photosblur),
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

                if (u.profilesetting?.photoShow == 1 &&
                    u.photorequeststatus == 1 &&
                    u.photorequestcheck == true)
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
                // LEFT PHOTOS BADGE
                // Positioned(
                //   top: 12,
                //   left: 12,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 6,
                //       vertical: 4,
                //     ),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Row(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             buildPhotoList(u);
                //             showDialog(
                //               context: context,
                //               barrierDismissible: true,
                //               builder: (_) =>
                //                   PhotoSliderDialog(photos: photosmatch),
                //             );
                //           },
                //           child: Image.asset(
                //             'assets/images/imagecount.png',
                //             height: 40,
                //           ),
                //         ),
                //         SizedBox(width: 4),
                //       ],
                //     ),
                //   ),
                // ),
                u.aasherno == null
                    ? SizedBox()
                    : Positioned(
                        top: 12,
                        right: 12,
                        child: Image.asset(
                          'assets/images/Group 285.png',
                          height: 25,
                        ),
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
                            GestureDetector(
                              onTap: () {
                                userbyuserController.fetchUserDetail(
                                  u.id.toString(),
                                );
                                Get.to(
                                  UserProfileDetailsPage(),
                                  duration: Duration(
                                    milliseconds:
                                        ApiConstants.screenTransitionTime,
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: Text(
                                (() {
                                  String name = u.name ?? "";
                                  int showType =
                                      u.profilesetting?.nameShow ?? 1;

                                  bool isPremium = false;
                                  if (user.planDetail != null) {
                                    if (user.planDetail is Map &&
                                        user.planDetail == null) {
                                      isPremium = true;
                                    } else if (user.planDetail is List &&
                                        user.planDetail == null) {
                                      isPremium = true;
                                    }
                                  }

                                  if (name.isEmpty) return "";

                                  String maskName(String n) {
                                    if (n.length <= 2) return n[0] + "*";
                                    return n.substring(0, 2) +
                                        ("*" * (n.length - 2));
                                  }

                                  if (showType == 1) {
                                    return name;
                                  }

                                  if (showType == 2) {
                                    return isPremium ? name : maskName(name);
                                  }

                                  if (showType == 3) {
                                    return maskName(name);
                                  }

                                  return name;
                                })(),
                                style: opensansMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
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
                          "• ${age} yrs, ${(() {
                            final raw = u.height;
                            if (raw == null || raw.toString().isEmpty) return "";

                            final value = double.tryParse(raw.toString());
                            if (value == null) return raw.toString();

                            final ft = value.floor();
                            final inch = ((value - ft) * 12).round();

                            return "$ft ft $inch in";
                          })()}   "
                          "• ${u.religion?.name ?? ''}   "
                          "• ${u.highestDegree?.name ?? ''}",
                          style: opensansSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),

                        Text(
                          "• ${u.occupation?.name ?? ''} "
                          "Earns ₹${(() {
                            final income = u.annualincome;
                            if (income == null || income.toString().isEmpty) return "0";

                            final str = income.toString();

                            if (str.contains('-')) {
                              final parts = str.split('-');

                              String fmt(int v) {
                                if (v >= 10000000) {
                                  return "${(v / 10000000).toStringAsFixed(1).replaceAll('.0', '')} Cr";
                                } else if (v >= 100000) {
                                  return "${(v / 100000).toStringAsFixed(1).replaceAll('.0', '')} Lakh";
                                } else if (v >= 1000) {
                                  return "${(v / 1000).toStringAsFixed(0)} K";
                                }
                                return v.toString();
                              }

                              return "${fmt(int.tryParse(parts[0]) ?? 0)}–${fmt(int.tryParse(parts[1]) ?? 0)}";
                            }

                            final v = int.tryParse(str) ?? 0;
                            if (v >= 10000000) {
                              return "${(v / 10000000).toStringAsFixed(1).replaceAll('.0', '')} Cr";
                            } else if (v >= 100000) {
                              return "${(v / 100000).toStringAsFixed(1).replaceAll('.0', '')} Lakh";
                            } else if (v >= 1000) {
                              return "${(v / 1000).toStringAsFixed(0)} K";
                            }
                            return v.toString();
                          })()} p.a "
                          "• ${u.locState?.name ?? ''}  ${u.locCity?.name ?? ""}",
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
                  child: Builder(
                    builder: (_) {
                      final status = u.interestsentstatus?.toString().trim();

                      if (status == null || status.isEmpty) {
                        return GestureDetector(
                          onTap: () => sentCtrl.sendInterest(u.id.toString()),
                          child: Image.asset(
                            'assets/images/Frame 63 2.png',
                            height: MediaQuery.of(context).size.height * 0.05,
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
                            height: MediaQuery.of(context).size.height * 0.05,
                            fit: BoxFit.contain,
                          ),
                        );
                      }

                      if (status == "Accepted") {
                        return GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/Group 85 (1).png',
                            height: MediaQuery.of(context).size.height * 0.04,
                            fit: BoxFit.contain,
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => print("Unknown status: $status"),
                        child: Image.asset(
                          'assets/images/Frame 63 2.png',
                          height: MediaQuery.of(context).size.height * 0.05,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                u.interestsentstatus == "Accepted"
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/viewprofile (1).png',
                            height: MediaQuery.of(context).size.height * 0.040,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            userbyuserController.fetchUserDetail(
                              u.id.toString(),
                            );
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

  final sentCtrl = Get.put(SentInterestController());
  final userbyuserController = Get.put(UserbyUserDetailController());

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
