import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/customdailog_screen.dart';
import 'package:evfual/config/utils/dimensions.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpMethodScreen extends StatefulWidget {
  final String paymentamount;
  TopUpMethodScreen({super.key, required this.paymentamount});

  @override
  State<TopUpMethodScreen> createState() => _TopUpMethodScreenState();
}

class _TopUpMethodScreenState extends State<TopUpMethodScreen> {
  int selectedIndex = 2;

  List<Map<String, dynamic>> paymentMethods = [
    {
      "title": "Google Pay",
      "subtitle": "onsh_8562@yonobank.com",
      "icon": "assets/images/googlepay.png",
    },
    {
      "title": "Apple Pay",
      "subtitle": "onsh_8562@yonobank.com",
      "icon": "assets/images/Applepay.png",
    },
    {
      "title": "Mastercard",
      "subtitle": "XXXX XXXX XXXX 2564",
      "icon": "assets/images/mastercard.png",
    },
    {
      "title": "Visa",
      "subtitle": "XXXX XXXX XXXX 2564",
      "icon": "assets/images/visa.png",
    },
    {
      "title": "American Express",
      "subtitle": "XXXX XXXX XXXX 2564",
      "icon": "assets/images/american.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorResources.appgroundcolor,

      appBar: AppBar(
        backgroundColor: ColorResources.whiteColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },

          child: Icon(Icons.arrow_back, color: ColorResources.blackcolor),
        ),
        title: Text(
          "Choose Top Up Method",
          style: PoppinsBold.copyWith(
            color: ColorResources.blackcolor,
            fontSize: Dimensions.spacingSize16,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.spacingSize16),
            child: Icon(Icons.add, color: ColorResources.blackcolor),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: Dimensions.spacingSize10,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.spacingSize10),
                      padding: const EdgeInsets.all(Dimensions.spacingSize10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          Dimensions.spacingSize12,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? ColorResources.blueeebutton
                              : ColorResources.backgroundColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Dimensions.spacingSize20,
                            backgroundColor: ColorResources.backgroundColor,
                            child: Image.asset(paymentMethods[index]["icon"]),
                          ),

                          SizedBox(width: w * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  paymentMethods[index]["title"],
                                  style: PoppinsSemiBold.copyWith(
                                    color: ColorResources.blackcolor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  paymentMethods[index]["subtitle"],
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.TextColorForGrey,
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
              ),
            ),
            CustomPrimaryButton(
              text: "Confirm Top Up - ₹${widget.paymentamount} ",
              onTap: () {
                CustomPopup.showSuccess(
                  context,
                  "Confirm Top Up - ₹${widget.paymentamount}",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
