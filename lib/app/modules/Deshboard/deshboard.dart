import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/connect/connectscreen.dart';
import 'package:vivashri/app/modules/membership/membership.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/editphotes.dart';
import 'package:vivashri/app/modules/myprofile/my_profile.dart';
import 'package:vivashri/app/modules/notification/notification.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/app/modules/shortisted/shortilisted.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/matchdeshboard.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/modal/deshbaord_match_modal.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final usercontroller = Get.put(UserDetailController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool deshboard = true;
  final matchC = Get.put(MatchController());

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        deshboard = false;
      });
    });
  }

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    String? profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 244, 229, 214),
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: Obx(() {
          if (usercontroller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorResources.primarycolor2,
              ),
            );
          }

          if (usercontroller.userData.value == null) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorResources.primarycolor2,
              ),
            );
          }

          return Column(
            children: [
              _buildTopBar(w),

              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: ColorResources.primarycolor2,
                  onRefresh: () async {
                    profileapi();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(context),
                        const SizedBox(height: 1),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 10),
                            child: _buildInvitationStats(context),
                          ),
                        ),
                        _buildMyPlanSection(context),

                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: _buildPremiumInfoCard(context),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: _buildMatchesSection(context),
                        ),

                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: _buildpremuimSection(context),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
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
              "Dashboard",
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
                    BasicSearchPage(),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset(
                  'assets/images/search-alt_svgrepo.com.png',
                  height: 25,
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Get.to(
                    NotificationPage(),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset('assets/images/bell.png', height: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final u = usercontroller.userData.value!;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 229, 214),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Stack(
                        children: [
                          // MAIN POPUP
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    "${ApiConstants.imageurl}${u.photo}",
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      String gender = u.gender.toString();

                                      if (gender == "Male") {
                                        return Image.asset(
                                          "assets/images/9159790.png",
                                          fit: BoxFit.contain,
                                        );
                                      } else if (gender == "Female") {
                                        return Image.asset(
                                          "assets/images/3232.png",
                                          fit: BoxFit.contain,
                                        );
                                      } else {
                                        return Image.asset(
                                          "assets/images/profilee.png",
                                          fit: BoxFit.contain,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: w * 0.25,
                height: w * 0.30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${ApiConstants.imageurl}${u.photo}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      String gender = u.gender.toString();

                      if (gender == "Male") {
                        return Image.asset(
                          "assets/images/9159790.png",
                          fit: BoxFit.contain,
                        );
                      } else if (gender == "Female") {
                        return Image.asset(
                          "assets/images/3232.png",
                          fit: BoxFit.contain,
                        );
                      } else {
                        return Image.asset(
                          "assets/images/profilee.png",
                          fit: BoxFit.contain,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        "${u.name![0].toUpperCase()}${u.name!.substring(1).toLowerCase()}",
                        style: opensansSemiBold.copyWith(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Colors.green, size: 15),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: u.profileId ?? ""),
                        );
                      },
                      child: Text(
                        "${u.profileId}",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.blackgrey,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          MyProfielScreen(),
                          duration: Duration(
                            milliseconds: ApiConstants.screenTransitionTime,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Image.asset(
                        'assets/images/profileicon.png',
                        height: 20,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.to(MyProfielScreen());
                      },
                      child: Text(
                        "My Profile",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.primarycolor3,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double percent = 0.40; // 40%

                          return Stack(
                            children: [
                              // BACKGROUND YELLOW (100%)
                              Container(
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),

                              // FRONT PINK (40%)
                              Container(
                                width: constraints.maxWidth * percent,
                                decoration: BoxDecoration(
                                  color: ColorResources.primarycolor3, // pink
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 4),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('assets/images/Vector32.png', height: 15),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          EditphotoesScreen(),
                          duration: Duration(
                            milliseconds: ApiConstants.screenTransitionTime,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Text(
                        "Upload Photo",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.primarycolor3,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                    Image.asset(
                      'assets/images/upload_svgrepo.com.png',
                      height: 15,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Record Short Intro",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.primarycolor3,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationStats(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = (w - 16 * 3) / 2;
    final u = usercontroller.userData.value!;

    Widget statCard(
      String count,
      String label,
      Color color,
      VoidCallback onTap,
    ) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  count,
                  style: opensansSemiBold.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(label, style: opensansSemiBold.copyWith(fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          statCard(
            "${u.receivedInvitation}",
            "Received Invitations",
            Colors.orange,
            () {
              Get.to(
                () => ConnectScreen(initialIndex: 0),
                duration: Duration(
                  milliseconds: ApiConstants.screenTransitionTime,
                ),
                transition: Transition.rightToLeft,
              );
            },
          ),
          statCard(
            "${u.receivedInvitation}",
            "Accepted Invitations",
            Colors.green,
            () {
              Get.to(
                () => ConnectScreen(initialIndex: 1),
                duration: Duration(
                  milliseconds: ApiConstants.screenTransitionTime,
                ),
                transition: Transition.rightToLeft,
              );
            },
          ),
          statCard("02", "Shortlisted Profiles", Colors.pink, () {
            Get.to(
              () => ShortlistedScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          }),
          statCard(
            "${u.interestUser}",
            "Sent Invitations",
            Colors.deepPurple,
            () {
              Get.to(
                () => ConnectScreen(initialIndex: 2),
                duration: Duration(
                  milliseconds: ApiConstants.screenTransitionTime,
                ),
                transition: Transition.rightToLeft,
              );
            },
          ),
        ],
      ),
    );
  }

  String? totalmonth;
  String? dateeee;
  Widget _buildMyPlanSection(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final u = usercontroller.userData.value!;
    if (u.planDetail != null) {
      if (u.planDetail!.expiryDate != null) {
        DateTime startDate = DateTime.parse(u.planDetail!.startDate.toString());

        DateTime expiryDate = DateTime.parse(
          u.planDetail!.expiryDate.toString(),
        );

        int monthDifference =
            (expiryDate.year - startDate.year) * 12 +
            (expiryDate.month - startDate.month);
        totalmonth = monthDifference.toString();
        print("Months: $monthDifference");

        String formattedExpiry = DateFormat("dd MMM yyyy").format(expiryDate);
        dateeee = formattedExpiry;
        print("Formatted Expiry: $formattedExpiry");
      }
    }
    return Container(
      width: w,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/images/Crown.png', height: 25),

              const SizedBox(width: 6),
              Text("My Plan", style: opensansSemiBold.copyWith(fontSize: 16)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(
                    MembershipPlansPage(),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    "Upgrade Now",
                    style: opensansSemiBold.copyWith(
                      color: ColorResources.primarycolor3,

                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _planBox(
                icon: 'assets/images/tag_svgrepo.com.png',
                title: "Plan Name",
                value: u.planDetail == null
                    ? "Free"
                    : "${u.planDetail!.planId!.name}",
                isFirst: true,
                isLast: false,
              ),
              _planBox(
                icon: 'assets/images/plan_svgrepo.com.png',
                title: "Validity",
                value: totalmonth == null ? "Unlimited" : "$totalmonth Months",
                isFirst: false,
                isLast: false,
              ),
              _planBox(
                icon: 'assets/images/time_svgrepo.com.png',
                title: "Due Date",
                value: dateeee == null ? "----" : '$dateeee',
                isFirst: false,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _planBox({
    required String icon,
    required String title,
    required String value,
    required bool isFirst,
    required bool isLast,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(10) : Radius.zero,
            bottomLeft: isFirst ? const Radius.circular(10) : Radius.zero,
            topRight: isLast ? const Radius.circular(10) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(10) : Radius.zero,
          ),
        ),
        child: Column(
          children: [
            Image.asset(icon, height: 25),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: opensansSemiBold.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorResources.primarycolor3,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: opensansSemiBold.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 223, 228),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset('assets/images/Lock.png', height: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Only Premium Members can avail these benefits",
                  style: opensansBold.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/mobile_svgrepo.com.png',
                              height: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '03',
                              style: opensansBold.copyWith(
                                color: ColorResources.primarycolor3,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Contact Viewed",
                          style: opensansSemiBold.copyWith(fontSize: 12.5),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/chat-dots_svgrepo.com.png',
                              height: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '03',
                              style: opensansBold.copyWith(
                                color: ColorResources.primarycolor3,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Chats Initiated",
                          style: opensansMedium.copyWith(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesSection(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                "Your Matches",
                style: opensansSemiBold.copyWith(fontSize: 16),
              ),
              Spacer(),
              Text(
                "View All",
                style: opensansSemiBold.copyWith(
                  color: ColorResources.primarycolor3,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: w * 0.81,
          child: matchC.freeMatches.isEmpty
              ? Center(
                  child: Text(
                    "No Data Found",
                    style: opensansMedium.copyWith(fontSize: 16),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15),
                  itemCount: matchC.freeMatches.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _matchCard(context, matchC.freeMatches[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildpremuimSection(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                "Premium Matches",
                style: opensansSemiBold.copyWith(fontSize: 16),
              ),
              Spacer(),
              Text(
                "View All",
                style: opensansSemiBold.copyWith(
                  color: ColorResources.primarycolor3,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: w * 0.81,
          child: matchC.premiumMatches.isEmpty
              ? Center(
                  child: Text(
                    "No Data Found",
                    style: opensansMedium.copyWith(fontSize: 16),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 15),
                  itemCount: matchC.premiumMatches.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _matchpremiumCard(
                      context,
                      matchC.premiumMatches[index],
                    );
                  },
                ),
        ),
      ],
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

  Widget _matchCard(BuildContext context, MatchUserModel user) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w * 0.55;
    String age = calculateAgeInYears(user.dob);

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                user.photo != null
                    ? "${ApiConstants.imageurl}${user.photo!}"
                    : "",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? '',
                    style: opensansSemiBold.copyWith(fontSize: 15),
                  ),
                  SizedBox(height: 4),

                  Text(
                    "${age} yrs, "
                    "${user.height?.toString() ?? 'N/A'}\", "
                    "${user.religion?.name ?? 'N/A'}, ",
                    // user.locCity!.name ?? 'N/A',
                    style: opensansMedium.copyWith(
                      fontSize: 12.5,
                      color: ColorResources.blackcolor11,
                    ),
                  ),

                  Text(
                    user.occupation == null
                        ? "N/A"
                        : user.occupation!.name ?? "N/A",
                    style: opensansMedium.copyWith(
                      fontSize: 12.5,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.primarycolor3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
              child: Text(
                "Express Interest",
                style: opensansMedium.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchpremiumCard(BuildContext context, MatchUserModel user) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w * 0.55;
    String age = calculateAgeInYears(user.dob);

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                user.photo != null
                    ? "${ApiConstants.imageurl}${user.photo!}"
                    : "",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name}",
                    style: opensansSemiBold.copyWith(fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${age ?? 'N/A'} yrs, "
                    "${user.height?.toString() ?? 'N/A'}\", "
                    "${user.religion?.name ?? 'N/A'}, ",
                    // "${user.city ?? 'N/A'}",
                    maxLines: 1,
                    style: opensansMedium.copyWith(
                      fontSize: 12.5,
                      color: ColorResources.blackcolor11,
                    ),
                  ),

                  Text(
                    user.occupation == null
                        ? "N/A"
                        : user.occupation!.name ?? "N/A",
                    maxLines: 1,
                    style: opensansMedium.copyWith(
                      fontSize: 12.5,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ⭐ Button bilkul bottom stick
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.primarycolor3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
              child: Text(
                "Express Interest",
                style: opensansMedium.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadImageBottomSheet extends StatelessWidget {
  const UploadImageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close Button (top right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Choose From", style: opensansMedium.copyWith(fontSize: 20)),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 30),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/Group 371.png', height: 50),
              Image.asset('assets/images/Group 372.png', height: 50),
            ],
          ),

          const SizedBox(height: 25),

          Text(
            "Few tips to upload pics",
            style: opensansMedium.copyWith(fontSize: 16),
          ),

          const SizedBox(height: 5),

          Text(
            "Avoid the following photos to highlight your profile better",
            style: opensansMedium.copyWith(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          // Tips Row
          Center(
            child: Image.asset('assets/images/Frame 66 2.png', height: 100),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
