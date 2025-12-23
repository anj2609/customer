import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/uplaodimagecontrol.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditphotoesScreen extends StatefulWidget {
  const EditphotoesScreen({super.key});

  @override
  State<EditphotoesScreen> createState() => _EditphotoesScreenState();
}

class _EditphotoesScreenState extends State<EditphotoesScreen> {
  File? pickedImage;

  final imgC = Get.put(ImageUploadController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileapi();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    String? profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _imageBox(),
                              SizedBox(width: 10),
                              _imageBox1(),
                              SizedBox(width: 10),
                              _imageBox2(),
                            ],
                          ),

                          SizedBox(height: 12),

                          Row(
                            children: [
                              _imageBox3(),
                              SizedBox(width: 10),
                              _imageBox4(),
                              SizedBox(width: 10),
                              _imageBox5(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // _showBox(),
                    const SizedBox(height: 15),

                    // _buttons(),
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

  final usercontroller = Get.put(UserDetailController());
  Widget _imageBox() {
    final u = usercontroller.userData.value!;
    final imgC = Get.put(ImageUploadController());

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => showImagePickerSheet(imgC),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (imgC.selectedImage.value != null) {
                      return Image.file(
                        imgC.selectedImage.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    if (u.photo != null) {
                      return Image.network(
                        '${ApiConstants.imageurl}${u.photo}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }

                    return Image.asset(
                      u.gender == "Male"
                          ? "assets/images/no-image-male2.jpg"
                          : "assets/images/no-image-female2.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageBox1() {
    final u = usercontroller.userData.value!;
    final imgC = Get.put(ImageUploadController());

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => showImagePickerSheet1(imgC),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (imgC.selectedImage1.value != null) {
                      return Image.file(
                        imgC.selectedImage1.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    if (u.photo1 != null) {
                      return Image.network(
                        '${ApiConstants.imageurl}${u.photo1}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }

                    return Image.asset(
                      u.gender == "Male"
                          ? "assets/images/no-image-male2.jpg"
                          : "assets/images/no-image-female2.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageBox2() {
    final u = usercontroller.userData.value!;
    final imgC = Get.put(ImageUploadController());

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => showImagePickerShee2(imgC),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (imgC.selectedImage2.value != null) {
                      return Image.file(
                        imgC.selectedImage2.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    if (u.photo2 != null) {
                      return Image.network(
                        '${ApiConstants.imageurl}${u.photo2}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }

                    return Image.asset(
                      u.gender == "Male"
                          ? "assets/images/no-image-male2.jpg"
                          : "assets/images/no-image-female2.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageBox3() {
    final u = usercontroller.userData.value!;
    final imgC = Get.put(ImageUploadController());

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => showImagePickerSheet3(imgC),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (imgC.selectedImage3.value != null) {
                      return Image.file(
                        imgC.selectedImage3.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    if (u.photo3 != null) {
                      return Image.network(
                        '${ApiConstants.imageurl}${u.photo3}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }

                    return Image.asset(
                      u.gender == "Male"
                          ? "assets/images/no-image-male2.jpg"
                          : "assets/images/no-image-female2.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageBox4() {
    final u = usercontroller.userData.value!;
    final imgC = Get.put(ImageUploadController());

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => showImagePickerSheet4(imgC),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (imgC.selectedImage4.value != null) {
                      return Image.file(
                        imgC.selectedImage4.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    if (u.photo4 != null) {
                      return Image.network(
                        '${ApiConstants.imageurl}${u.photo4}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }

                    return Image.asset(
                      u.gender == "Male"
                          ? "assets/images/no-image-male2.jpg"
                          : "assets/images/no-image-female2.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImagePickerSheet(ImageUploadController imgC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle(ImageSource.gallery);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showImagePickerSheet1(ImageUploadController imgC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle1(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle1(ImageSource.gallery);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showImagePickerShee2(ImageUploadController imgC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle2(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle2(ImageSource.gallery);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showImagePickerSheet3(ImageUploadController imgC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle3(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle3(ImageSource.gallery);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showImagePickerSheet4(ImageUploadController imgC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle4(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                imgC.pickImagesingle4(ImageSource.gallery);
              },
            ),
            SizedBox(height: 30),
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
              imgC.editUploadImage();
              imgC.editUploadImage1();
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

  Widget _imageBox5() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

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
