import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/match/userprofile.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/call_parent/chat/api/apis.dart';
import 'package:vivashri/call_parent/chat/widgets/Snackbar.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/accept_interest.dart';
import 'package:vivashri/data/controller/recived_interst.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:vivashri/widgets/image_view.dart';

class ConnectScreen extends StatefulWidget {
  final int initialIndex;
  const ConnectScreen({super.key, this.initialIndex = 0});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? profileid;
  final usercontroller = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();
    inboxCtrl.fetchInboxData();
    tabController = TabController(
      length: 3,
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(w),
                _buildTabs(),

                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: ColorResources.primarycolor2,
                    color: Colors.white,
                    onRefresh: () async {
                      inboxCtrl.acceptedbyme();
                      inboxCtrl.acceptedbypartner();
                      inboxCtrl.fetchInboxData();
                      inboxCtrl.pendinginboxdata();
                      inboxCtrl.declinedinboxdata();
                    },

                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              _receivedTab(w, h),
                              _acceptedTab(w, h),
                              invitationTabs(w, h),
                            ],
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
              "Connect",
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
              Image.asset('assets/images/bell.png', height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _customTab("Received", 0),
          _customTab("Accepted", 1),
          _customTab("Sent", 2),
        ],
      ),
    );
  }

  Widget _customTab(String title, int index) {
    bool isActive = tabController.index == index;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
        if (index == 0) {
          inboxCtrl.fetchInboxData();
        } else if (index == 1) {
          inboxCtrl.acceptedbyme();
          inboxCtrl.acceptedbypartner();
        } else if (index == 2) {
          inboxCtrl.pendinginboxdata();
          inboxCtrl.declinedinboxdata();
        }
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xfffde4f2) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? Colors.pink : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: opensansSemiBold.copyWith(
            color: isActive
                ? ColorResources.primarycolor3
                : ColorResources.blackhalka,
            fontSize: 13.5,
          ),
        ),
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

  // ---------------- RECEIVED TAB ----------------
  Widget _receivedTab(double w, double h) {
    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.inboxList.isEmpty) {
        return Center(
          child: Text("No Data Found!", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.inboxList.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.inboxList[index];
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
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
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
                                  SizedBox(),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
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
                              Image.asset(
                                'assets/images/Group 285.png',
                                height: 25,
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  'assets/images/imagecount.png',
                                  height: 40,
                                ),
                              ),
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
                                      "${user?.name ?? ""}",
                                      style: opensansMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
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
                              statusController.changeStatus(
                                id: item.id.toString(),
                                status: "Accepted",
                              );
                              tabController.animateTo(1);
                              inboxCtrl.acceptedbyme();
                              inboxCtrl.acceptedbypartner();
                              setState(() {});
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
                              statusController.changeStatus(
                                id: item.id.toString(),
                                status: "Declined",
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

  // ---------------- ACCEPTED TAB ----------------
  Widget _acceptedTab(double w, double h) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          /// ------- TAB BAR -------
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              indicatorColor: ColorResources.primarycolor3,
              labelColor: ColorResources.primarycolor2,
              unselectedLabelColor: ColorResources.blacktext,
              tabs: [
                Tab(text: "Accepted By Me"),
                Tab(text: "Accepted By Partner"),
              ],
            ),
          ),

          const SizedBox(height: 5),

          /// ------- TAB VIEW -------
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                /// ---------------- SENT TAB ----------------
                _acceptedbyme(w, h),

                /// ---------------- RECEIVED TAB ----------------
                _acceptedbypartner(w, h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget invitationTabs(double w, double h) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          /// ------- TAB BAR -------
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              indicatorColor: ColorResources.primarycolor3,
              labelColor: ColorResources.primarycolor2,
              unselectedLabelColor: ColorResources.blacktext,
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Declined"),
              ],
            ),
          ),

          const SizedBox(height: 5),

          /// ------- TAB VIEW -------
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                /// ---------------- SENT TAB ----------------
                _pendingtab(w, h),

                /// ---------------- RECEIVED TAB ----------------
                _declinedtab(w, h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingtab(double w, double h) {
    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.pendingList.isEmpty) {
        return Center(
          child: Text("No Data Found", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.pendingList.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.pendingList[index];
          final user = item.partnerId;
          String age = calculateAgeInYears(user?.dob);
          return GestureDetector(
            onTap: () {
              userbyuserController.fetchUserDetail(user.id.toString());
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
                            child: Image.network(
                              user!.photo != null
                                  ? "${ApiConstants.imageurl}${user.photo!}"
                                  : "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  user.gender == "Male"
                                      ? "assets/images/no-image-male2.jpg"
                                      : "assets/images/no-image-female2.jpg",
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

                        Positioned(
                          top: 12,
                          right: 12,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Group 285.png',
                                height: 25,
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  buildPhotoList(user);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) =>
                                        PhotoSliderDialog(photos: photosmatch),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/images/imagecount.png',
                                    height: 40,
                                  ),
                                ),
                              ),
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
                                      "${user.name ?? ""}",
                                      style: opensansMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      "(ID: ${user.profileId})",
                                      style: opensansMedium.copyWith(
                                        color: ColorResources.primarycolor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "• $age, ${user.height ?? ""}” • ${user.religion?.name ?? ""}  • ${user.subCaste?.name ?? ""}",
                                  style: opensansMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                // DETAILS L2
                                Text(
                                  "• ${user.occupation?.name ?? ""} • Earns ₹${user.annualIncome} Lacs p.a • ${user.locState?.name ?? ""}",
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
                      "Your requested here on ${formatDate(item.createdAt)}",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.primarycolor2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        sentCtrl.cancelrequest(user.id.toString());
                      },
                      child: Image.asset(
                        'assets/images/Group 85.png',
                        height: 35,
                      ),
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

  final sentCtrl = Get.put(SentInterestController());
  List<String> photosblur = [];

  void buildPhotoList22(dynamic u) {
    List<String?> raw = [u.photoBlur];

    photosblur = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  // ---------------- SENT TAB ----------------
  Widget _acceptedbyme(double w, double h) {
    final u = usercontroller.userData.value!;

    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.acceptedbymeList.isEmpty) {
        return Center(
          child: Text("No Data Found", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.acceptedbymeList.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.acceptedbymeList[index];
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 11,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
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
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
                                  SizedBox(),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
                                  SizedBox(),
                              ],
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
                        if (user?.profilesetting == null)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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
                        if (user?.profilesetting?.photoShow == 2)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == null &&
                            user?.photorequestcheck == false)
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
                                      buildPhotoList22(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosblur,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == null &&
                            user?.photorequestcheck == true)
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
                                      buildPhotoList22(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosblur,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == 1 &&
                            user?.photorequestcheck == true)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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
                      "Change your mind?  Cancel Request",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.primarycolor2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/Group 85 (1).png',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Image.asset(
                            'assets/images/viewprofile 4.png',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // print('user id ====> ${user?.profileId}');

                              // if (user?.profileId!.trim().isNotEmpty &&
                              //     user?.profileId != null) {
                              //   await APIs.fetchUser(
                              //     context,
                              //     user!.profileId.toString().trim(),
                              //   );
                              // } else {
                              //   Dialogs.showSnackbar(
                              //     context,
                              //     'Something went wrong while Chat. Please try again later!',
                              //   );
                              // }
                            },
                            child: Image.asset(
                              'assets/images/viewprofile (1).png',
                              height: 50,
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

  Widget _acceptedbypartner(double w, double h) {
    final u = usercontroller.userData.value!;
    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.acceptedbypartnerlist.isEmpty) {
        return Center(
          child: Text("No Data Found", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.acceptedbypartnerlist.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.acceptedbypartnerlist[index];
          final user = item.partnerId;
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
                            child: Stack(
                              children: [
                                if (user?.profilesetting == null)
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.network(
                                      "${ApiConstants.imageurl}${user?.photo}",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          user?.gender == "Male"
                                              ? "assets/images/no-image-male2.jpg"
                                              : "assets/images/no-image-female2.jpg",
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  ),
                                if (user?.profilesetting?.photoShow == 2)
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

                                if (user?.profilesetting?.photoShow == 1 &&
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photoBlur}",

                                    fit: BoxFit.cover,
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
                                  Image.network(
                                    "${ApiConstants.imageurl}${user?.photoBlur}",

                                    fit: BoxFit.cover,
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
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == false)
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
                                    user?.photorequeststatus == null &&
                                    user?.photorequestcheck == true)
                                  SizedBox(),

                                if (user?.profilesetting?.photoShow == 1 &&
                                    user?.photorequeststatus == 1 &&
                                    user?.photorequestcheck == true)
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
                        if (user?.profilesetting == null)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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
                        if (user?.profilesetting?.photoShow == 2)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == null &&
                            user?.photorequestcheck == false)
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
                                      buildPhotoList22(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosblur,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == null &&
                            user?.photorequestcheck == true)
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
                                      buildPhotoList22(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosblur,
                                        ),
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

                        if (user?.profilesetting?.photoShow == 1 &&
                            user?.photorequeststatus == 1 &&
                            user?.photorequestcheck == true)
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
                                      buildPhotoList(user);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => PhotoSliderDialog(
                                          photos: photosmatch,
                                        ),
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

                        // Positioned(
                        //   top: 12,
                        //   right: 12,
                        //   child: Column(
                        //     children: [
                        //       Image.asset(
                        //         'assets/images/Group 285.png',
                        //         height: 25,
                        //       ),
                        //       SizedBox(height: 10),
                        //       GestureDetector(
                        //         onTap: () {
                        //           buildPhotoList(user);
                        //           showDialog(
                        //             context: context,
                        //             barrierDismissible: true,
                        //             builder: (_) =>
                        //                 PhotoSliderDialog(photos: photosmatch),
                        //           );
                        //         },
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //           child: Image.asset(
                        //             'assets/images/imagecount.png',
                        //             height: 40,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                      "Change your mind?  Cancel Request",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.primarycolor2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/Group 85 (1).png',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Image.asset(
                            'assets/images/viewprofile 4.png',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Image.asset(
                            'assets/images/viewprofile (1).png',
                            height: 50,
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

  // ---------------- SENT TAB ----------------
  Widget _declinedtab(double w, double h) {
    return Obx(() {
      if (inboxCtrl.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: ColorResources.primarycolor2),
        );
      }

      if (inboxCtrl.declinedList.isEmpty) {
        return Center(
          child: Text("No Data Found", style: opensansSemiBold.copyWith()),
        );
      }

      return ListView.builder(
        itemCount: inboxCtrl.declinedList.length,
        itemBuilder: (context, index) {
          final item = inboxCtrl.declinedList[index];
          final user = item.partnerId;
          String age = calculateAgeInYears(user?.dob);
          return GestureDetector(
            onTap: () {
              userbyuserController.fetchUserDetail(user.id.toString());
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
                            child: Image.network(
                              user!.photo != null
                                  ? "${ApiConstants.imageurl}${user.photo!}"
                                  : "",
                              fit: BoxFit.cover,
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
                              Image.asset(
                                'assets/images/Group 285.png',
                                height: 25,
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  buildPhotoList(user);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) =>
                                        PhotoSliderDialog(photos: photosmatch),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/images/imagecount.png',
                                    height: 40,
                                  ),
                                ),
                              ),
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
                                      "${user.name ?? ""}",
                                      style: opensansMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      "(ID: ${user.profileId})",
                                      style: opensansMedium.copyWith(
                                        color: ColorResources.primarycolor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "• $age, ${user.height ?? ""}” • ${user.religion?.name ?? ""}  • ${user.subCaste?.name ?? ""}",
                                  style: opensansMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                // DETAILS L2
                                Text(
                                  "• ${user.occupation?.name ?? ""} • Earns ₹${user.annualIncome} Lacs p.a • ${user.locState?.name ?? ""}",
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
                      "She Declined yor invitation .\nThis member cannot be contacted .",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.primarycolor2,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _connectCard(double w, double h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 11,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/Rectangle 77.png",
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

                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    children: [
                      Image.asset('assets/images/Group 285.png', height: 25),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/imagecount.png',
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),

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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Invitation Received on 10 Sep",
              style: opensansSemiBold.copyWith(
                color: ColorResources.primarycolor2,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset('assets/images/Frame 61.png', height: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Image.asset(
                    'assets/images/viewprofile.png',
                    height: 40,
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
