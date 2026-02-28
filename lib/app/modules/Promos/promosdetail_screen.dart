import 'package:evfual/app/modules/Promos/promocode_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PromoDetailsScreen extends StatelessWidget {
  const PromoDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// App Bar Row
                  Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      const SizedBox(width: 12),
                      Text(
                        "Promos",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Promo Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Image Banner
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage("assets/images/Rectangle.png"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _blueTags(
                                  "BEST DEAL",
                                  "assets/images/splashscreen.png",
                                ),

                                const SizedBox(height: 8),

                                _blueTag("END OF YEAR PROMO"),

                                const Spacer(),
                                Text(
                                  "20% OFF",
                                  style: PoppinsBold.copyWith(
                                    fontSize: 30,

                                    color: ColorResources.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      color: ColorResources.whiteColor,
                                      child: Text(
                                        "CODE ",
                                        style: PoppinsSemiBold.copyWith(
                                          fontSize: 14,

                                          color: ColorResources.blueeebutton,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      color: ColorResources.blueeebutton,
                                      child: Text(
                                        "EOYP25",
                                        style: PoppinsBold.copyWith(
                                          fontSize: 14,

                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Best Deal: 20% OFF",
                                style: PoppinsSemiBold.copyWith(
                                  fontSize: 17,

                                  color: ColorResources.blackcolor,
                                ),
                                // style: TextStyle(
                                //   fontSize: size.width * 0.045,
                                //   fontWeight: FontWeight.bold,
                                // ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "End of year promo. 20% discount on all services",
                                style: PoppinsReguler.copyWith(
                                  fontSize: 14,

                                  color: ColorResources.TextColorForGrey,
                                ),
                                // style: TextStyle(
                                //   color: Colors.grey.shade600,
                                //   fontSize: size.width * 0.035,
                                // ),
                              ),
                              const SizedBox(height: 16),

                              /// Promo Code Box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "EOY25",
                                    style: PoppinsBold.copyWith(
                                      fontSize: 18,

                                      color: ColorResources.blackcolor,
                                    ),
                                    // style: TextStyle(
                                    //   fontSize: 18,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              sectionTitle("Promo Valid Date"),
                              sectionText("March 1st – March 31st 2025"),

                              const SizedBox(height: 16),

                              sectionTitle("Minimum Spend"),
                              sectionText("There is no minimum spend."),

                              const SizedBox(height: 16),

                              sectionTitle("Terms and Conditions"),
                              const SizedBox(height: 8),
                              bulletText(
                                "Enjoy a 20% discount on your next ride with MyRide.",
                              ),
                              bulletText(
                                "Valid for rides booked and completed between March 1st and March 31st.",
                              ),
                              bulletText(
                                "Promo code must be entered before booking.",
                              ),
                              bulletText("Discount applies to base fare only."),
                              bulletText(
                                "Promo code can only be used once per user account.",
                              ),
                              bulletText(
                                "Cannot be combined with other promos.",
                              ),
                              bulletText(
                                "MyRide reserves the right to modify or cancel the promo.",
                              ),

                              const SizedBox(height: 16),

                              sectionTitle("How to Use"),
                              const SizedBox(height: 8),
                              bulletText("Open the MyRide app."),
                              bulletText("Select pickup and drop-off."),
                              bulletText("Tap on the Promo/Voucher section."),
                              bulletText("Enter the promo code 'EOY25'."),
                              bulletText("Confirm booking to enjoy discount."),

                              const SizedBox(height: 16),

                              sectionTitle("Additional Information"),
                              const SizedBox(height: 8),
                              bulletText("Limited time offer."),
                              bulletText(
                                "Question or issues? Contact support.",
                              ),

                              const SizedBox(height: 24),

                              /// Button
                              CustomPrimaryButton(
                                text: "Use Now",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PromoCodeScreen(),
                                    ),
                                  );

                                  ///PromoCodeScreen
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: PoppinsSemiBold.copyWith(
        fontSize: 17,

        color: ColorResources.blackcolor,
      ),
    );
  }

  Widget sectionText(String text) {
    return Text(
      text,

      style: PoppinsReguler.copyWith(
        fontSize: 14,

        color: ColorResources.textdetailsColor,
      ),
    );
  }

  Widget _blueTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: ColorResources.blueeebutton,
      child: Text(
        text,
        style: PoppinsBold.copyWith(
          //fontSize: 30,
          color: ColorResources.whiteColor,
        ),
      ),
    );
  }

  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _blueTags(String text, String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: ColorResources.blueeebutton,
          child: Text(
            text,
            style: PoppinsBold.copyWith(color: ColorResources.whiteColor),
          ),
        ),
        Spacer(),

        _imageLogo(image),
      ],
    );
  }

  Widget _imageLogo(String images) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          Image.asset(
            images,
            height: 30,
            width: 30,

            color: ColorResources.whiteColor,
          ),
        ],
      ),
    );
  }

  ////assets/images/splashscreen.png
}
