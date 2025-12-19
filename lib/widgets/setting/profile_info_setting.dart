import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/profile_info_contro.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';

class ProfileinfoSetting extends StatefulWidget {
  const ProfileinfoSetting({super.key});

  @override
  State<ProfileinfoSetting> createState() => _ProfileinfoSettingState();
}

class _ProfileinfoSettingState extends State<ProfileinfoSetting> {
  // final Map<String, String> selectedOptions = {
  //   "My Name": "Visible to all",
  //   "Email ID": "Visible",
  //   "Customer ID": "Visible",
  //   "My Photo": "Visible",
  //   "Date of Birth": "Visible",
  //   "Work With": "Visible",
  //   "Income": "Visible",
  // };
  Map<String, String> selectedOptions = {};
  final Map<String, List<String>> options = {
    "My Name": ["Visible to all", "Only Premium Members", "Hide"],
    "Email ID": ["Visible", "Hide"],
    "Customer ID": ["Visible", "Hide"],
    "My Photo": ["Visible", "View by request"],
    "Date of Birth": ["Visible", "View by request"],
    "Work With": ["Visible", "Hide"],
    "Income": ["Visible", "Hide"],
  };
  NotificationController2 nccc = Get.find();

  NotificationController nc = Get.find();
  int mapValue(String key, String value) {
    if (key == "My Name") {
      if (value == "Hide") return 1;
      if (value == "Visible to all") return 2;
      if (value == "Only Premium Members") return 3;
    }

    if (key == "My Photo" || key == "Date of Birth") {
      if (value == "Visible") return 2;
      if (value == "View by request") return 1;
    }

    if (value == "Hide") return 1;
    if (value == "Visible") return 2;

    return 0;
  }

  // UI Colors
  Color getPink() => const Color(0xFFEB1D7B);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nccc.getProfileSetting().then((_) {
      setState(() {
        selectedOptions = {
          "My Name": mapNumberToText("My Name", nccc.nameShow.value),
          "Email ID": mapNumberToText("Email ID", nccc.emailShow.value),
          "Customer ID": mapNumberToText(
            "Customer ID",
            nccc.customerIdShow.value,
          ),
          "My Photo": mapNumberToText("My Photo", nccc.photoShow.value),
          "Date of Birth": mapNumberToText("Date of Birth", nccc.dobShow.value),
          "Work With": mapNumberToText("Work With", nccc.workWithShow.value),
          "Income": mapNumberToText("Income", nccc.incomeShow.value),
        };
      });
    });
  }

  String mapNumberToText(String key, int number) {
    if (key == "My Name") {
      if (number == 1) return "Hide";
      if (number == 2) return "Visible to all";
      if (number == 3) return "Only Premium Members";
    }

    if (key == "My Photo" || key == "Date of Birth") {
      if (number == 2) return "Visible";
      if (number == 1) return "View by request";
    }

    if (number == 1) return "Hide";
    if (number == 2) return "Visible";

    return "Visible";
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                _buildTopBar(),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      ...options.entries.map((entry) {
                        return _buildSettingRow(
                          title: entry.key,
                          opts: entry.value,
                        );
                      }).toList(),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            int nameVal = mapValue(
                              "My Name",
                              selectedOptions["My Name"]!,
                            );
                            int emailVal = mapValue(
                              "Email ID",
                              selectedOptions["Email ID"]!,
                            );
                            int customerVal = mapValue(
                              "Customer ID",
                              selectedOptions["Customer ID"]!,
                            );
                            int photoVal = mapValue(
                              "My Photo",
                              selectedOptions["My Photo"]!,
                            );
                            int dobVal = mapValue(
                              "Date of Birth",
                              selectedOptions["Date of Birth"]!,
                            );
                            int workWithVal = mapValue(
                              "Work With",
                              selectedOptions["Work With"]!,
                            );
                            int incomeVal = mapValue(
                              "Income",
                              selectedOptions["Income"]!,
                            );

                            print("Converted Values:");
                            print("Name: $nameVal");
                            print("Email: $emailVal");
                            print("Customer ID: $customerVal");
                            print("Photo: $photoVal");
                            print("DOB: $dobVal");
                            print("Work With: $workWithVal");
                            print("Income: $incomeVal");

                            nc.profileinfosetting(
                              nameshow: nameVal,
                              emailshow: emailVal,
                              customerid: customerVal,
                              photoshow: photoVal,
                              dateofbirth: dobVal,
                              workwithshow: workWithVal,
                              incomeshow: incomeVal,
                            );
                            Future.delayed(
                              const Duration(microseconds: 1000),
                              () {
                                Get.back();
                              },
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: getPink(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "SUBMIT",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
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

  Widget _buildSettingRow({required String title, required List<String> opts}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(title, style: opensansSemiBold.copyWith(fontSize: 15)),

          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: opts.map((opt) {
              final bool isSelected = selectedOptions[title] == opt;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOptions[title] = opt;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? getPink().withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? getPink() : Colors.grey.shade400,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: opensansMedium.copyWith(
                      color: isSelected ? getPink() : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(text, style: opensansSemiBold.copyWith(fontSize: 16)),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 20,
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
              "Profile Info. Settings",
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
}
