import 'package:intl/intl.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/modal/activity_model.dart';
import 'package:flutter/material.dart';

/// Ride detail screen — shows the real data for whichever ride was tapped
/// (passed in via [item]). No fabricated fields: anything the API doesn't
/// return (e.g. a fare breakdown, ETA, passenger count) is simply not shown
/// rather than guessed.
class RideDetailsScreen extends StatelessWidget {
  final ActivityDataMainModel item;

  const RideDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Ride Details",
          style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11),
        ),
        elevation: 0,
        backgroundColor: ColorResources.whiteColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 15),

              /// 🔹 MAIN CARD
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Center(
                      child: Text(
                        item.vehicleType?.name ?? "Your Ride",
                        style: PoppinsSemiBold.copyWith(
                          color: ColorResources.blackcolor11,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (item.createdAt != null && item.createdAt!.isNotEmpty)
                      Center(
                        child: Text(
                          _formatDateTime(item.createdAt!),
                          style: PoppinsMedium.copyWith(
                            color: ColorResources.TextColorForGrey,
                          ),
                        ),
                      ),

                    const SizedBox(height: 15),

                    /// 🔹 CAB DETAIL BOX
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorResources.blueeebutton.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 40,
                              height: 40,
                              color: ColorResources.backgroundColor,
                              child:
                                  (item.image != null && item.image!.isNotEmpty)
                                  ? Image.network(
                                      '${ApiConstants.imageurl}${item.image}',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/cab.png",
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/cab.png",
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              item.vehicleType?.name ?? "Cab",
                              style: PoppinsReguler.copyWith(
                                color: ColorResources.blackcolor11,
                              ),
                            ),
                          ),

                          Text(
                            "₹ ${item.totalFare ?? 0}",
                            style: PoppinsSemiBold.copyWith(
                              color: ColorResources.blackcolor11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 ROUTE BOX
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: ColorResources.blueeebutton,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.pickupAddress ?? "N/A",
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: ColorResources.textColorRed,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.dropAddress ?? "N/A",
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 DRIVER (only if one is assigned to this ride)
                    if (item.driver != null &&
                        (item.driver!.name ?? "").isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: ColorResources.blueeebutton
                                  .withValues(alpha: 0.08),
                              child: Icon(
                                Icons.person,
                                color: ColorResources.blueeebutton,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.driver!.name!,
                                    style: PoppinsSemiBold.copyWith(
                                      color: ColorResources.blackcolor11,
                                    ),
                                  ),
                                  if ((item.driver!.phone ?? "").isNotEmpty)
                                    Text(
                                      item.driver!.phone!,
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
                      const SizedBox(height: 15),
                    ],

                    /// 🔹 DETAILS CARD
                    _infoRow("Status", item.status ?? "N/A", isBadge: true),
                    _infoRow("Payment", item.paymentType ?? "N/A"),
                    if (item.createdAt != null && item.createdAt!.isNotEmpty)
                      _infoRow("Date", _formatDateTime(item.createdAt!)),
                    if (item.id != null)
                      _infoRow("Booking ID", item.id.toString()),
                    if ((item.pickupOtp ?? "").isNotEmpty)
                      _infoRow("Pickup OTP", item.pickupOtp!),

                    const SizedBox(height: 15),

                    /// 🔹 FARE
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Fare",
                              style: PoppinsSemiBold.copyWith(
                                color: ColorResources.blackcolor11,
                              ),
                            ),
                          ),
                          Text(
                            "₹ ${item.totalFare ?? 0}",
                            style: PoppinsSemiBold.copyWith(
                              color: ColorResources.blackcolor11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 INFO ROW
  Widget _infoRow(String title, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          isBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.blueeebutton),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: ColorResources.blueeebutton,
                      fontSize: 12,
                    ),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy  •  hh:mm a').format(dateTime);
    } catch (_) {
      return dateString;
    }
  }
}
