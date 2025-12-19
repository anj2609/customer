import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/modal/user_by_user.dart';
import 'package:vivashri/widgets/image_view.dart';

class UserProfileDetailsPage extends StatefulWidget {
  const UserProfileDetailsPage({super.key});

  @override
  State<UserProfileDetailsPage> createState() => _UserProfileDetailsPageState();
}

class _UserProfileDetailsPageState extends State<UserProfileDetailsPage> {
  final userbyuserController = Get.put(UserbyUserDetailController());
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

  List<String> photosmatch = [];

  void buildPhotoList(dynamic u) {
    List<String?> raw = [u.photo, u.photo1, u.photo2, u.photo3, u.photo4];

    photosmatch = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  List<String> photosmatchblur = [];

  void buildPhotoListblur(dynamic u) {
    List<String?> raw = [u.photoBlur];

    photosmatchblur = raw
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  bool deshboard = true;
  final usercontroller = Get.put(UserDetailController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        deshboard = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final my = usercontroller.userData.value!;
    String myage = calculateAgeInYears(my.dob.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            if (userbyuserController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorResources.primarycolor2,
                ),
              );
            }

            if (userbyuserController.memberData.value == null) {
              return Center(child: Text("No Data Found"));
            }

            final user = userbyuserController.memberData.value!;
            String age = calculateAgeInYears(user.dob);
            final pp = userbyuserController.partnerPreferences.value;
            //}

            return deshboard
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorResources.primarycolor2,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopImageSection(w, h),
                        _buildNameSection(),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 5,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          text: age,
                                          style: opensansSemiBold.copyWith(
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
                                          text: "${user.height ?? ""}",
                                          style: opensansSemiBold.copyWith(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          text: user.religion?.name ?? "",
                                          style: opensansSemiBold.copyWith(
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
                                          text: user.gender ?? "",
                                          style: opensansSemiBold.copyWith(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Marital Status: ",
                                      style: opensansBold.copyWith(
                                        fontSize: 14,
                                        color: ColorResources.blacktext,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: user.maritalStatus!.name ?? "",
                                          style: opensansSemiBold.copyWith(
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
                                      text: "Manglik Status: ",
                                      style: opensansBold.copyWith(
                                        fontSize: 14,
                                        color: ColorResources.blacktext,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: user.manglik ?? "",
                                          style: opensansSemiBold.copyWith(
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
                                          text:
                                              "${user.locState?.name ?? ""}, ${user.locCity?.name ?? ""}",
                                          style: opensansSemiBold.copyWith(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      user.about ?? "",
                                      style: opensansMedium.copyWith(
                                        fontSize: 13,
                                        color: ColorResources.blacktext,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                          ),
                          child: Column(
                            children: [
                              // ---------------- CONTACT DETAILS ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/call-191_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Contact Details",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),

                              rowSingle(
                                "Contact No.",
                                "+91-${user.contactNo ?? "N/A"}",
                              ),
                              rowSingle(
                                "Email ID",
                                (() {
                                  String email = (user.email ?? "").trim();
                                  if (email.isEmpty) email = "N/A";

                                  int showType =
                                      user.profilesetting?.emailShow ?? 2;

                                  bool isPremium = false;
                                  if (my.planDetail != null) {
                                    if (my.planDetail is Map ||
                                        my.planDetail is List) {
                                      isPremium = true;
                                    }
                                  }

                                  String maskEmail(String e) {
                                    if (e.isEmpty || e == "N/A") return "*****";
                                    if (e.length == 1) return "${e[0]}*****";
                                    if (e.length == 2)
                                      return "${e.substring(0, 1)}*****";
                                    return e.substring(0, 2) +
                                        ("*" * (e.length - 2));
                                  }

                                  if (showType == 1)
                                    return maskEmail(email); // always hide
                                  if (showType == 2)
                                    return email; // always show
                                  if (showType == 3)
                                    return isPremium ? email : maskEmail(email);

                                  return email;
                                })(),
                              ),

                              //  rowSingle("Email ID", user.email ?? "N/A"),
                              SizedBox(height: 15),

                              // ---------------- BASIC INFO ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/info_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Basic Info",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),
                              rowTopBottom(
                                "Age / Height",
                                "${age ?? ""} Yrs / ${user.height ?? ""}",

                                "Date of Birth",
                                (() {
                                  DateTime d = DateTime.parse(user.dob!);
                                  return "${d.day.toString().padLeft(2, '0')}-"
                                      "${d.month.toString().padLeft(2, '0')}-"
                                      "${d.year}";
                                })(),
                              ),

                              rowTopBottom(
                                "Caste",
                                user.caste?.name ?? "N/A",
                                "Have Children",
                                "No",
                              ),

                              rowTopBottom(
                                "Sub Caste",
                                user.subCaste?.name ?? "N/A",
                                "Gothra / Gothram",
                                user.gotra?.name ?? "N/A",
                              ),

                              rowTopBottom(
                                "Mother Tongue",
                                user.partnerMotherTongue?.name ?? "",
                                "Complexion",
                                "${user.complexion!.name}",
                              ),

                              rowTopBottom(
                                "Blood Group",
                                user.bloodGroup ?? "N/A",
                                "",
                                "",
                              ),
                              rowTopBottom(
                                "Body Weight",
                                "${user.weight}kg",
                                "Location",
                                user.locState?.name ?? "N/A",
                              ),

                              SizedBox(height: 15),

                              // ---------------- BACKGROUND & RELIGIOUS DETAILS ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/temple_svgrepo.com.png',
                                    height: 17,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Background and Religious Details",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),

                              rowTopBottom(
                                "Birth Time",
                                (() {
                                  DateTime d = DateTime.parse(user.dob ?? "");
                                  return "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
                                })(),
                                "Place of Birth",
                                user.birthCity?.name ?? "",
                              ),

                              // rowTopBottom(
                              //   "Country of Birth",
                              //   "India",
                              //   "Sun Sign",
                              //   "Virgo/Kanya",
                              // ),
                              // rowTopBottom(
                              //   "Nakshatra",
                              //   "No Information Available",
                              //   "",
                              //   "",
                              // ),
                              SizedBox(height: 15),

                              // ---------------- LOCATION ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/location_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Location",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),

                              rowTopBottom(
                                "Country Residence",
                                "India",
                                "City",
                                user.locCity?.name ?? "N/A",
                              ),

                              SizedBox(height: 15),

                              // ---------------- EDUCATION & PROFESSION ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/degree-hat_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Education and Profession",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),

                              rowTopBottom(
                                "Education",
                                user.highestDegree?.name ?? "N/A",
                                "Job Details",
                                user.occupation?.name ?? "N/A",
                              ),
                              rowTopBottom(
                                "Working Status",
                                "None",
                                "Working With",
                                (() {
                                  int workShow =
                                      user.profilesetting?.workWithShow ?? 2;

                                  if (workShow == 1) {
                                    return "***";
                                  }

                                  return user.workingWith?.name ?? "N/A";
                                })(),
                              ),

                              rowTopBottom(
                                "Annual Income",
                                (() {
                                  int incomeShow =
                                      user.profilesetting?.incomeShow ?? 2;

                                  if (incomeShow == 1) {
                                    return "*******";
                                  }

                                  return user.annualIncome ?? "N/A";
                                })(),
                                "Specific Degree",
                                user.highestDegree?.name ?? "N/A",
                              ),

                              SizedBox(height: 15),

                              // ---------------- FAMILY DETAILS ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/team_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Family Details",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),

                              rowTopBottom(
                                "Family Status",
                                "Active",
                                "Family Values",
                                user.familyValue ?? "N/A",
                              ),
                              // rowTopBottom(
                              //   "Father",
                              //   "Retired",
                              //   "Mother",
                              //   "Housewife",
                              // ),
                              rowTopBottom(
                                "Family Type",
                                user.familyType ?? "N/A",
                                "",
                                "",
                              ),
                              rowTopBottom(
                                "No of Brothers",
                                "${user.noOfBrother ?? "N/A"}",
                                "No of Sisters",
                                "${user.noOfSister ?? "N/A"}",
                              ),

                              SizedBox(height: 15),

                              // ---------------- LIFESTYLE ----------------
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/party-horn_svgrepo.com.png',
                                    height: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Lifestyle, Interests and more",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),

                              rowTopBottom(
                                "Smoking",
                                user.partnerSmoking ?? "N/A",
                                "Health Information",
                                user.healthInformation ?? "N/A",
                              ),
                              rowTopBottom(
                                "Diet",
                                user.diet?.name ?? "N/A",
                                "",
                                "",
                              ),
                            ],
                          ),
                        ),
                        buildHobbiesSection(),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 5,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/user-search-alt-1_svgrepo.com.png',
                                    height: 17,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Partner Preference",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 15,
                                      color: ColorResources.primarycolor3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Her Expectations",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Your Match",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: ClipOval(
                                        child: Image.network(
                                          "${ApiConstants.imageurl}${user.photo}",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                String gender = user.gender
                                                    .toString();

                                                if (gender == "Male") {
                                                  return Image.asset(
                                                    "assets/images/9159790.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                } else if (gender == "Female") {
                                                  return Image.asset(
                                                    "assets/images/3232.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Image.asset(
                                                    "assets/images/profilee.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Match: 10,  Unmatched: 10",
                                      style: opensansSemiBold.copyWith(
                                        color: ColorResources.primarycolor3,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: ClipOval(
                                        child: Image.network(
                                          "${ApiConstants.imageurl}${my.photo}",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                String gender = my.gender
                                                    .toString();

                                                if (gender == "Male") {
                                                  return Image.asset(
                                                    "assets/images/9159790.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                } else if (gender == "Female") {
                                                  return Image.asset(
                                                    "assets/images/3232.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Image.asset(
                                                    "assets/images/profilee.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text('${pp?.age?.status}'),
                        SizedBox(height: 12),
                        preferenceRow(
                          leftKey: "Age",
                          leftValue:
                              '${user.partnerAgeFrom ?? ""} to ${user.partnerAgeTo ?? ""}',
                          rightKey: "Age",
                          rightValue: myage,
                          isMatch: pp!.age!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Height",
                          leftValue:
                              "${user.partnerHeightFrom ?? ""} to ${user.partnerHeightTo ?? ""}",
                          rightKey: "Height",
                          rightValue: "${my.height ?? ""}",
                          isMatch: pp.height!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Marital Status",
                          leftValue:
                              (user.partnerMaritalStatus != null &&
                                  user.partnerMaritalStatus is List &&
                                  user.partnerMaritalStatus!.isNotEmpty)
                              ? user.partnerMaritalStatus!
                                    .map((e) => (e?['name'] ?? '').toString())
                                    .where((name) => name.isNotEmpty)
                                    .join(", ")
                              : "N/A",
                          rightKey: "Marital Status",
                          rightValue: my.maritalStatus?.name ?? "N/A",
                          isMatch: pp?.maritalStatus?.status ?? false,
                        ),
                        preferenceRow(
                          leftKey: "Disability",
                          leftValue: user.disability ?? "",
                          rightKey: "Disability",
                          rightValue: my.disability ?? "",
                          isMatch: pp.disability!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Religion/Commu",
                          leftValue: user.partnerReligion?.name ?? "",
                          rightKey: "Religion/Commu",
                          rightValue: my.religion?.name ?? "",
                          isMatch: pp.religion!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Cast",
                          leftValue: user.partnerCaste?.name ?? "",
                          rightKey: "Cast",
                          rightValue: my.caste?.name ?? "",
                          isMatch: pp.caste!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Mother Tongue",
                          leftValue: user.partnerMotherTongue?.name ?? "",
                          rightKey: "Mother Tongue",
                          rightValue: my.partnerMotherTongue?.name ?? "",
                          isMatch: pp.motherTongue!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Education",
                          leftValue: user.partnerEducation?.name ?? "",
                          rightKey: "Education",
                          rightValue: my.highestDegree?.name ?? "",
                          isMatch: pp.education!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Occupation",
                          leftValue: user.partnerOccupation?.name ?? "",
                          rightKey: "Occupation",
                          rightValue: my.occupation?.name ?? "",
                          isMatch: pp.occupation!.status ?? false,
                        ),

                        // preferenceRow(
                        //   leftKey: "Drink",
                        //   leftValue: user.partnerDrinking ?? "",
                        //   rightKey: "Drink",
                        //   rightValue: my.partnerDrinking ?? "",
                        //   isMatch: pp!.d!.status ?? false,
                        // ),
                        preferenceRow(
                          leftKey: "Gotra",
                          leftValue: user.partnerGotra?.name ?? "",
                          rightKey: "Gotra",
                          rightValue: my.gotra?.name ?? "",
                          isMatch: pp.gotra!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Country",
                          leftValue: user.partnerCountry?.name ?? "",
                          rightKey: "Country",
                          rightValue: my.locNationality?.name ?? "",
                          isMatch: pp.country!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "State Living In",
                          leftValue: user.partnerState?.name ?? "",
                          rightKey: "State Living In",
                          rightValue: my.locState?.name ?? "",
                          isMatch: pp.state!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "City Living In",
                          leftValue: user.partnerCity?.name ?? "",
                          rightKey: "City Living In",
                          rightValue: my.locCity?.name ?? "",
                          isMatch: pp.city!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Annual Income",
                          leftValue:
                              "${user.partnerIncomeFrom ?? ""} to ${user.partnerIncomeTo ?? ""}",
                          rightKey: "Annual Income",
                          rightValue: "₹ ${my.annualIncome ?? ""}",
                          isMatch: pp.annualIncome!.status ?? false,
                        ),

                        preferenceRow(
                          leftKey: "Diet",
                          leftValue: user.partnerDiet?.name ?? "",
                          rightKey: "Diet",
                          rightValue: my.diet?.name ?? "",
                          isMatch: pp.diet!.status ?? false,
                        ),

                        // preferenceRow(
                        //   leftKey: "Family Background",
                        //   leftValue: user.familyType ?? "",
                        //   rightKey: "Family Background",
                        //   rightValue: my.familyType ?? "",
                        //   isMatch: true,
                        // ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
          }),
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
                    style: opensansSemiBold.copyWith(
                      fontSize: 13,
                      color: ColorResources.blacktext,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 3),
                  Text(
                    leftValue,
                    style: opensansMedium.copyWith(
                      fontSize: 12,
                      color: ColorResources.blacktext,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 55,
            height: 55,
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
                    style: opensansSemiBold.copyWith(
                      fontSize: 13,
                      color: ColorResources.blacktext,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 3),
                  Text(
                    rightValue,
                    style: opensansMedium.copyWith(
                      fontSize: 12,
                      color: ColorResources.blacktext,
                    ),
                    maxLines: 1,
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
    final user = userbyuserController.memberData.value!;

    // hobbies list null-safe
    final List<Hobby> hobbies = user.hobbies ?? [];

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hobbies", style: opensansMedium.copyWith(fontSize: 16)),
          SizedBox(height: 12),

          // if list empty
          if (hobbies.isEmpty)
            Text(
              "No hobbies added",
              style: opensansMedium.copyWith(fontSize: 14, color: Colors.grey),
            ),

          // hobbies list
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
                    // Image.asset(item["icon"]!, height: 22, color: Colors.pink),
                    // Static icon
                    // Image.asset(
                    //   "assets/icons/hobby.png",
                    //   height: 22,
                    //   color: Colors.pink,
                    // ),
                    SizedBox(width: 8),

                    Text(
                      item.name?.toString() ?? "",
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

  // Widget buildHobbiesSection() {
  //   final user = userbyuserController.userData.first;

  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Hobbies", style: opensansMedium.copyWith(fontSize: 16)),
  //         SizedBox(height: 12),

  //         Wrap(
  //           spacing: 12,
  //           runSpacing: 12,
  //           children: hobbies.map((item) {
  //             return Container(
  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey.shade300),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Image.asset(item["icon"]!, height: 22, color: Colors.pink),
  //                   SizedBox(width: 8),
  //                   Text(
  //                     item["title"]!,
  //                     style: opensansMedium.copyWith(
  //                       fontSize: 14,

  //                       color: ColorResources.blacktext,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                style: opensansSemiBold.copyWith(
                  fontSize: 13,
                  color: ColorResources.blacktext,
                ),
              ),

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

  final sentCtrl = Get.put(SentInterestController());

  List<String> photos = [];

  Widget _buildTopImageSection(double w, double h) {
    final user = userbyuserController.memberData.value!;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 9 / 11,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (user.profilesetting == null)
                  Image.network(
                    "${ApiConstants.imageurl}${user.photo}",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        user.gender == "Male"
                            ? "assets/images/no-image-male2.jpg"
                            : "assets/images/no-image-female2.jpg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                if (user.profilesetting?.photoShow == 2)
                  Image.network(
                    "${ApiConstants.imageurl}${user.photo}",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        user.gender == "Male"
                            ? "assets/images/no-image-male2.jpg"
                            : "assets/images/no-image-female2.jpg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == null &&
                    user.photorequestcheck == false)
                  Image.network(
                    "${ApiConstants.imageurl}${user.photoBlur}",

                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        user.gender == "Male"
                            ? "assets/images/no-image-male2.jpg"
                            : "assets/images/no-image-female2.jpg",
                        fit: BoxFit.contain,
                      );
                    },
                  ),

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == null &&
                    user.photorequestcheck == true)
                  Image.network(
                    "${ApiConstants.imageurl}${user.photoBlur}",

                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        user.gender == "Male"
                            ? "assets/images/no-image-male2.jpg"
                            : "assets/images/no-image-female2.jpg",
                        fit: BoxFit.contain,
                      );
                    },
                  ),

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == 1 &&
                    user.photorequestcheck == true)
                  Image.network(
                    "${ApiConstants.imageurl}${user.photo}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        user.gender == "Male"
                            ? "assets/images/no-image-male2.jpg"
                            : "assets/images/no-image-female2.jpg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),

                if (user.profilesetting?.photoShow == 2) SizedBox(),

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == null &&
                    user.photorequestcheck == false)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/locked-icon.png'),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            sentCtrl.sendphotorequest(user.id.toString());
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

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == null &&
                    user.photorequestcheck == true)
                  SizedBox(),

                if (user.profilesetting?.photoShow == 1 &&
                    user.photorequeststatus == 1 &&
                    user.photorequestcheck == true)
                  SizedBox(),
              ],
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
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset('assets/images/Group 79.png', height: 40),
              ),

              Spacer(),

              if (user.profilesetting == null)
                GestureDetector(
                  onTap: () {
                    buildPhotoList(user);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => PhotoSliderDialog(photos: photosmatch),
                    );
                  },
                  child: Image.asset(
                    'assets/images/imagecount.png',
                    height: 40,
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
              if (user.profilesetting?.photoShow == 2)
                GestureDetector(
                  onTap: () {
                    buildPhotoList(user);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => PhotoSliderDialog(photos: photosmatch),
                    );
                  },
                  child: Image.asset(
                    'assets/images/imagecount.png',
                    height: 40,
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
              if (user.profilesetting?.photoShow == 1 &&
                  user.photorequeststatus == null &&
                  user.photorequestcheck == false)
                GestureDetector(
                  onTap: () {
                    buildPhotoListblur(user);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) =>
                          PhotoSliderDialog(photos: photosmatchblur),
                    );
                  },
                  child: Image.asset(
                    'assets/images/imagecount.png',
                    height: 40,
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
              if (user.profilesetting?.photoShow == 1 &&
                  user.photorequeststatus == null &&
                  user.photorequestcheck == true)
                GestureDetector(
                  onTap: () {
                    buildPhotoListblur(user);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) =>
                          PhotoSliderDialog(photos: photosmatchblur),
                    );
                  },
                  child: Image.asset(
                    'assets/images/imagecount.png',
                    height: 40,
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
              if (user.profilesetting?.photoShow == 1 &&
                  user.photorequeststatus == 1 &&
                  user.photorequestcheck == true)
                GestureDetector(
                  onTap: () {
                    buildPhotoList(user);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => PhotoSliderDialog(photos: photosmatch),
                    );
                  },
                  child: Image.asset(
                    'assets/images/imagecount.png',
                    height: 40,
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

              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  showFirstPopup(context);
                },
                child: Image.asset(
                  'assets/images/toggle-button.png',
                  height: 35,
                ),
              ),
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
              Builder(
                builder: (_) {
                  final status = userbyuserController
                      .fullResponse
                      .value
                      ?.data
                      ?.interestsentstatus
                      .toString()
                      .trim();

                  if (status == null || status.isEmpty) {
                    return GestureDetector(
                      onTap: () {
                        sentCtrl.sendInterest(user.id.toString());
                        Future.delayed(const Duration(microseconds: 500), () {
                          userbyuserController.fetchUserDetail(
                            user.id.toString(),
                          );
                        });
                      },
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
                      // child: Image.asset(
                      //   'assets/images/Group 85 (1).png',
                      //   height: MediaQuery.of(context).size.height * 0.04,
                      //   fit: BoxFit.contain,
                      // ),
                    );
                  }

                  return GestureDetector(
                    child: Image.asset(
                      'assets/images/Frame 63 2.png',
                      height: MediaQuery.of(context).size.height * 0.05,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),

              const SizedBox(width: 12),
              userbyuserController.fullResponse.value?.data?.shortliststatus ==
                      false
                  ? GestureDetector(
                      onTap: () {
                        sentCtrl.sendshortlisted(user.id.toString());
                        Future.delayed(const Duration(seconds: 1), () {
                          userbyuserController.fetchUserDetail(
                            user.id.toString(),
                          );
                        });
                      },
                      child: Image.asset(
                        'assets/images/shortlist.png',
                        height: 45,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/Property 1=Variant2.png',
                        height: 45,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  void showFirstPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.close, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Decline",
                    style: opensansSemiBold.copyWith(
                      fontSize: 16,
                      color: ColorResources.blacktext,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                showSecondPopup(context); // second popup call
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.block, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Block this person",
                    style: opensansSemiBold.copyWith(
                      fontSize: 16,
                      color: ColorResources.blacktext,
                    ),
                  ),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blacktext,
              ),
            ),
          ),
        );
      },
    );
  }

  void showSecondPopup(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Are you sure you want to Block her?",
            style: opensansSemiBold.copyWith(
              fontSize: 16,
              color: ColorResources.blacktext,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Blocked member will not be able to view your Profile or contact you.",
              style: opensansSemiBold.copyWith(
                fontSize: 13,
                color: ColorResources.blacktext,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: false,
              child: Text(
                "CANCEL",
                style: opensansSemiBold.copyWith(color: Color(0xffd81b60)),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print("Blocked");
              },
              isDestructiveAction: true,
              child: Text(
                "OK",
                style: opensansSemiBold.copyWith(color: Color(0xffd81b60)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget rowTopBottom(String key1, String val1, String key2, String val2) {
    final user = userbyuserController.memberData.value!;

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
                  style: opensansSemiBold.copyWith(
                    fontSize: 14,
                    color: ColorResources.blacktext,
                  ),
                ),

                Text(
                  val1,
                  style: opensansMedium.copyWith(
                    fontSize: 12.5,
                    color: ColorResources.blacktext,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key2,
                  style: opensansSemiBold.copyWith(
                    fontSize: 14,
                    color: ColorResources.blacktext,
                  ),
                ),
                if (user.profilesetting == null)
                  Text(
                    (key2 == "Date of Birth") ? "Request DOB" : val2,
                    style: opensansSemiBold.copyWith(
                      fontSize: 13,
                      color: (key2 == "Date of Birth")
                          ? ColorResources.primarycolor2
                          : ColorResources.blacktext,
                    ),
                  ),
                if (user.profilesetting?.dateOfBirthShow == 2)
                  Text(
                    (key2 == "Date of Birth") ? "Request DOB" : val2,
                    style: opensansSemiBold.copyWith(
                      fontSize: 13,
                      color: (key2 == "Date of Birth")
                          ? ColorResources.primarycolor2
                          : ColorResources.blacktext,
                    ),
                  ),
                if (user.profilesetting?.dateOfBirthShow == 1 &&
                    user.dobrequesttatus == null &&
                    user.dobrequestcheck == false)
                  GestureDetector(
                    onTap: () {
                      sentCtrl.senddobrequest(user.id.toString());
                    },
                    child: Text(
                      (key2 == "Date of Birth") ? "Request DOB" : val2,
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
                        color: (key2 == "Date of Birth")
                            ? ColorResources.primarycolor2
                            : ColorResources.blacktext,
                      ),
                    ),
                  ),
                if (user.profilesetting?.dateOfBirthShow == 1 &&
                    user.dobrequesttatus == null &&
                    user.dobrequestcheck == true)
                  GestureDetector(
                    child: Text(
                      (key2 == "Date of Birth") ? "Request Sent" : val2,
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
                        color: (key2 == "Date of Birth")
                            ? Colors.orangeAccent
                            : ColorResources.blacktext,
                      ),
                    ),
                  ),
                if (user.profilesetting?.dateOfBirthShow == 1 &&
                    user.dobrequesttatus == 1 &&
                    user.dobrequestcheck == true)
                  Text(
                    (key2 == "Date of Birth") ? val2 : val2,
                    style: opensansSemiBold.copyWith(
                      fontSize: 13,
                      color: ColorResources.blacktext,
                    ),
                  ),
                // Text(
                //   val2,
                //   style: opensansSemiBold.copyWith(
                //     fontSize: 13,
                //     color: ColorResources.blacktext,
                //   ),
                // ),
                // GestureDetector(
                //   onTap:
                //       (key2 == "Date of Birth" &&
                //           user.profilesetting?.dateOfBirthShow == 1)
                //       ? () {
                //           sentCtrl.senddobrequest(user.id.toString());
                //           // print("Request DOB tapped");
                //         }
                //       : null,
                // child: Text(
                //   (key2 == "Date of Birth" &&
                //           user.profilesetting?.dateOfBirthShow == 1)
                //       ? "Request DOB"
                //       : val2,
                //   style: opensansSemiBold.copyWith(
                //     fontSize: 13,
                // color:
                //     (key2 == "Date of Birth" &&
                //         user.profilesetting?.dateOfBirthShow == 1)
                //     ? ColorResources.primarycolor2
                //     : ColorResources.blacktext,
                //   ),
                // ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    final user = userbyuserController.memberData.value!;
    final u = usercontroller.userData.value!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                (() {
                  String name = user.name ?? "";
                  int showType = user.profilesetting?.nameShow ?? 1;

                  bool isPremium = false;
                  if (u.planDetail != null) {
                    if (u.planDetail is Map && u.planDetail == null) {
                      isPremium = true;
                    } else if (u.planDetail is List && u.planDetail == null) {
                      isPremium = true;
                    }
                  }

                  if (name.isEmpty) return "";

                  String maskName(String n) {
                    if (n.length <= 2) return n[0] + "*";
                    return n.substring(0, 2) + ("*" * (n.length - 2));
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
                style: opensansSemiBold.copyWith(fontSize: 18),
              ),
              // Text(
              //   user.name ?? "",
              //   style: opensansSemiBold.copyWith(fontSize: 18),
              // ),
              SizedBox(width: 10),
              Text(
                (() {
                  int idShow = user.profilesetting?.customerIdShow ?? 2;

                  if (idShow == 1) {
                    return "(ID: --)";
                  }

                  if (idShow == 2) {
                    return user.profileId == null
                        ? "(ID: --)"
                        : "(ID: ${user.profileId})";
                  }

                  return "(ID: --)";
                })(),
                style: opensansSemiBold.copyWith(
                  fontSize: 14,
                  color: ColorResources.primarycolor2,
                ),
              ),
              // Text(
              //   "(ID: ${user.profileId ?? ""})",
              //   style: opensansSemiBold.copyWith(
              //     fontSize: 14,
              //     color: ColorResources.primarycolor2,
              //   ),
              // ),
              const SizedBox(width: 10),
              Icon(Icons.verified, color: Colors.green, size: 18),
            ],
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Text(
                "Profile created by ${user.profileFor!.name ?? ""}",
                style: opensansSemiBold.copyWith(
                  color: ColorResources.blackgrey,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 15),
              Image.asset('assets/images/Frame 64.png', height: 19),
            ],
          ),
        ],
      ),
    );
  }
}
