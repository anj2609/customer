import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:vivashri/app/modules/profilefrom/partner_qualities.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/controller/auth_controller.dart';

class ImageUploadController extends GetxController {
  final ImagePicker picker = ImagePicker();

  RxList<File> images = <File>[].obs;

  Future<void> pickImages() async {
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      if (images.length + files.length > 5) {
        Get.snackbar(
          "Error",
          "Maximum 5 images allowed",
          backgroundColor: Colors.red,
        );
        return;
      }

      for (var file in files) {
        images.add(File(file.path));
      }
    }
  }

  Future<void> uploadImages() async {
    if (images.isEmpty) {
      Get.snackbar("Error", "Please select at least 1 photo");
      return;
    }
    EasyLoading.show();
    String? token = Get.find<AuthController>().getAuthToken();

    var url = Uri.parse(
      "https://testing.akslearning.in/vivashribackend/api/user/profile-photo",
    );

    var request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.fields["app_step"] = "11";
    request.fields["step"] = "11";
    Map<String, dynamic> formJson = {
      "formData": {
        "photo": images.isNotEmpty ? basename(images[0].path) : "",
        "photo1": images.length > 1 ? basename(images[1].path) : "",
        "photo2": images.length > 2 ? basename(images[2].path) : "",
        "photo3": images.length > 3 ? basename(images[3].path) : "",
        "photo4": images.length > 4 ? basename(images[4].path) : "",
        "app_step": 11,
        "step": 11,
      },
    };

    print(formJson);

    for (int i = 0; i < images.length; i++) {
      String fieldName = i == 0 ? "photo" : "photo$i";

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          images[i].path,
          filename: basename(images[i].path),
        ),
      );
    }

    for (int i = images.length; i < 5; i++) {
      String fieldName = i == 0 ? "photo" : "photo$i";
      request.fields[fieldName] = "";
    }

    try {
      var response = await request.send();
      var resData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Success",
          "Uploaded Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.to(
          PartnerQualitiesScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        EasyLoading.dismiss();
        Get.snackbar("Error", "Upload Failed", backgroundColor: Colors.red);
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Exception", e.toString(), backgroundColor: Colors.red);
    }
  }
}
