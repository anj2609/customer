import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/modal/activity_model.dart';

/// Shared ride-summary card — same visual format across every Activity
/// filter (Ongoing, Scheduled, Completed, Canceled): vehicle image, drop
/// address, date, status, fare. Originally only used on the Canceled tab;
/// now reused everywhere so all filters look and behave the same way.
class ActivityRideCard extends StatelessWidget {
  final ActivityDataMainModel item;
  final VoidCallback? onTap;

  /// Optional extra widget rendered under the card row (e.g. a "Track
  /// Route" button on the Ongoing tab).
  final Widget? footer;

  const ActivityRideCard({
    super.key,
    required this.item,
    this.onTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.03),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: ColorResources.whiteColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Vehicle image — never cropped, whatever the source
                /// image's aspect ratio is.
                ClipRRect(
                  borderRadius: BorderRadius.circular(width * 0.09),
                  child: Container(
                    width: width * 0.16,
                    height: width * 0.16,
                    color: ColorResources.backgroundColor,
                    child: (item.image != null && item.image!.isNotEmpty)
                        ? Image.network(
                            '${ApiConstants.imageurl}${item.image}',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Padding(
                                padding: EdgeInsets.all(width * 0.02),
                                child: Image.asset(
                                  "assets/images/cars.png",
                                  fit: BoxFit.contain,
                                  color: ColorResources.blueeebutton,
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Image.asset(
                              "assets/images/cars.png",
                              fit: BoxFit.contain,
                              color: ColorResources.blueeebutton,
                            ),
                          ),
                  ),
                ),

                SizedBox(width: width * 0.04),

                /// Title & Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.dropAddress ?? "N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsSemiBold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(item.createdAt),
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.status ?? "",
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: _statusColor(item.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Amount
                Text(
                  "₹ ${item.totalFare ?? 0}",
                  style: TextStyle(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (footer != null) ...[
              SizedBox(height: width * 0.03),
              footer!,
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case 'cancelled':
      case 'canceled':
        return ColorResources.textColorRed;
      case 'completed':
        return Colors.green;
      default:
        return ColorResources.blueeebutton;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(dateString);
      final fullDate = DateFormat('yyyy-MM-dd').format(dateTime);
      final dayMonth = DateFormat('dd MMMM').format(dateTime);
      return "$fullDate  $dayMonth";
    } catch (_) {
      return dateString;
    }
  }
}
