import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorResources.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorResources.blackcolor11),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Terms & Conditions",
          style: PoppinsSemiBold.copyWith(
            fontSize: 18,
            color: ColorResources.blackcolor11,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionBody(
              "By accessing or using NRIDE services, users agree to the following terms:",
            ),
            const SizedBox(height: 20),

            _sectionTitle("Service Availability"),
            _sectionBody(
              "NRIDE provides a technology platform connecting passengers with independent driver partners. NRIDE does not own or operate transportation vehicles unless specifically stated.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("User Responsibilities"),
            _sectionBody("Users shall:"),
            _bulletPoint("Provide accurate information"),
            _bulletPoint("Maintain respectful conduct"),
            _bulletPoint("Not misuse the platform"),
            _bulletPoint("Comply with applicable laws"),
            const SizedBox(height: 16),

            _sectionTitle("Driver Partner Responsibilities"),
            _sectionBody("Drivers shall:"),
            _bulletPoint("Maintain valid licenses and permits"),
            _bulletPoint("Ensure vehicle fitness and insurance"),
            _bulletPoint("Follow all transport regulations"),
            _bulletPoint("Maintain professional behavior"),
            const SizedBox(height: 16),

            _sectionTitle("Payments"),
            _sectionBody(
              "Users agree to pay applicable fares, taxes, tolls, parking charges, and service fees associated with the ride.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Limitation of Liability"),
            _sectionBody(
              "NRIDE shall not be liable for delays, traffic conditions, weather disruptions, vehicle breakdowns, or circumstances beyond reasonable control.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Modifications"),
            _sectionBody(
              "NRIDE reserves the right to modify services, pricing, and policies at any time without prior notice.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Governing Law"),
            _sectionBody(
              "These terms shall be governed by the laws of India and subject to the jurisdiction of courts in Agartala, Tripura.",
            ),
            const SizedBox(height: 24),

            // Refund Policy Section
            _mainTitle("Refund Policy"),
            const SizedBox(height: 8),
            _sectionBody(
              "NRIDE strives to ensure a fair and transparent refund process.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Eligible Refund Cases"),
            _sectionBody("Refunds may be considered in cases such as:"),
            _bulletPoint("Payment deducted but ride not assigned"),
            _bulletPoint("Duplicate payment"),
            _bulletPoint("Technical system error"),
            _bulletPoint("Incorrect fare charged due to system malfunction"),
            const SizedBox(height: 16),

            _sectionTitle("Non-Refundable Situations"),
            _sectionBody("Refunds will generally not be provided for:"),
            _bulletPoint("User no-show"),
            _bulletPoint("Late cancellations beyond permitted limits"),
            _bulletPoint("Delays caused by traffic, weather, or force majeure"),
            _bulletPoint(
              "Disputes arising after successful ride completion without supporting evidence",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Refund Timeline"),
            _sectionBody(
              "Approved refunds shall normally be processed within 7 to 10 business days through the original payment method.",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Refund Decision"),
            _sectionBody(
              "NRIDE reserves the right to review each refund request and make the final determination based on available records and evidence.",
            ),
            const SizedBox(height: 24),

            // Driver Partner Terms
            _mainTitle("Driver Partner Terms (Key Points)"),
            const SizedBox(height: 8),
            _bulletPoint("Minimum age 18 years"),
            _bulletPoint("Valid Driving License mandatory"),
            _bulletPoint(
              "Vehicle RC, Insurance, Fitness Certificate, Pollution Certificate mandatory",
            ),
            _bulletPoint("Police verification may be required"),
            _bulletPoint("Driver responsible for vehicle maintenance"),
            _bulletPoint(
              "Driver responsible for traffic violations and challans",
            ),
            _bulletPoint(
              "NRIDE may suspend accounts for misconduct, fraud, intoxication, overcharging, harassment, or safety violations",
            ),
            _bulletPoint(
              "Driver commission and payout schedules subject to company policy",
            ),
            _bulletPoint(
              "Driver must not solicit off-platform rides from NRIDE customers",
            ),
            const SizedBox(height: 24),

            // Cancellation Policy
            _mainTitle("Cancellation Policy (Key Points)"),
            const SizedBox(height: 8),

            _sectionTitle("Passenger Cancellation"),
            _bulletPoint("Within 2 minutes: No charge"),
            _bulletPoint(
              "After driver assignment: Nominal cancellation fee may apply",
            ),
            _bulletPoint(
              "Repeated cancellations may lead to account restrictions",
            ),
            const SizedBox(height: 16),

            _sectionTitle("Driver Cancellation"),
            _bulletPoint("Drivers should avoid unnecessary cancellations"),
            _bulletPoint(
              "Repeated cancellations may affect ratings and platform access",
            ),
            const SizedBox(height: 16),

            _sectionTitle("No Show"),
            _bulletPoint(
              "If passenger is unavailable after reasonable waiting time, driver may cancel and applicable charges may be levied.",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _mainTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          ColorResources.blueeebutton.red,
          ColorResources.blueeebutton.green,
          ColorResources.blueeebutton.blue,
          0.08,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: PoppinsSemiBold.copyWith(
          fontSize: 16,
          color: ColorResources.blueeebutton,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: PoppinsSemiBold.copyWith(
          fontSize: 14,
          color: ColorResources.blackcolor11,
        ),
      ),
    );
  }

  Widget _sectionBody(String text) {
    return Text(
      text,
      style: PoppinsMedium.copyWith(
        fontSize: 13,
        color: ColorResources.TextColorForGrey,
        height: 1.6,
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: ColorResources.TextColorForGrey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: PoppinsMedium.copyWith(
                fontSize: 13,
                color: ColorResources.TextColorForGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
