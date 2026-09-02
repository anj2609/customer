import 'package:get/get.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Get.find<ProfileController>().getNotificationListing();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: ColorResources.blackcolor),
        centerTitle: true,
        title: Text(
          "Notifications",
          style: PoppinsSemiBold.copyWith(
            color: ColorResources.blackcolor,
            fontSize: Dimensions.spacingSize16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.deleteAllNotifications(context: context);
            },
            child: Text(
              "Delete All",
              style: PoppinsSemiBold.copyWith(
                color: ColorResources.textColorRed,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            if (controller.isNotificationLoading) {
              return const Center(child: PremiumBlurLoader());
            }

            if (controller.notificationList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/notdatafound.png",
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "No Data Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: controller.notificationList.length,
              itemBuilder: (context, index) {
                var item = controller.notificationList[index];

                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 25),
                    decoration: BoxDecoration(
                      color: ColorResources.textColorRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    String deletedId = item.id ?? "";
                    controller.deleteNotification(
                      context: context,
                      id: deletedId,
                      index: index,
                    );
                  },
                  child: InkWell(
                    onTap: () {
                      if (item.isRead == "0") {
                        controller.readNotification(id: item.id ?? "");
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.isRead == "0"
                                ? Icons.notifications_active
                                : Icons.notifications,
                            color: item.isRead == "0"
                                ? const Color(0xFF123EBC)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.message ?? "",
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.blackcolor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.date ?? "",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
