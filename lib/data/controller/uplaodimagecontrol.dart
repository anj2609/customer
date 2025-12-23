import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/profilefrom/partner_qualities.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/controller/auth_controller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class ImageUploadController extends GetxController {
  final ImagePicker picker = ImagePicker();

  /// single image
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<File?> selectedImage1 = Rx<File?>(null);
  Rx<File?> selectedImage2 = Rx<File?>(null);
  Rx<File?> selectedImage3 = Rx<File?>(null);
  Rx<File?> selectedImage4 = Rx<File?>(null);

  /// pick from camera / gallery
  Future<void> pickImagesingle(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File? cropped = await cropImagesingle(File(file.path));
    if (cropped != null) {
      selectedImage.value = cropped;
      editUploadImage();
    }
  }

  Future<void> pickImagesingle1(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File? cropped = await cropImagesingle(File(file.path));

    if (cropped != null) {
      selectedImage1.value = cropped;

      editUploadImage1();
    }
  }

  Future<void> pickImagesingle2(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File? cropped = await cropImagesingle(File(file.path));
    if (cropped != null) {
      selectedImage2.value = cropped;
      editUploadImage2();
    }
  }

  Future<void> pickImagesingle3(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File? cropped = await cropImagesingle(File(file.path));
    if (cropped != null) {
      selectedImage3.value = cropped;
      editUploadImage3();
    }
  }

  Future<void> pickImagesingle4(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File? cropped = await cropImagesingle(File(file.path));
    if (cropped != null) {
      selectedImage4.value = cropped;
      editUploadImage4();
    }
  }

  Future<File?> cropImagesingle(File imageFile) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 95,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );

    if (cropped == null) return null;
    return File(cropped.path);
  }

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
        File? cropped = await cropImage(File(file.path));

        if (cropped != null) {
          images.add(cropped); // ✔ cropped image only
        }
      }
    }
  }

  Future<File?> cropImage(File imageFile) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 95,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: true, // 🔒 user cannot change ratio
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true, // 🔒 iOS lock
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }

  Future<void> uploadImages() async {
    if (images.isEmpty) {
      Get.snackbar("Error", "Please select at least 1 photo");
      return;
    }
    EasyLoading.show();
    String? token = Get.find<AuthController>().getAuthToken();

    var url = Uri.parse(
      "https://vivashri.com/vivashribackend/api/user/profile-photo",
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

  final usercontroller = Get.put(UserDetailController());

  Future<void> editUploadImage() async {
    EasyLoading.show();

    try {
      String? token = Get.find<AuthController>().getAuthToken();

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/profile-photo",
      );

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "formData[photo]": basename(selectedImage.value!.path),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "photo",
          selectedImage.value!.path,
          filename: basename(selectedImage.value!.path),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        String? profileid = prefs.getString("profileid");
        usercontroller.fetchUserDetail(profileid.toString());
        Get.snackbar(
          "Success",
          "Profile photo uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("UPLOAD EXCEPTION : $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUploadImage1() async {
    EasyLoading.show();

    try {
      String? token = Get.find<AuthController>().getAuthToken();

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/profile-photo",
      );

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "formData[photo1]": basename(selectedImage1.value!.path),
        // "formData[photo2]": "",
        // "formData[photo3]": "",
        // "formData[photo4]": "",
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "photo1",
          selectedImage1.value!.path,
          filename: basename(selectedImage1.value!.path),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile photo uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("UPLOAD EXCEPTION : $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUploadImage2() async {
    EasyLoading.show();

    try {
      String? token = Get.find<AuthController>().getAuthToken();

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/profile-photo",
      );

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "formData[photo2]": basename(selectedImage2.value!.path),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "photo2",
          selectedImage2.value!.path,
          filename: basename(selectedImage2.value!.path),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile photo uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("UPLOAD EXCEPTION : $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUploadImage3() async {
    EasyLoading.show();

    try {
      String? token = Get.find<AuthController>().getAuthToken();

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/profile-photo",
      );

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "formData[photo3]": basename(selectedImage3.value!.path),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "photo3",
          selectedImage3.value!.path,
          filename: basename(selectedImage3.value!.path),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile photo uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("UPLOAD EXCEPTION : $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUploadImage4() async {
    EasyLoading.show();

    try {
      String? token = Get.find<AuthController>().getAuthToken();

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/profile-photo",
      );

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "formData[photo4]": basename(selectedImage4.value!.path),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "photo4",
          selectedImage4.value!.path,
          filename: basename(selectedImage4.value!.path),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile photo uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("UPLOAD EXCEPTION : $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
