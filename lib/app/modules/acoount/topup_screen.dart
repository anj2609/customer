import 'package:evfual/app/modules/acoount/topuppaymentmethod_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/dimensions.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final TextEditingController amountController = TextEditingController(
    text: "250",
  );

  int selectedIndex = 7;

  final List<int> amounts = [20, 30, 50, 70, 100, 150, 200, 250, 500];
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.appgroundcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: ColorResources.blackcolor),
        ),
        title: Text(
          "Top Up",
          style: PoppinsExtrabold.copyWith(fontSize: Dimensions.spacingSize16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Amount Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                /// Editable Amount
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: amountController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      suffixText: "₹",
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = -1;
                      });
                    },
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Available balance: ₹2069.50",
                  style: PoppinsReguler.copyWith(
                    color: ColorResources.TextColorForGrey,
                  ),
                ),
              ],
            ),
          ),

          /// Amount Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.spacingSize16),
            child: Wrap(
              spacing: Dimensions.spacingSize10,
              runSpacing: Dimensions.spacingSize10,
              children: List.generate(amounts.length, (index) {
                bool selected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      amountController.text = amounts[index].toString();
                    });
                  },
                  child: Container(
                    width: (width - 52) / 3,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? ColorResources.blueeebutton
                          : ColorResources.whiteColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.spacingSize25,
                      ),
                      border: Border.all(color: ColorResources.whiteColor),
                    ),
                    child: Text(
                      "₹ ${amounts[index]}",
                      style: PoppinsSemiBold.copyWith(
                        color: selected
                            ? ColorResources.whiteColor
                            : ColorResources.blackcolor,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: Dimensions.spacingSize10,
              right: Dimensions.spacingSize10,
              top: Dimensions.spacingSize40,
            ),
            child: CustomPrimaryButton(
              text: "Next",
              onTap: () {
                if (amountController.text.isNotEmpty) {
                  Get.to(
                    () => TopUpMethodScreen(
                      paymentamount: '666',
                    ),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 300),
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Please enter amount",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
