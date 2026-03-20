// import 'package:evfual/app/modules/acoount/addaddress_screen.dart';
// import 'package:evfual/config/utils/colors.dart';
// import 'package:evfual/config/utils/dimensions.dart';
// import 'package:evfual/data/controller/addaddress_controller.dart';
// import 'package:evfual/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SavedAddressScreen extends StatelessWidget {
//   final AddressController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResources.appgroundcolor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         title: Text(
//           "Saved Addresses",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),

//       body: Obx(() {
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: controller.addressList.length,
//           itemBuilder: (context, index) {
//             final data = controller.addressList[index];

//             return Container(
//               margin: EdgeInsets.only(bottom: 14),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                   )
//                 ],
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.location_on, color: Colors.blue),

//                   SizedBox(width: 12),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data.name,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           data.address,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   /// Share Icon
//                   Icon(Icons.share, size: 20),
//                   SizedBox(width: 10),

//                   /// Popup Menu
//                   PopupMenuButton<String>(
//                     icon: Icon(Icons.more_vert),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     onSelected: (value) {
//                       if (value == "edit") {
//                         Get.to(() => AddAddressScreen(
//                               isEdit: true,
//                               index: index,
//                               address: data,
//                             ));
//                       } else if (value == "delete") {
//                         controller.addressList.removeAt(index);
//                         Get.snackbar(
//                           "Deleted",
//                           "Address deleted successfully",
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: "edit",
//                         child: Row(
//                           children: [
//                             Icon(Icons.edit, size: 18),
//                             SizedBox(width: 8),
//                             Text("Edit"),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: "delete",
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete, size: 18, color: Colors.red),
//                             SizedBox(width: 8),
//                             Text(
//                               "Delete",
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),

//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(Dimensions.spacingSize25),
//         child: CustomPrimaryButton(
//           text: "+ Add Address",
//           onTap: () {
//             Get.to(
//               () => AddAddressScreen(),
//               duration: const Duration(milliseconds: 300),
//               transition: Transition.leftToRight,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:evfual/app/modules/acoount/addaddress_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/dimensions.dart';
import 'package:evfual/data/controller/addaddress_controller.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedAddressScreen extends StatefulWidget {
  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  final AddressController controller = Get.find();
  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();

    /// 3 second loader
    Timer(Duration(seconds: 3), () {
      isLoading.value = false;
    });
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
          "Saved Addresses",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Obx(() {
        /// ✅ Loader
        if (isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        /// ✅ Data Not Found
        if (controller.addressList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 60, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No Address Found",
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

        /// ✅ Address List
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.addressList.length,
          itemBuilder: (context, index) {
            final data = controller.addressList[index];

            return Container(
              margin: EdgeInsets.only(bottom: 14),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.blue),

                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name ?? "",
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

                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == "edit") {
                        Get.to(
                          () => AddAddressScreen(
                            isEdit: true,
                            index: index,
                            address: data,
                          ),
                        );
                      } else if (value == "delete") {
                        controller.addressList.removeAt(index);
                        Get.snackbar(
                          "Deleted",
                          "Address deleted successfully",
                          snackPosition: SnackPosition.BOTTOM,
                        );
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
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Delete", style: TextStyle(color: Colors.red)),
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
      }),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(Dimensions.spacingSize25),
        child: CustomPrimaryButton(
          text: "+ Add Address",
          onTap: () {
            Get.to(
              () => AddAddressScreen(),
              duration: const Duration(milliseconds: 300),
              transition: Transition.leftToRight,
            );
          },
        ),
      ),
    );
  }
}
