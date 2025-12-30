import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/membership/membership.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/contactedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/editbasicdetails.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/editphotes.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/educationedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/familydetailsedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/hobiesedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/horoscopedetails.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/locationedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/partnereditbasic.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/partnereduedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/partnerlocationedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/partnerotheredit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/partnerreliitonedit.dart';
import 'package:vivashri/app/modules/myprofile/editprofile.dart/professionaldetails.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:vivashri/widgets/image_view.dart';

class MyProfielScreen extends StatefulWidget {
  const MyProfielScreen({super.key});

  @override
  State<MyProfielScreen> createState() => _MyProfielScreenState();
}

class _MyProfielScreenState extends State<MyProfielScreen> {
  int tabIndex = 0;
  String? profileid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final usercontroller = Get.put(UserDetailController());
  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
    checkpercentagecontroller.checkProfileComplete(profileid.toString());
    // checkcontroller.checkProfileComplete(profileid.toString());
  }

  final checkpercentagecontroller = Get.put(CheckProfileController());

  final checkcontroller = Get.put(CheckProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileapi();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      //  key: _scaffoldKey,

      // drawer: CustomAppDrawer(),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: ColorResources.primarycolor2,
                      onRefresh: () async {
                        profileapi();
                        checkcontroller.checkProfileComplete(
                          profileid.toString(),
                        );
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            _profileHeader(w),
                            _profileTabs(),
                            SizedBox(height: 8),

                            if (tabIndex == 0) _myDetailsSection(),
                            if (tabIndex == 1) _partnerDetailsSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// STATUS BAR COLOR
            Container(
              height: statusBarHeight,
              width: double.infinity,
              color: ColorResources.primarycolor2,
            ),
          ],
        );
      }),

      // body: Stack(
      //   children: [
      //     SafeArea(
      //       child: Column(
      //         children: [
      //           _buildTopBar(),
      //           Expanded(
      //             child: RefreshIndicator(
      //               color: Colors.white,
      //               backgroundColor: ColorResources.primarycolor2,
      //               onRefresh: () async {
      //                 profileapi();
      //               },
      //               child: SingleChildScrollView(
      //                 padding: const EdgeInsets.only(bottom: 20),
      //                 child: Column(
      //                   children: [
      //                     _profileHeader(w),
      //                     _profileTabs(),
      //                     SizedBox(height: 8),
      //                     if (tabIndex == 0) _myDetailsSection(),
      //                     if (tabIndex == 1) _partnerDetailsSection(),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Container(
      //       height: statusBarHeight,
      //       width: double.infinity,
      //       color: ColorResources.primarycolor2,
      //     ),
      //   ],
      // ),
    );
  }

  // ------------------ TOP BAR -----------------------
  Widget _buildTopBar() {
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
                  size: 24,
                ),
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         _scaffoldKey.currentState?.openDrawer();
          //       },
          //       child: Icon(
          //         Icons.menu,
          //         color: ColorResources.blackcolor11,
          //         size: 28,
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 245, 242),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Profile",
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

  List<String> photos = [];

  void buildPhotoList(dynamic u) {
    List<String?> raw = [u.photo, u.photo1, u.photo2, u.photo3, u.photo4];

    photos = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  Widget _profileHeader(double w) {
    final u = usercontroller.userData.value!;
    String myage = calculateAgeInYears(u.dob.toString());

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
              bottom: Radius.circular(10),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 11,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${ApiConstants.imageurl}${u.photo}",

                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        String gender = u.gender.toString();

                        if (gender == "Male") {
                          return Image.asset(
                            "assets/images/no-image-male2.jpg",
                            fit: BoxFit.contain,
                          );
                        } else if (gender == "Female") {
                          return Image.asset(
                            "assets/images/no-image-female2.jpg",
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
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          buildPhotoList(u);
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => PhotoSliderDialog(photos: photos),
                          );
                        },
                        child: Image.asset(
                          'assets/images/imagecount.png',
                          height: 45,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (u.height == null) {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.weight == null) {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.manglik == null || u.manglik == "") {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.about!.isEmpty) {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.complexion == null) {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.disability == null ||
                              u.disability == "") {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.healthInformation == null ||
                              u.healthInformation == "") {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.bloodGroup == null ||
                              u.bloodGroup == "") {
                            Get.to(
                              EditBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.birthCity == null) {
                            Get.to(
                              HoroscropeEdit(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.birthState == null) {
                            Get.to(
                              HoroscropeEdit(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.contactNo == null) {
                            Get.to(
                              EditContectScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.contactEmail == null) {
                            Get.to(
                              EditContectScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          }
                          //
                          else if (u.religion == null) {
                          } else if (u.caste == null) {
                          } else if (u.locNationality == null) {
                            Get.to(
                              EditLocationScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.locCity == null) {
                            Get.to(
                              EditLocationScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          }
                          //
                          else if (u.locState == null) {
                            Get.to(
                              EditLocationScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.locPincode == null) {
                            Get.to(
                              EditLocationScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.familyType == null) {
                            Get.to(
                              EditFamilyDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.familyValue == null) {
                            Get.to(
                              EditFamilyDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.noOfSister == null) {
                            Get.to(
                              EditFamilyDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.noOfBrother == null) {
                            Get.to(
                              EditFamilyDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.highestDegree == null) {
                            Get.to(
                              EditEducationDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.annualIncome == null) {
                            Get.to(
                              EditProfessionalDetails(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          }
                          //
                          else if (u.workingWith == null) {
                            Get.to(
                              EditProfessionalDetails(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.occupation == null) {
                            Get.to(
                              EditProfessionalDetails(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.organizationName == null) {
                            Get.to(
                              EditProfessionalDetails(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.hobbies.isEmpty) {
                            Get.to(
                              EditHobbies(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          }
                          //
                          else if (u.partnerAgeFrom == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerAgeTo == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerHeightFrom == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerHeightTo == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerWeightFrom == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerWeightTo == null) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerMaritalStatus.isEmpty) {
                            Get.to(
                              EditPartnerBasicDetailsScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerCountry == null) {
                            Get.to(
                              EditPartnerlocation(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerCity == null) {
                            Get.to(
                              EditPartnerlocation(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerState == null) {
                            Get.to(
                              EditPartnerlocation(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          }
                          //
                          else if (u.partnerEducation == null) {
                            Get.to(
                              Editpartnereduction(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerOccupation == null) {
                            Get.to(
                              Editpartnereduction(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerIncomeFrom == null) {
                            Get.to(
                              Editpartnereduction(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerIncomeTo == null) {
                            Get.to(
                              Editpartnereduction(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerWorkingAs == null) {
                            Get.to(
                              Editpartnereduction(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerDiet == null) {
                            Get.to(
                              Editpartnereditother(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerDrinking == null) {
                            Get.to(
                              Editpartnereditother(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerSmoking == null) {
                            Get.to(
                              Editpartnereditother(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else if (u.partnerManagedBy == null) {
                            Get.to(
                              Editpartnereditother(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else {}
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: (progressRing(
                            checkcontroller.profileStatus.value!.completion,
                          )),
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
                          _darkTag("Profile managed by ${u.profileFor!.name}"),
                          const SizedBox(width: 6),
                          _darkTagonline("Online"),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Text(
                            "${u.name} ",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            "(ID: ${u.profileId})",
                            style: opensansSemiBold.copyWith(
                              color: ColorResources.primarycolor2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                    Text(
  "• $myage, ${(() {
    final raw = u.height;
    if (raw == null || raw.toString().isEmpty) return "";

    final value = double.tryParse(raw.toString());
    if (value == null) return raw.toString();

    final ft = value.floor();
    final inch = ((value - ft) * 12).round();

    return "$ft ft $inch in";
  })()}   "
  "• ${u.religion?.name ?? ''}   "
  "• ${u.subCaste?.name ?? ''}   "
  "• ${u.manglik ?? ''}   "
  "• ${u.highestDegree?.name ?? ''}",
  style: opensansSemiBold.copyWith(
    color: Colors.white,
    fontSize: 11,
  ),
),

                      u.occupation == null || u.annualIncome == null
                          ? SizedBox()
                          : Text(
  "• ${u.occupation!.name}   • Earns ₹${(() {
    final income = u.annualIncome;
    if (income == null || income.toString().isEmpty) return "0";

    final str = income.toString();

    // Range case (e.g. 700000-1000000)
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

    // Single value
    final v = int.tryParse(str) ?? 0;
    if (v >= 10000000) {
      return "${(v / 10000000).toStringAsFixed(1).replaceAll('.0', '')} Cr";
    } else if (v >= 100000) {
      return "${(v / 100000).toStringAsFixed(1).replaceAll('.0', '')} Lakh";
    } else if (v >= 1000) {
      return "${(v / 1000).toStringAsFixed(0)} K";
    }
    return v.toString();
  })()} p.a",
  style: opensansSemiBold.copyWith(
    color: Colors.white,
    fontSize: 11,
  ),
),

                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                child: Image.asset('assets/images/Group 377.png', height: 35),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.to(
                    MembershipPlansPage(hidenav: "Hide",),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset(
                  'assets/images/viewprofile 2.png',
                  height: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String calculateAgeInYears(dynamic dobString) {
    if (dobString == null) return "N/A";

    if (dobString is int) {
      try {
        DateTime dob = (dobString.toString().length > 10)
            ? DateTime.fromMillisecondsSinceEpoch(dobString)
            : DateTime.fromMillisecondsSinceEpoch(dobString * 1000);

        return _getYearsOnly(dob);
      } catch (e) {
        return "N/A";
      }
    }

    // If DOB is already DateTime
    if (dobString is DateTime) {
      return _getYearsOnly(dobString);
    }

    // If DOB is String
    if (dobString is String) {
      if (dobString.trim().isEmpty) return "N/A";

      try {
        // First try normal parse
        DateTime dob = DateTime.parse(dobString);
        return _getYearsOnly(dob);
      } catch (e) {
        try {
          // Try manual split
          String onlyDate = dobString.split("T")[0];
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

    return "N/A";
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

  Widget progressRing(String percentText) {
    double percentValue = 0.0;

    try {
      percentValue = (double.parse(percentText.replaceAll("%", "")) / 100)
          .clamp(0.0, 1.0);
    } catch (e) {
      percentValue = 0.0;
    }

    // If 100% -> green, else pink
    Color ringColor = percentValue == 1.0 ? Colors.green : Colors.pink;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 35,
            height: 35,
            child: CircularProgressIndicator(
              value: percentValue,
              strokeWidth: 3,
              color: ringColor,
              backgroundColor: Colors.grey.shade300,
            ),
          ),

          Text(
            percentText,
            style: opensansBold.copyWith(fontSize: 9, color: Colors.black),
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

  // ------------------ TAB SWITCH -----------------------
  Widget _profileTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabItem("My Details", 0),
        const SizedBox(width: 20),
        _tabItem("Partner's Details", 1),
      ],
    );
  }

  Widget _tabItem(String t, int index) {
    bool active = tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => tabIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? ColorResources.primarycolor3 : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          t,
          style: opensansSemiBold.copyWith(
            fontSize: 15,

            color: active ? ColorResources.primarycolor3 : Colors.black87,
          ),
        ),
      ),
    );
  }

  String formatDob(String dob) {
    if (dob.isEmpty) return "";
    try {
      DateTime date = DateTime.parse(dob);
      return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year}";
    } catch (e) {
      return "";
    }
  }

  String safeFormatTime(String? dob) {
    if (dob == null || dob.isEmpty) return "";

    try {
      DateTime dt = DateTime.parse(dob); // <-- NO .toLocal()

      int hour = dt.hour;
      int minute = dt.minute;

      String ampm = hour >= 12 ? "PM" : "AM";
      int displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm";
    } catch (e) {
      return "";
    }
  }

  // ------------------ ALL DETAILS SECTION -------------------
  Widget _myDetailsSection() {
    final u = usercontroller.userData.value!;
    String formattedDob = formatDob(u.dob.toString());
    final hobbiesText = u.hobbies.map((e) => e.name).join(", ");

    return Column(
      children: [
        profileSectionCard(
          title: "Basic Details",
          fields: [
            [
              "Create Profile For",
              "${u.profileFor!.name}",
              "Gender",
              "${u.gender}",
            ],
            [
              "Name",
              (u.name == null || u.name.toString().isEmpty)
                  ? "N/A"
                  : "${u.name}",

              "Height Range",
              (u.height == null || u.height.toString().isEmpty)
                  ? "N/A"
                  : (() {
                      double h = double.tryParse(u.height.toString()) ?? 0;
                      int feet = h.floor();
                      int inches = ((h - feet) * 12).round();
                      return "$feet ft $inches in";
                    })(),
            ],

            [
              "Marital Status",
              (u.maritalStatus?.name ?? 'N/A'),
              "Complexion",
              (u.complexion?.name ?? 'N/A'),
            ],

            [
              "Health Information",
              (u.healthInformation == null ||
                      u.healthInformation.toString().isEmpty)
                  ? "N/A"
                  : "${u.healthInformation}",

              "Manglik Status",
              (u.manglik == null || u.manglik.toString().isEmpty)
                  ? "N/A"
                  : "${u.manglik}",
            ],

            [
              "Blood Group",
              (u.bloodGroup == null || u.bloodGroup.toString().isEmpty)
                  ? "N/A"
                  : "${u.bloodGroup}",

              "Weight",
              (u.weight == null || u.weight.toString().isEmpty)
                  ? "N/A"
                  : "${double.tryParse(u.weight.toString()) ?? u.weight} kg",
            ],

            [
              "About",
              (u.about == null || u.about.toString().isEmpty)
                  ? "N/A"
                  : "${u.about}",

              "Disability",
              (u.disability == null || u.disability.toString().isEmpty)
                  ? "N/A"
                  : "${u.disability}",
            ],
          ],
          onTap: () {
            Get.to(
              EditBasicDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),

        profileSectionCard(
          title: "Horoscope Details",
          fields: [
            [
              "Date of Birth",
              formattedDob,
              "Time of Birth",
              (safeFormatTime(u.dob.toString())),
            ],
            [
              "State of Birth",
              (u.birthState?.name ?? 'N/A'),
              "City of Birth",
              (u.birthCity?.name ?? 'N/A'),
            ],
          ],
          onTap: () {
            Get.to(
              HoroscropeEdit(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        profileSectionCard(
          title: "Education Details",
          fields: [
            ["Highest Qualification", (u.highestDegree?.name ?? ''), "", ""],
          ],
          onTap: () {
            Get.to(
              EditEducationDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),

        profileSectionCard(
          title: "Professional Details",
          fields: [
            [
              "Annual Income",
              (u.annualIncome == null || u.annualIncome.toString().isEmpty)
                  ? "N/A"
                  : (() {
                      double income =
                          double.tryParse(u.annualIncome.toString()) ?? 0;

                      if (income >= 10000000) {
                        return "${(income / 10000000).toStringAsFixed(1)} Cr";
                      } else if (income >= 100000) {
                        return "${(income / 100000).round()} Lakh";
                      } else if (income >= 1000) {
                        return "${(income / 1000).round()}k";
                      } else {
                        return income.toStringAsFixed(0);
                      }
                    })(),

              "Working With",
              u.workingWith == null ? "N/A" : (u.workingWith!.name ?? 'N/A'),
            ],
            [
              "Occupation",
              u.occupation == null || u.occupation!.name == null
                  ? "N/A"
                  : "${u.occupation!.name}",

              "Organization",
              (u.organizationName == null ||
                      u.organizationName.toString().isEmpty)
                  ? "N/A"
                  : "${u.organizationName}",
            ],
          ],
          onTap: () {
            Get.to(
              EditProfessionalDetails(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        profileSectionCard(
          title: "Family Details",
          fields: [
            [
              "Family Type",
              (u.familyType == null || u.familyType.toString().isEmpty)
                  ? "N/A"
                  : "${u.familyType}",

              "Family Value",
              (u.familyValue == null || u.familyValue.toString().isEmpty)
                  ? "N/A"
                  : "${u.familyValue}",
            ],

            [
              "Sister",
              (u.noOfSister == null || u.noOfSister.toString().isEmpty)
                  ? "N/A"
                  : "${u.noOfSister}",

              "Brother",
              (u.noOfBrother == null || u.noOfBrother.toString().isEmpty)
                  ? "N/A"
                  : "${u.noOfBrother}",
            ],

            [
              "Sister in Law",
              (u.noOfSisterInLaw == null ||
                      u.noOfSisterInLaw.toString().isEmpty)
                  ? "N/A"
                  : "${u.noOfSisterInLaw}",

              "Brother in Law",
              (u.noOfBrotherInLaw == null ||
                      u.noOfBrotherInLaw.toString().isEmpty)
                  ? "N/A"
                  : "${u.noOfBrotherInLaw}",
            ],
          ],
          onTap: () {
            Get.to(
              EditFamilyDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        profileSectionCard(
          title: "Location Details",
          fields: [
            [
              "Nationality",
              u.locNationality == null || u.locNationality!.name == null
                  ? "N/A"
                  : "${u.locNationality!.name}",

              "Residence Type",
              (u.locResidenceType == null ||
                      u.locResidenceType.toString().isEmpty)
                  ? "N/A"
                  : "${u.locResidenceType}",
            ],

            [
              "Permanent House Type",
              (u.locHouseType == null || u.locHouseType.toString().isEmpty)
                  ? "N/A"
                  : "${u.locHouseType}",

              "Permanent State",
              u.locState == null || u.locState!.name == null
                  ? "N/A"
                  : "${u.locState!.name}",
            ],

            [
              "Permanent City",
              u.locCity == null || u.locCity!.name == null
                  ? "N/A"
                  : "${u.locCity!.name}",

              "Permanent Pin/Zip Code",
              (u.locPincode == null || u.locPincode.toString().isEmpty)
                  ? "N/A"
                  : "${u.locPincode}",
            ],

            [
              "Temporary State",
              u.locTempState == null ? "N/A" : "${u.locTempState!.name}",
              "Temporary City",
              u.locTempCity == null ? "N/A" : "${u.locTempCity!.name}",
            ],

            [
              "References Relation",
              (u.locRelation == null || u.locRelation.toString().isEmpty)
                  ? "N/A"
                  : "${u.locRelation}",

              "References Name",
              (u.locRelationName == null ||
                      u.locRelationName.toString().isEmpty)
                  ? "N/A"
                  : "${u.locRelationName}",
            ],

            [
              "References Email Id",
              (u.locRelationEmail == null ||
                      u.locRelationEmail.toString().isEmpty)
                  ? "N/A"
                  : "${u.locRelationEmail}",

              "References Mobile No.",
              (u.locRelationMobile == null ||
                      u.locRelationMobile.toString().isEmpty)
                  ? "N/A"
                  : "${u.locRelationMobile}",
            ],
          ],
          onTap: () {
            Get.to(
              EditLocationScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        profileSectionCard(
          title: "Contact Details",
          fields: [
            [
              "Contact Number",
              "${u.mobile}",
              "Contact Email",
              "${u.contactEmail}",
            ],
            ["Instagram Id", "${u.instagram}", "Facebook Id", "${u.facebook}"],
          ],
          onTap: () {
            Get.to(
              EditContectScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        profileSectionCard(
          title: "Hobbies & Interests",
          fields: [
            ["Hobbies", hobbiesText, "", ""],
          ],
          onTap: () {
            Get.to(
              EditHobbies(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
      ],
    );
  }

  Widget profileSectionCard({
    required String title,
    required List<List<String>> fields,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE9FB), Color(0xFFFFF8ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + EDIT ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: opensansSemiBold.copyWith(
                    fontSize: 17,

                    color: ColorResources.primarycolor4,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Image.asset('assets/images/Frame 62.png', height: 18),
                ),
              ],
            ),
            const SizedBox(height: 5),

            Container(
              width: double.infinity,
              height: 1,
              child: CustomPaint(painter: DottedLinePainter()),
            ),

            const SizedBox(height: 10),

            Wrap(
              runSpacing: 16,
              children: fields.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _fieldColumn(row[0], row[1]),
                    const SizedBox(width: 20),
                    row.length > 2
                        ? _fieldColumn(row[2], row[3])
                        : const SizedBox(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // -------- FIELD COLUMN (Label + Value) --------
  Widget _fieldColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: opensansSemiBold.copyWith(fontSize: 14)),

          Text(value, style: opensansMedium.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _partnerDetailsSection() {
    final u = usercontroller.userData.value!;
    final partnermatiral = u.partnerMaritalStatus
        .map((e) => e.name) // name extract
        .join(", ");

    return Column(
      children: [
        _sectionBox(
          title: "Partner’s Basic Info",
          fields: [
            [
              "Age",
              (u.partnerAgeFrom == null || u.partnerAgeTo == null)
                  ? "N/A"
                  : "${u.partnerAgeFrom}-${u.partnerAgeTo}",

              "Body Weight",
              (u.partnerWeightFrom == null ||
                      u.partnerWeightTo == null ||
                      u.partnerWeightFrom.toString().isEmpty ||
                      u.partnerWeightTo.toString().isEmpty)
                  ? "N/A"
                  : "${u.partnerWeightFrom} kg - ${u.partnerWeightTo} kg",
            ],

            [
              "Marital Status",
              (partnermatiral.isEmpty) ? "N/A" : partnermatiral,

              "Height Range",
              (u.partnerHeightFrom == null ||
                      u.partnerHeightFrom.toString().isEmpty)
                  ? "N/A"
                  : (() {
                      double h =
                          double.tryParse(u.partnerHeightFrom.toString()) ?? 0;
                      int feet = h.floor();
                      int inches = ((h - feet) * 12).round();
                      return "$feet ft $inches in";
                    })(),
            ],

            [
              "Languages Known",
              u.partnerLanguage == null ? "N/A" : "${u.partnerLanguage!.name}",
              "Complexion",
              u.partnerComplexion == null
                  ? "N/A"
                  : "${u.partnerComplexion!.name}",
            ],
          ],
          onTap: () {
            Get.to(
              EditPartnerBasicDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        _sectionBox(
          title: "Partner’s Location Details",
          fields: [
            [
              "Nationality",
              u.partnerCountry == null ? "N/A" : "${u.partnerCountry!.name}",
              "State",
              u.partnerState == null ? "N/A" : "${u.partnerState!.name}",
            ],
            [
              "City",
              u.partnerCity == null ? "N/A" : "${u.partnerCity!.name}",
              "",
              "",
            ],
          ],
          onTap: () {
            Get.to(
              EditPartnerlocation(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        _sectionBox(
          title: "Partner’s Education  & Career",
          fields: [
            [
              "Highest Qualification",
              u.partnerEducation == null
                  ? "N/A"
                  : "${u.partnerEducation!.name}",
              "",
              "",
            ],
            [
              "Professional Qualification",
              u.partnerProfessionalQualification == null
                  ? "N/A"
                  : "${u.partnerProfessionalQualification!.name}",
              "Occupation",
              u.partnerOccupation == null
                  ? "N/A"
                  : "${u.partnerOccupation!.name}",
            ],

            [
              "Annual Income Range",
              (u.partnerIncomeFrom == null ||
                      u.partnerIncomeTo == null ||
                      u.partnerIncomeFrom.toString().isEmpty ||
                      u.partnerIncomeTo.toString().isEmpty)
                  ? "N/A"
                  : (() {
                      String formatIncome(dynamic val) {
                        double income = double.tryParse(val.toString()) ?? 0;

                        if (income >= 10000000) {
                          return "${(income / 10000000).toStringAsFixed(1)} Cr";
                        } else if (income >= 100000) {
                          return "${(income / 100000).round()} Lakh";
                        } else if (income >= 1000) {
                          return "${(income / 1000).round()}k";
                        } else {
                          return income.toStringAsFixed(0);
                        }
                      }

                      return "${formatIncome(u.partnerIncomeFrom)} - ${formatIncome(u.partnerIncomeTo)}";
                    })(),

              "Work As",
              u.partnerWorkingAs == null || u.partnerWorkingAs!.name == null
                  ? "N/A"
                  : "${u.partnerWorkingAs!.name}",
            ],
          ],
          onTap: () {
            Get.to(
              Editpartnereduction(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        _sectionBox(
          title: "Partner’s Other Details",
          fields: [
            [
              "Diet Preference",
              u.partnerDiet == null || u.partnerDiet!.name == null
                  ? "N/A"
                  : "${u.partnerDiet!.name}",

              "Drinking Habit",
              (u.partnerDrinking == null ||
                      u.partnerDrinking.toString().isEmpty)
                  ? "N/A"
                  : "${u.partnerDrinking}",
            ],

            [
              "Smoking Habit",
              (u.partnerSmoking == null || u.partnerSmoking.toString().isEmpty)
                  ? "N/A"
                  : "${u.partnerSmoking}",

              "Profile Managed",
              (u.partnerManagedBy == null ||
                      u.partnerManagedBy.toString().isEmpty)
                  ? "N/A"
                  : "${u.partnerManagedBy}",
            ],
          ],
          onTap: () {
            Get.to(
              Editpartnereditother(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
        _sectionBox(
          title: "Partner’s Religion & Caste",
          fields: [
            [
              "Religion",
              u.partnerReligion == null ? "N/A" : "${u.partnerReligion!.name}",
              "Caste",
              u.partnerCaste == null ? "N/A" : "${u.partnerCaste!.name}",
            ],
            [
              "Subcaste:",
              u.partnerSubCaste == null ? "N/A" : "${u.partnerSubCaste!.name}",
              "Dosh",
              u.partnerDosh == null ? "N/A" : "${u.partnerDosh}",
            ],
          ],
          onTap: () {
            Get.to(
              EditPartnerReligionCasteScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
          },
        ),
      ],
    );
  }

  Widget _sectionBox({
    required String title,
    required List<List<String>> fields,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE9FB), Color(0xFFFFF8ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: opensansSemiBold.copyWith(
                    fontSize: 16,

                    color: ColorResources.primarycolor4,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Image.asset('assets/images/Frame 62.png', height: 18),
                ),
              ],
            ),
            const SizedBox(height: 5),

            Container(
              width: double.infinity,
              height: 1,
              child: CustomPaint(painter: DottedLinePainter()),
            ),

            const SizedBox(height: 10),

            Wrap(
              runSpacing: 16,
              children: fields.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _fieldColumn(row[0], row[1]),
                    const SizedBox(width: 20),
                    row.length > 2
                        ? _fieldColumn(row[2], row[3])
                        : const SizedBox(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
