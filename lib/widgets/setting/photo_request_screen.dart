import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/accept_interest.dart';
import 'package:vivashri/data/controller/recived_interst.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/drawer.dart';

class PhotoRequestScreen extends StatefulWidget {
  final int initialIndex;
  const PhotoRequestScreen({super.key, this.initialIndex = 0});

  @override
  State<PhotoRequestScreen> createState() => _PhotoRequestScreenState();
}

class _PhotoRequestScreenState extends State<PhotoRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? profileid;
  final usercontroller = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 1,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
    // checkcontroller.checkProfileComplete(profileid.toString());
  }

  final inboxCtrl = Get.put(InboxReceivedController());
  final statusController = Get.put(StatusController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(w),

                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: ColorResources.primarycolor2,
                    color: Colors.white,
                    onRefresh: () async {
                      inboxCtrl.photorecived();
                    },

                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [_receivedTab(w, h)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Statusbar color
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
              "View Photo Request",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  final userbyuserController = Get.put(UserbyUserDetailController());
  final sentCtrl = Get.put(SentInterestController());

  // ---------------- RECEIVED TAB ----------------
  Widget _receivedTab(double w, double h) {
    final u = usercontroller.userData.value!;

    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.photorequest.isEmpty) {
        return Center(
          child: Text("No Data Found!", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.photorequest.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.photorequest[index];
          final user = item.memberId;
          String age = calculateAgeInYears(user?.dob);
          return GestureDetector(
            onTap: () {
              userbyuserController.fetchUserDetail(user!.id.toString());
              Get.to(
                UserProfileDetailsPage(),
                duration: Duration(
                  milliseconds: ApiConstants.screenTransitionTime,
                ),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                left: 12,
                right: 12,
                top: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                      top: Radius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 11,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              // fit: StackFit.expand,
                              children: [
                                if (user?.profilesetting == null)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photo}",
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        user?.gender == "Male"
                                            ? "assets/images/no-image-male2.jpg"
                                            : "assets/images/no-image-female2.jpg",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                if (user?.profilesetting?.photoShow == 2)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photo}",
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        user?.gender == "Male"
                                            ? "assets/images/no-image-male2.jpg"
                                            : "assets/images/no-image-female2.jpg",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == null &&
                                    item.photorequestcheck == false)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photoBlur}",

                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        user?.gender == "Male"
                                            ? "assets/images/no-image-male2.jpg"
                                            : "assets/images/no-image-female2.jpg",
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == null &&
                                    item.photorequestcheck == true)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photoBlur}",

                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        user?.gender == "Male"
                                            ? "assets/images/no-image-male2.jpg"
                                            : "assets/images/no-image-female2.jpg",
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == 1 &&
                                    item.photorequestcheck == true)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photo}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        user?.gender == "Male"
                                            ? "assets/images/no-image-male2.jpg"
                                            : "assets/images/no-image-female2.jpg",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                /////
                                if (user?.profilesetting?.photoShow == 2)
                                  SizedBox(),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == null &&
                                    item.photorequestcheck == false)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/locked-icon.png',
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            sentCtrl.sendphotorequest(
                                              user!.id.toString(),
                                            );
                                          },
                                          child: Text(
                                            "Request a Photo",
                                            style: opensansSemiBold.copyWith(
                                              color:
                                                  ColorResources.primarycolor2,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == null &&
                                    item.photorequestcheck == true)
                                  SizedBox(),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    item.photorequeststatus == 1 &&
                                    item.photorequestcheck == true)
                                  SizedBox(),
                              ],
                            ),
                          ),
                        ),

                        // AspectRatio(
                        //   aspectRatio: 9 / 11,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(12),
                        //     child: Image.network(
                        //       user!.photo != null
                        //           ? "${ApiConstants.imageurl}${user.photo!}"
                        //           : "",
                        //       fit: BoxFit.cover,
                        //       errorBuilder: (context, error, stackTrace) {
                        //         return Image.asset(
                        //           user.gender == "Male"
                        //               ? "assets/images/9159790.png"
                        //               : "assets/images/3232.png",
                        //           fit: BoxFit.contain,
                        //         );
                        //       },
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

                        Positioned(
                          top: 12,
                          right: 12,
                          child: Column(
                            children: [
                              // Image.asset(
                              //   'assets/images/Group 285.png',
                              //   height: 25,
                              // ),
                              // SizedBox(height: 10),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   child: Image.asset(
                              //     'assets/images/imagecount.png',
                              //     height: 40,
                              //   ),
                              // ),
                            ],
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
                                      (() {
                                        String name = user?.name ?? "";
                                        int showType =
                                            user?.profilesetting?.nameShow ?? 1;

                                        bool isPremium = false;
                                        if (u.planDetail != null) {
                                          if (u.planDetail is Map &&
                                              u.planDetail == null) {
                                            isPremium = true;
                                          } else if (u.planDetail is List &&
                                              u.planDetail == null) {
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
                                          return isPremium
                                              ? name
                                              : maskName(name);
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
                                    // Text(
                                    //   "${user?.name ?? ""}",
                                    //   style: opensansMedium.copyWith(
                                    //     color: Colors.white,
                                    //     fontSize: 17,
                                    //   ),
                                    // ),
                                    Text(
                                      "(ID: ${user?.profileId})",
                                      style: opensansMedium.copyWith(
                                        color: ColorResources.primarycolor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "• $age, ${user?.height ?? ""}” • ${user?.religion?.name ?? ""}  • ${user?.subCaste?.name ?? ""}",
                                  style: opensansMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                // DETAILS L2
                                Text(
                                  "• ${user?.occupation?.name ?? ""} • Earns ₹${user?.annualIncome} Lacs p.a • ${user?.locState?.name ?? ""}",
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Invitation Received on ${formatDate(item.createdAt)}",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.primarycolor2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (item.status == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 1.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/Frame 61.png',
                                height: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 2.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/viewprofile.png',
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (item.status == 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 1.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/Frame 61 2.png',
                                height: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 2.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/viewprofile.png',
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (item.status == 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 1.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/Frame 61.png',
                                height: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                statusController.photorequest(
                                  id: item.id.toString(),
                                  status: 2.toString(),
                                );
                              },
                              child: Image.asset(
                                'assets/images/viewprofile 5.png',
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "";
    try {
      DateTime date = DateTime.parse(dateString).toLocal();
      return DateFormat("dd MMMM yyyy").format(date);
    } catch (e) {
      return dateString;
    }
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
            style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 11),
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
        style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
