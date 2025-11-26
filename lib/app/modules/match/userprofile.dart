import 'package:flutter/material.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class UserProfileDetailsPage extends StatefulWidget {
  const UserProfileDetailsPage({super.key});

  @override
  State<UserProfileDetailsPage> createState() => _UserProfileDetailsPageState();
}

class _UserProfileDetailsPageState extends State<UserProfileDetailsPage> {
  final hobbies = [
    {"icon": "assets/images/Vector 2.png", "title": "Dancing"},
    {
      "icon": "assets/images/yoga_svgrepo.com.png",
      "title": "Yoga & Meditation",
    },
    {"icon": "assets/images/food_svgrepo.com.png", "title": "Foodie"},
    {
      "icon": "assets/images/carry-bag-7_svgrepo.com.png",
      "title": "Travelling",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopImageSection(w, h),
                _buildNameSection(),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Age: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "22",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Height: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "5 ft 6 in",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Religion: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "Hindu",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Gender: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "Female",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // -------- Row 3 --------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Manglik Status: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "No",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Marital Status: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "Single",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Location: ",
                              style: opensansBold.copyWith(
                                fontSize: 14,
                                color: ColorResources.blacktext,
                              ),
                              children: [
                                TextSpan(
                                  text: "Bihar, Patna",
                                  style: opensansMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blacktext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Text(
                        "It is a pleasure introducing myself. My perspective towards life is being optimistic yet realistic. I am looking for a life partner who would be my friend and stand by me in every phase of life. Please feel free to connect and know more.",
                        style: opensansMedium.copyWith(
                          fontSize: 14,
                          color: ColorResources.blacktext,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      // ---------------- CONTACT DETAILS ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/call-191_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Contact Details",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),

                      rowSingle("Contact No.", "+91-9875489552"),
                      rowSingle("Email ID", "rupali276@gmail.com"),

                      SizedBox(height: 15),

                      // ---------------- BASIC INFO ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/info_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Basic Info",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),
                      rowTopBottom(
                        "Age / Height",
                        "36 Yrs / 5' 00'' (152 cm)",
                        "Date of Birth",
                        "19 Oct 2025",
                      ),
                      rowTopBottom("Caste", "Sandhu", "Have Children", "No"),
                      rowTopBottom(
                        "Sub Caste",
                        "Khastriya",
                        "Gothra / Gothram",
                        "Khastriya",
                      ),
                      rowTopBottom(
                        "Mother Tongue",
                        "Hindi",
                        "Features",
                        "No Information Available",
                      ),
                      rowTopBottom(
                        "Complexion",
                        "Fair",
                        "Special Cases",
                        "None",
                      ),
                      rowTopBottom(
                        "Blood Group",
                        "B Positive",
                        "Body Type",
                        "Slim",
                      ),
                      rowTopBottom(
                        "Body Weight",
                        "80kg",
                        "Location",
                        "Chandigarh",
                      ),

                      SizedBox(height: 15),

                      // ---------------- BACKGROUND & RELIGIOUS DETAILS ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/temple_svgrepo.com.png',
                            height: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Background and Religious Details",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),

                      rowTopBottom(
                        "Birth Time",
                        "10:15 PM",
                        "Place of Birth",
                        "New Delhi",
                      ),
                      rowTopBottom(
                        "Country of Birth",
                        "India",
                        "Sun Sign",
                        "Virgo/Kanya",
                      ),
                      rowTopBottom(
                        "Nakshatra",
                        "No Information Available",
                        "",
                        "",
                      ),

                      SizedBox(height: 15),

                      // ---------------- LOCATION ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/location_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Location",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),

                      rowTopBottom(
                        "Country Residence",
                        "None",
                        "City",
                        "Chandigarh",
                      ),

                      SizedBox(height: 15),

                      // ---------------- EDUCATION & PROFESSION ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/degree-hat_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Education and Profession",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),

                      rowTopBottom(
                        "Education",
                        "Not Specified",
                        "Job Details",
                        "None",
                      ),
                      rowTopBottom(
                        "Working Status",
                        "None",
                        "Working With",
                        "Aks Websoft",
                      ),
                      rowTopBottom(
                        "Annual Income",
                        "2,60,000",
                        "Specific Degree",
                        "Webdesigner",
                      ),

                      SizedBox(height: 15),

                      // ---------------- FAMILY DETAILS ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/team_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Family Details",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),

                      rowTopBottom(
                        "Family Status",
                        "Not Specified",
                        "Family Values",
                        "None",
                      ),
                      rowTopBottom("Father", "Retired", "Mother", "Housewife"),
                      rowTopBottom(
                        "Family Type",
                        "Joint",
                        "Native Place",
                        "None",
                      ),
                      rowTopBottom(
                        "No of Brothers",
                        "01",
                        "No of Sisters",
                        "01",
                      ),

                      SizedBox(height: 15),

                      // ---------------- LIFESTYLE ----------------
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/party-horn_svgrepo.com.png',
                            height: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Lifestyle, Interests and more",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),

                      rowTopBottom("Take Hard Drinks", "No", "Smoking", "No"),
                      rowTopBottom(
                        "Living Situation",
                        "None",
                        "House Ownership",
                        "None",
                      ),
                      rowTopBottom("Eating Habit", "None", "", ""),
                    ],
                  ),
                ),
                buildHobbiesSection(),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/user-search-alt-1_svgrepo.com.png',
                            height: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Partner Preference",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              color: ColorResources.primarycolor3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Her Expectations",
                            style: opensansMedium.copyWith(fontSize: 14),
                          ),
                          Text(
                            "Your Match",
                            style: opensansMedium.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/imageback.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              "Match: 10,  Unmatched: 10",
                              style: opensansMedium.copyWith(
                                color: ColorResources.primarycolor3,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/image 6.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                preferenceRow(
                  leftKey: "Age",
                  leftValue: "20 to 25",
                  rightKey: "Age",
                  rightValue: "20 to 25",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Height",
                  leftValue: "5' 00'' (152 cm)",
                  rightKey: "Height",
                  rightValue: "5' 00'' (152 cm)",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Marital Status",
                  leftValue: "Single",
                  rightKey: "Marital Status",
                  rightValue: "Single",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Disability",
                  leftValue: "No",
                  rightKey: "Disability",
                  rightValue: "No",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Religion/Community",
                  leftValue: "Hindu / Lingayat",
                  rightKey: "Religion/Community",
                  rightValue: "Hindu / Lingayat",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Cast",
                  leftValue: "Yadav",
                  rightKey: "Cast",
                  rightValue: "Yadav",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Mother Tongue",
                  leftValue: "Hindi",
                  rightKey: "Mother Tongue",
                  rightValue: "Hindi",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Education",
                  leftValue: "Any",
                  rightKey: "Education",
                  rightValue: "Any",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Occupation",
                  leftValue: "Business",
                  rightKey: "Occupation",
                  rightValue: "Business",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Desired Lifestyle",
                  leftValue: "Any",
                  rightKey: "Desired Lifestyle",
                  rightValue: "Any",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Drink",
                  leftValue: "No",
                  rightKey: "Drink",
                  rightValue: "No",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Gotra",
                  leftValue: "Any",
                  rightKey: "Gotra",
                  rightValue: "Any",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Country",
                  leftValue: "India",
                  rightKey: "Country",
                  rightValue: "India",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "State Living In",
                  leftValue: "Delhi",
                  rightKey: "State Living In",
                  rightValue: "Delhi",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "City Living In",
                  leftValue: "New Delhi",
                  rightKey: "City Living In",
                  rightValue: "New Delhi",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Annual Income",
                  leftValue: "₹ 2 lakhs to 20 lakhs",
                  rightKey: "Annual Income",
                  rightValue: "₹ 2 lakhs to 20 lakhs",
                  isMatch: true,
                ),

                preferenceRow(
                  leftKey: "Diet",
                  leftValue: "Non Vegetarian",
                  rightKey: "Diet",
                  rightValue: "Non Vegetarian",
                  isMatch: false, // mismatch (red icon)
                ),

                preferenceRow(
                  leftKey: "Family Background",
                  leftValue: "Joint",
                  rightKey: "Family Background",
                  rightValue: "Joint",
                  isMatch: true,
                ),

                SizedBox(height: 20),
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

  Widget preferenceRow({
    required String leftKey,
    required String leftValue,
    required String rightKey,
    required String rightValue,
    required bool isMatch,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFFECCE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leftKey,
                    style: opensansMedium.copyWith(
                      fontSize: 13.5,
                      color: ColorResources.blacktext,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    leftValue,
                    style: opensansMedium.copyWith(
                      fontSize: 13,
                      color: ColorResources.blacktext,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 55,
            height: 60,
            decoration: BoxDecoration(color: Color(0xFFFDEAEE)),
            child: Center(
              child: isMatch
                  ? Image.asset(
                      'assets/images/check-circle_svgrepo.com.png',
                      height: 25,
                    )
                  : Image.asset(
                      'assets/images/cross-circle_svgrepo.com.png',
                      height: 20,
                    ),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFFECCE),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rightKey,
                    style: opensansMedium.copyWith(
                      fontSize: 13.5,
                      color: ColorResources.blacktext,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    rightValue,
                    style: opensansMedium.copyWith(
                      fontSize: 13,
                      color: ColorResources.blacktext,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHobbiesSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hobbies", style: opensansMedium.copyWith(fontSize: 16)),
          SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: hobbies.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(item["icon"]!, height: 22, color: Colors.pink),
                    SizedBox(width: 8),
                    Text(
                      item["title"]!,
                      style: opensansMedium.copyWith(
                        fontSize: 14,

                        color: ColorResources.blacktext,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget rowSingle(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key,
                style: opensansMedium.copyWith(
                  fontSize: 14,
                  color: ColorResources.blacktext,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: opensansMedium.copyWith(
                  fontSize: 13,
                  color: ColorResources.blacktext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopImageSection(double w, double h) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 9 / 11,
          child: ClipRRect(
            child: Image.asset(
              "assets/images/Rectangle 77.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),

        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            children: [
              // LEFT SIDE IMAGE
              Image.asset('assets/images/Group 79.png', height: 40),

              Spacer(),

              Image.asset('assets/images/imagecount.png', height: 40),
              SizedBox(width: 20),
              Image.asset('assets/images/toggle-button.png', height: 35),
            ],
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Frame 63.png', height: 40),

              const SizedBox(width: 16),
              Image.asset('assets/images/shortlist.png', height: 45),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowTopBottom(String key1, String val1, String key2, String val2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key1,
                  style: opensansMedium.copyWith(
                    fontSize: 14,
                    color: ColorResources.blacktext,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  val1,
                  style: opensansMedium.copyWith(
                    fontSize: 13,
                    color: ColorResources.blacktext,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          // RIGHT BLOCK
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key2,
                  style: opensansMedium.copyWith(
                    fontSize: 14,
                    color: ColorResources.blacktext,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  val2,
                  style: opensansMedium.copyWith(
                    fontSize: 13,
                    color: ColorResources.blacktext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Rupali Vimal Jha",
                style: opensansMedium.copyWith(fontSize: 18),
              ),
              SizedBox(width: 10),
              Text(
                "(ID: 600155)",
                style: TextStyle(
                  fontSize: 15,
                  color: ColorResources.primarycolor2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.verified, color: Colors.green, size: 18),
            ],
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Text(
                "Profile created by Myself",
                style: opensansMedium.copyWith(
                  color: ColorResources.blackgrey,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 15),
              Image.asset('assets/images/Frame 64.png', height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
