import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/uplaodimagecontrol.dart';

class EditphotoesScreen extends StatefulWidget {
  const EditphotoesScreen({super.key});

  @override
  State<EditphotoesScreen> createState() => _EditphotoesScreenState();
}

class _EditphotoesScreenState extends State<EditphotoesScreen> {
  File? pickedImage;

  final imgC = Get.put(ImageUploadController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Photos',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ------------ TOP INFO ROW ------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoBox("10 MB", "Maximum image\nUpload size"),
                        _infoBox(
                          "576x576",
                          "Recommended\ndimensions (in pixel)",
                        ),
                        _infoBox("01", "Photo 1 is\nmandatory."),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // ------------ Upload Box Label ------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upload Image",
                        style: opensansMedium.copyWith(
                          fontSize: 15,

                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ------------ DOTTED BOX ------------
                    _showBox(),

                    const SizedBox(height: 15),
                    //imgC.images.isEmpty ? _uploadimage() :
                    _buttons(),

                    const SizedBox(height: 30),

                    // ------------ TIPS TEXT ------------
                    Text(
                      "Few tips to upload pics",
                      style: opensansMedium.copyWith(
                        fontSize: 16,

                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Avoid the following photos to highlight your\nprofile better",
                      textAlign: TextAlign.center,
                      style: opensansMedium.copyWith(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------ TIPS IMAGES ROWS ------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _tipExample("Blur Photo", "assets/images/tips1 1.png"),
                        _tipExample("Side Photo", "assets/images/tips2 1.png"),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _tipExample(
                          "Copyright Photo",
                          "assets/images/tips4 1.png",
                        ),
                        _tipExample("Group Photo", "assets/images/tips4 1.png"),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (imgC.images.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Upload a minimum of 1 image and a maximum of 5 images.',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                imgC.EdituploadImages();
              }
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFBE266B), Color(0xFFEB1D7B)],
                ),
              ),
              child: Text(
                "Update",
                style: opensansMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _uploadimage() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: GestureDetector(
  //           onTap: () {
  //             pickImage();
  //           },
  //           child: Container(
  //             height: 45,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               gradient: const LinearGradient(
  //                 colors: [Color(0xFFBE266B), Color(0xFFEB1D7B)],
  //               ),
  //             ),
  //             child: Text(
  //               "Upload",
  //               style: opensansMedium.copyWith(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ---------------- INFO BOX ----------------
  Widget _infoBox(String big, String small) {
    return Column(
      children: [
        Text(
          big,
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.red),
        ),
        const SizedBox(height: 2),
        Text(
          small,
          textAlign: TextAlign.center,
          style: opensansMedium.copyWith(fontSize: 12, color: Colors.red),
        ),
      ],
    );
  }

  Widget _showBox() {
    return GestureDetector(
      onTap: () {
        imgC.pickImages();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return imgC.images.isEmpty
              ? _emptyBox()
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: imgC.images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (_, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            imgC.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),

                        /// delete button
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              imgC.images.removeAt(index);
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
        }),
      ),
    );
  }

  Widget _emptyBox() {
    return DottedBorder(
      options: RectDottedBorderOptions(
        strokeWidth: 1,
        dashPattern: [3, 5],
        color: Colors.grey.shade600,
      ),

      child: Container(
        height: 220,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/imagebackk.png', height: 50),
            SizedBox(height: 10),
            Text(
              "Select File",
              style: opensansSemiBold.copyWith(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Upload a minimum of 1 image and a maximum of 5 images.',
              textAlign: TextAlign.center,
              style: opensansMedium.copyWith(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UPLOAD DOTTED BOX ----------------
  // Widget _showBox() {
  //   return GestureDetector(
  //     onTap: () {
  //       pickImage();
  //     },
  //     child: DottedBorder(
  //       options: RoundedRectDottedBorderOptions(
  //         radius: Radius.circular(15),
  //         strokeWidth: 1,
  //         dashPattern: [8, 6],
  //         color: Colors.grey,
  //       ),

  //       child: Container(
  //         height: 220,
  //         width: double.infinity,
  //         alignment: Alignment.center,
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             pickedImage == null
  //                 ? Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset('assets/images/imagebackk.png', height: 50),
  //                       SizedBox(height: 10),
  //                       Text(
  //                         "Select File",
  //                         style: TextStyle(fontSize: 16, color: Colors.grey),
  //                       ),
  //                     ],
  //                   )
  //                 : ClipRRect(
  //                     borderRadius: BorderRadius.circular(12),
  //                     child: Image.file(pickedImage!, fit: BoxFit.cover),
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ),

  //   );
  // }

  // ---------------- TIPS IMAGE ----------------
  Widget _tipExample(String label, String assetPath) {
    return Column(
      children: [
        Container(
          height: 85,
          width: 85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: ClipOval(child: Image.asset(assetPath, fit: BoxFit.cover)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: opensansMedium.copyWith(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
