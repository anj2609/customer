import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class PhoneSettingScreen extends StatefulWidget {
  const PhoneSettingScreen({super.key});

  @override
  State<PhoneSettingScreen> createState() => _PhoneSettingScreenState();
}

class _PhoneSettingScreenState extends State<PhoneSettingScreen> {
  bool newInvitations = true;
  bool newAccepts = true;
  bool newMatches = true;
  bool newOffers = true;
  final usercontroller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final u = usercontroller.userData.value!;
    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------- BODY -----------------
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
                      GestureDetector(
                        onTap: () {
                          showEditPhoneDialog(context, "${u.mobile}");
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Phone Icon With Tick
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/mobile-settings_svgrepo.com.png',
                                      height: 60,
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 5),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 6),
                                        Text(
                                          "Phone No. is Verified",
                                          style: opensansSemiBold.copyWith(
                                            color: ColorResources.primarycolor2,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    Row(
                                      children: [
                                        Text(
                                          "+91-${u.mobile}",
                                          style: opensansSemiBold.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // Edit Icon
                                        Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.grey.shade700,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          showPrivacyDialog(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                "Phone Privacy Settings",
                                style: opensansSemiBold.copyWith(
                                  fontSize: 17,

                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Only Premium Members",
                                    style: opensansMedium.copyWith(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 30, thickness: 1),
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
              "Phone Settings",
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

void showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PrivacyDialog(),
  );
}

class _PrivacyDialog extends StatefulWidget {
  const _PrivacyDialog({Key? key}) : super(key: key);

  @override
  State<_PrivacyDialog> createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends State<_PrivacyDialog> {
  String selected = "Only Premium Members";

  final List<String> options = [
    "Only Premium Members",
    "Only Premium Members You Like",
    "No one (Matches won’t be able to call you)",
  ];
  NotificationController nc = Get.find();
  int? indexvalue;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Phone Privacy Setting",
              style: opensansSemiBold.copyWith(fontSize: 16),
            ),

            const SizedBox(height: 15),

            Column(
              children: options.asMap().entries.map((entry) {
                int index = entry.key; // 0,1,2
                String option = entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() => selected = option);

                    indexvalue = index + 1;
                    print(index + 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          selected == option
                              ? CupertinoIcons.smallcircle_circle_fill
                              : CupertinoIcons.circle,
                          color: selected == option ? Colors.pink : Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: opensansMedium.copyWith(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CANCEL",
                    style: opensansSemiBold.copyWith(
                      color: ColorResources.primarycolor2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    nc.phonesetting(privacysetting: indexvalue!);
                    Future.delayed(const Duration(microseconds: 1000), () {
                      Get.back();
                    });
                    print("Selected: $selected");
                  },
                  child: Text(
                    "OK",
                    style: opensansSemiBold.copyWith(
                      color: ColorResources.primarycolor2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showEditPhoneDialog(BuildContext context, String currentNumber) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _EditPhoneDialog(initialNumber: currentNumber),
  );
}

class _EditPhoneDialog extends StatefulWidget {
  final String initialNumber;

  const _EditPhoneDialog({Key? key, required this.initialNumber})
    : super(key: key);

  @override
  State<_EditPhoneDialog> createState() => _EditPhoneDialogState();
}

class _EditPhoneDialogState extends State<_EditPhoneDialog> {
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.initialNumber);
  }

  StaperfromController stapercontroller = Get.put(StaperfromController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Edit Phone Number",
              style: opensansSemiBold.copyWith(fontSize: 17),
            ),

            const SizedBox(height: 6),

            // Subtitle
            Text(
              "Only Premium Members",
              style: opensansMedium.copyWith(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 15),

            // Phone Field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.pink.shade600,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Buttons: Cancel / Save
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CANCEL",
                    style: opensansSemiBold.copyWith(
                      color: ColorResources.primarycolor2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    stapercontroller.updatepartnerotherdetails(
                      formData: {"contact_no": phoneController.text},
                    );
                    print("Saved Number: ${phoneController.text}");
                  },
                  child: Text(
                    "SAVE",
                    style: opensansSemiBold.copyWith(
                      color: ColorResources.primarycolor2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
