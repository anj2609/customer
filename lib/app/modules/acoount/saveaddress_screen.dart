import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class SavedAddressScreen extends StatefulWidget {
  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  /// ✅ Controller define karo
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    controller.getAddressCustomer(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.appgroundcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Saved Address",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: GetBuilder<ProfileController>(
        builder: (controller) {
          /// ✅ Loader
          if (controller.isLoadings == true) {
            return Center(child: PremiumBlurLoader());
          }

          if (controller.addressList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No trips yet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          /// ✅ Address List (Same UI Design)
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.addressList.length,
            itemBuilder: (context, index) {
              final data = controller.addressList[index];

              return Container(
                margin: EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: data.isDefault == 1
                      ? ColorResources.blueeebutton.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: ColorResources.blueeebutton, size: 22),

                    SizedBox(width: 12),

                    /// Address Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.label ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            data.address ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Share Icon
                    // Icon(Icons.share, size: 20),
                    // SizedBox(width: 10),

                    /// Popup Menu
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == "edit") {
                          Get.toNamed(
                            RouteHelper.getaddressUpdateScreen(),
                            arguments: {
                              'isEdit': true,
                              'index': index,

                              'address': data,
                            },
                          );
                        } else if (value == "delete") {
                          _showDeleteBottomSheet(
                            context,
                            data,
                            index,
                            data.id!,
                          );

                          // controller.addressList.removeAt(index);
                          // controller.update();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: ColorResources.textColorRed),
                              SizedBox(width: 8),
                              Text(
                                "Delete",
                                style: TextStyle(color: ColorResources.textColorRed),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(Dimensions.spacingSize25),
        child: CustomPrimaryButton(
          text: "Add Address",
          onTap: () async {
            final result = await Get.toNamed(
              RouteHelper.getaddAddressScreens(),
            );

            if (result == true) {
              controller.getAddressCustomer(context: context);
            }
          },
        ),
      ),
    );
  }

  void _showDeleteBottomSheet(
    BuildContext context,
    dynamic data,
    int index,
    int addresId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              Text(
                "Delete Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.textColorRed,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),

              const SizedBox(height: 10),

              const Text(
                "Sure you want to delete this address?",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 16),

              /// ADDRESS PREVIEW CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: ColorResources.blueeebutton, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.label ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.address ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.blueeebutton,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Get.find<ProfileController>().deleteaddressapi(
                          //   context: context,
                          //   address_id: addresId,
                          // );
                          Get.find<ProfileController>().deleteaddressapi(
                            context: context,
                            address_id: addresId,
                            index: index,
                          );

                          // controller.addressList.removeAt(index);
                          // controller.update();
                        },
                        child: const Text(
                          "Yes, Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
