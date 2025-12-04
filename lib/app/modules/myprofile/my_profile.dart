import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/membership/membership.dart';
import 'package:vivashri/config/utils/app_constants.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final usercontroller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,

      drawer: CustomAppDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
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

  // ------------------ TOP BAR -----------------------
  Widget _buildTopBar() {
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
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: progressRing(0.4),
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
                        "• ${u.weight}, ${u.height}”   • ${u.religion!.name}   • ${u.subCaste!.name}   • ${u.manglik}  • ${u.highestDegree!.name}",
                        style: opensansSemiBold.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),

                      Text(
                        "• ${u.occupation!.name}   • Earns ₹${u.annualIncome} p.a ",
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
              Image.asset('assets/images/Group 377.png', height: 35),
              const SizedBox(width: 10),
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

  Widget progressRing(double progress) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Outer white circle
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              value: progress, // 0.4 = 40%
              strokeWidth: 2,
              color: Colors.pink, // Pink arc
              backgroundColor: Colors.grey.shade300, // Light gray arc
            ),
          ),

          // Center Text
          Text(
            "${(progress * 100).toInt()}%",
            style: opensansMedium.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
            ["Name", "${u.name}", "Height Range", "${u.height}"],
            [
              "Marital Status",
              "${u.maritalStatus!.name}",
              "Complexion",
              "${u.complexion!.name}",
            ],
            [
              "Health Information",
              "${u.healthInformation}",
              "Manglik Status",
              "${u.manglik}",
            ],
            ["Blood Group", "${u.bloodGroup}", "Weight", "${u.weight}"],
            ["About", "${u.about}", "Disability", "${u.disability}"],
          ],
          onTap: () {},
        ),

        profileSectionCard(
          title: "Horoscope Details",
          fields: [
            ["Date of Birth", formattedDob, "Time of Birth", "-"],
            [
              "State of Birth",
              "${u.birthState!.name}",
              "City of Birth",
              "${u.birthCity!.name}",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Education Details",
          fields: [
            ["Highest Qualification", "${u.highestDegree!.name}", "", ""],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Professional Details",
          fields: [
            [
              "Annual Income",
              "${u.annualIncome}",
              "Working With",
              "${u.workingWith!.name}",
            ],
            [
              "Occupation",
              "${u.occupation!.name}",
              "Organization",
              "${u.organizationName}",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Family Details",
          fields: [
            [
              "Family Type",
              "${u.familyType}",
              "Family Value",
              "${u.familyValue}",
            ],
            ["Sister", "${u.noOfSister}", "Brother", "${u.noOfBrother}"],
            [
              "Sister in Law",
              "${u.noOfSisterInLaw}",
              "Brother in Law",
              "${u.noOfBrotherInLaw}",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Location Details",
          fields: [
            [
              "Nationality",
              "${u.locNationality!.name}",
              "Residence Type",
              "${u.locResidenceType}",
            ],
            [
              "Permanent House Type",
              "${u.locHouseType}",
              "Permanent State",
              "${u.locState!.name}",
            ],
            [
              "Permanent City",
              "${u.locCity!.name}",
              "Permanent Pin/Zip Code",
              "${u.locPincode}",
            ],

            [
              "Temporary State",
              "${u.locTempState!.name}",
              "Temporary City",
              "${u.locTempCity!.name}",
            ],

            [
              "References Relation",
              "${u.locRelation}",
              "References Name",
              "${u.locRelationName}",
            ],
            [
              "References Email Id",
              "${u.locRelationEmail}",
              "References Mobile No.",
              "${u.locRelationMobile}",
            ],
          ],
          onTap: () {},
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
          onTap: () {},
        ),
        profileSectionCard(
          title: "Hobbies & Interests",
          fields: [
            ["Hobbies", hobbiesText, "", ""],
          ],
          onTap: () {},
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

  // -------- FIELD COLUMN (Label + Value) --------
  Widget _fieldColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: opensansSemiBold.copyWith(fontSize: 13.5)),

          Text(value, style: opensansMedium.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _partnerDetailsSection() {
    final u = usercontroller.userData.value!;
    return Column(
      children: [
        _sectionBox(
          title: "Partner’s Basic Info",
          fields: [
            [
              "Age",
              "${u.partnerAgeFrom}",
              "Body Weight",
              "${u.partnerWeightFrom}",
            ],
            [
              "Marital Status",
              "${u.partnerMaritalStatus}",
              "Height Range",
              "${u.partnerHeightFrom}",
            ],
            [
              "Languages Known",
              "${u.partnerLanguage!.name}",
              "Complexion",
              "${u.partnerComplexion!.name}",
            ],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Location Details",
          fields: [
            [
              "Nationality",
              "${u.partnerCountry!.name}",
              "State",
              "${u.partnerState!.name}",
            ],
            ["City", "${u.partnerCity!.name}", "", ""],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Education  & Career",
          fields: [
            ["Highest Qualification", "${u.partnerEducation!.name}", "", ""],
            [
              "Professional Qualification",
              "${u.partnerProfessionalQualification!.name}",
              "Occupation",
              "${u.partnerOccupation!.name}",
            ],

            [
              "Annual Income Range",
              "${u.partnerIncomeFrom}",
              "Work As",
              "${u.partnerWorkingAs!.name}",
            ],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Other Details",
          fields: [
            [
              "Diet Preference",
              "${u.diet!.name}",
              "Drinking Habit",
              "${u.partnerDrinking}",
            ],
            [
              "Smoking Habit",
              "${u.partnerSmoking}",
              "Profile Managed",
              "${u.partnerManagedBy}",
            ],
          ],
          onTap: () {},
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
