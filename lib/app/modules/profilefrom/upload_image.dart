import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivashri/app/modules/profilefrom/partner_qualities.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/uplaodimagecontrol.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? pickedImage;

  // Future<void> pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? file = await picker.pickImage(source: ImageSource.gallery);

  //   if (file != null) {
  //     setState(() {
  //       pickedImage = File(file.path);
  //     });
  //   }
  // }
  final imgC = Get.put(ImageUploadController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _header(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
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
                            _tipExample(
                              "Blur Photo",
                              "assets/images/tips1 1.png",
                            ),
                            _tipExample(
                              "Side Photo",
                              "assets/images/tips2 1.png",
                            ),
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
                            _tipExample(
                              "Group Photo",
                              "assets/images/tips4 1.png",
                            ),
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
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          // LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Prev Step:",
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  style: opensansBold.copyWith(
                    color: ColorResources.primarycolor,
                  ),
                ),
                AutoSizeText(
                  "Education Details",
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  style: opensansBold.copyWith(
                    color: ColorResources.primarycolor2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // CENTER
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.56,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "11 of 18",
                      style: opensansMedium.copyWith(
                        color: ColorResources.blackgrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Upload Photo",
                  style: opensansMedium.copyWith(
                    color: ColorResources.blackcolor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // RIGHT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  "Next Step:",
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  style: opensansBold.copyWith(
                    color: ColorResources.primarycolor,
                  ),
                ),
                AutoSizeText(
                  "Partner’s Details",
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  style: opensansBold.copyWith(
                    color: ColorResources.primarycolor2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              imgC.uploadImages();
              // Get.to(
              //   PartnerQualitiesScreen(),
              //   duration: Duration(
              //     milliseconds: ApiConstants.screenTransitionTime,
              //   ),
              //   transition: Transition.rightToLeft,
              // );
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
                "Continue",
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

  Widget _uploadimage() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              imgC.pickImages();
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
                "Upload",
                style: TextStyle(color: Colors.white, fontSize: 18),
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
      // color: Colors.grey,
      // strokeWidth: 1,
      // dashPattern: [8, 6],
      // borderType: BorderType.RRect,
      // radius: Radius.circular(15),
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
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
