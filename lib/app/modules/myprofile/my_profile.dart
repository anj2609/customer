import 'package:flutter/material.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/drawer.dart';

class MyProfielScreen extends StatefulWidget {
  const MyProfielScreen({super.key});

  @override
  State<MyProfielScreen> createState() => _MyProfielScreenState();
}

class _MyProfielScreenState extends State<MyProfielScreen> {
  int tabIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  // ---------------- PROFILE HEADER --------------------
  Widget _profileHeader(double w) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // const SizedBox(height: 10),
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
                    child: Image.asset(
                      "assets/images/image 6.png",
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
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: progressRing(0.4), // <-- replace
                      ),

                      // Positioned(
                      //   top: 12,
                      //   right: 12,

                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Image.asset(
                      //       'assets/images/imagecount.png',
                      //       height: 40,
                      //     ),
                      //   ),
                      // ),
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
                            "Manoj Kumar Yadav ",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            "(ID: 600155)",
                            style: opensansSemiBold.copyWith(
                              color: ColorResources.primarycolor2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "• 22, 5’ 6”   • Hindu   • Agarwal   • Non Manglik  • MCA",
                        style: opensansSemiBold.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),

                      Text(
                        "• Teacher   • Earns ₹15 Lacs p.a   • Bihar",
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
              Image.asset('assets/images/viewprofile 2.png', height: 35),
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

  // ------------------ ALL DETAILS SECTION -------------------
  Widget _myDetailsSection() {
    return Column(
      children: [
        profileSectionCard(
          title: "Basic Details",
          fields: [
            ["Create Profile For", "Not Mentioned", "Gender", "Not Mentioned"],
            ["Name", "Not Mentioned", "Height Range", "Not Mentioned"],
            ["Marital Status", "Not Mentioned", "Complexion", "Not Mentioned"],
            [
              "Health Information",
              "Not Mentioned",
              "Manglik Status",
              "Not Mentioned",
            ],
            ["Height", "Not Mentioned", "Weight", "Not Mentioned"],
            ["About", "Not Mentioned", "Disability", "Not Mentioned"],
            ["Blood Group", "Not Mentioned", "", ""],
          ],
          onTap: () {},
        ),

        profileSectionCard(
          title: "Horoscope Details",
          fields: [
            [
              "Date of Birth",
              "Not Mentioned",
              "Time of Birth",
              "Not Mentioned",
            ],
            [
              "State of Birth",
              "Not Mentioned",
              "City of Birth",
              "Not Mentioned",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Education Details",
          fields: [
            ["Highest Qualification", "Not Mentioned", "", ""],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Professional Details",
          fields: [
            ["Annual Income", "Not Mentioned", "Working With", "Not Mentioned"],
            ["Occupation", "Not Mentioned", "Organization", "Not Mentioned"],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Family Details",
          fields: [
            ["Family Type", "Not Mentioned", "Family Value", "Not Mentioned"],
            ["Sister", "Not Mentioned", "Brother", "Not Mentioned"],
            [
              "Sister in Law",
              "Not Mentioned",
              "Brother in Law",
              "Not Mentioned",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Location Details",
          fields: [
            ["Nationality", "Not Mentioned", "Residence Type", "Not Mentioned"],
            [
              "Permanent House Type",
              "Not Mentioned",
              "Permanent State",
              "Not Mentioned",
            ],
            [
              "Permanent House Type",
              "Not Mentioned",
              "Permanent State",
              "Not Mentioned",
            ],
            ["Permanent City", "Not Mentioned", "", ""],
            ["Permanent Pin/Zip Code", "Not Mentioned", "", ""],
            [
              "Temporary State",
              "Not Mentioned",
              "Temporary City",
              "Not Mentioned",
            ],
            ["Temporary Pin/Zip Code", "Not Mentioned", "", ""],
            [
              "References Relation",
              "Not Mentioned",
              "References Name",
              "Not Mentioned",
            ],
            [
              "References Email Id",
              "Not Mentioned",
              "References Mobile No.",
              "Not Mentioned",
            ],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Contact Details",
          fields: [
            [
              "Contact Number",
              "Not Mentioned",
              "Contact Email",
              "Not Mentioned",
            ],
            ["Instagram Id", "Not Mentioned", "Facebook Id", "Not Mentioned"],
          ],
          onTap: () {},
        ),
        profileSectionCard(
          title: "Hobbies & Interests",
          fields: [
            ["Hobbies", "Not Mentioned", "", ""],
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
    return Column(
      children: [
        _sectionBox(
          title: "Partner’s Basic Info",
          fields: [
            ["Age", "Not Specified", "Body Weight", "None"],
            ["Marital Status", "Not Specified", "Height Range", "None"],
            ["Languages Known", "Not Specified", "Complexion", "None"],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Location Details",
          fields: [
            ["Nationality", "Not Specified", "State", "None"],
            ["City", "Not Specified", "", ""],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Education  & Career",
          fields: [
            ["Highest Qualification", "Not Specified", "", ""],
            ["Professional Qualification", "Not Specified", "", ""],
            ["Occupation", "Not Specified", "", ""],
            [
              "Annual Income Range",
              "Not Specified",
              "Work As",
              "Not Specified",
            ],
          ],
          onTap: () {},
        ),
        _sectionBox(
          title: "Partner’s Other Details",
          fields: [
            [
              "Diet Preference",
              "Not Specified",
              "Drinking Habit",
              "Not Specified",
            ],
            [
              "Smoking Habit",
              "Not Specified",
              "Profile Managed",
              "Not Specified",
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
