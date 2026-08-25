import 'dart:io';
import 'package:mobile_number/mobile_number.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';

import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class ProfilePage extends StatefulWidget {
  final String? phonenumber;

  ProfilePage({super.key, this.phonenumber});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  // A Google-signup rider arrives with widget.phonenumber as an empty
  // string (see auth_controller.dart's socailLogin) — there's genuinely
  // nothing to show, so the field becomes editable instead of a blank
  // read-only box. A phone-OTP signup already has a real, verified number
  // by this point, so it stays read-only for that case — shared here so
  // the field itself and its submit-time validation can't disagree about
  // which case this actually is.
  bool get hasKnownPhone => (widget.phonenumber ?? '').isNotEmpty;

  String selectedGender = "Male";
  List<String> genderList = ["Male", "Female", "Other"];

  File? selectedImage;
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? phoneNumber;
  @override
  void initState() {
    super.initState();
    phoneController.text = widget.phonenumber ?? '';
    // Pre-fills a Google-signup rider's real name/email as a starting
    // point — always editable (see buildTextField's own note on why this
    // used to be locked). Empty, and so a no-op, for a phone-OTP signup:
    // ApiConstants.usernames/emailAddress are only ever set by the
    // Google-auth path.
    nameController.text = ApiConstants.usernames;
    emailController.text = ApiConstants.emailAddress;
  }

  Future<void> getNumber() async {
    try {
      String? mobileNumber = await MobileNumber.mobileNumber;

      if (mobileNumber != null && mobileNumber.startsWith("9191")) {
        phoneNumber = mobileNumber.substring(4);
      }
      phoneController.text = phoneNumber!.isNotEmpty
          ? phoneNumber!
          : (widget.phonenumber ?? '');
      nameController.text = ApiConstants.usernames;
      emailController.text = ApiConstants.emailAddress;

      print('get social provider ${ApiConstants.provider}');
      print("Number: $phoneNumber");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorResources.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "Fill Personal Info",
          style: PoppinsMedium.copyWith(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              /// Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : null,
                      child: selectedImage == null
                          ? Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey.shade500,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.blueeebutton,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              buildLabel("Full Name"),
              buildTextField(nameController),

              const SizedBox(height: 22),

              buildLabel("Email (Optional)"),
              buildTextField(emailController, icon: Icons.mail_outline),

              const SizedBox(height: 22),

              /// Phone with Flag
              //
              // Editable only when there's genuinely no phone number to show
              // — the Google-signup path (see auth_controller.dart's
              // socailLogin), where widget.phonenumber arrives as an empty
              // string because Google's identity token never carries one at
              // all. A phone-OTP signup already has a real, verified number
              // by the time it reaches this screen (that's how the OTP was
              // sent in the first place), so it stays read-only there —
              // changing it here wouldn't re-verify anything, just create a
              // mismatch between what the account was actually verified with
              // and what this screen claims it is.
              buildLabel("Phone Number"),
              Builder(
                builder: (context) {
                  return Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFF1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Text("🇮🇳", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            readOnly: hasKnownPhone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  hasKnownPhone ? null : "Enter phone number",
                            ),
                            keyboardType: hasKnownPhone
                                ? TextInputType.text
                                : TextInputType.number,
                            inputFormatters: hasKnownPhone
                                ? null
                                : [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 22),

              buildLabel("Gender"),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genderList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: PoppinsMedium),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              buildLabel("Date of Birth (Optional)"),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

                    dobController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: buildTextField(
                    dobController,
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              CustomPrimaryButton(
                text: _isSubmitting ? "Saving..." : "Continue",
                onTap: () async {
                  if (_isSubmitting) return;

                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final email = emailController.text.trim();
                  final dob = dobController.text.trim();

                  if (name.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter your full name.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  if (phone.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter your phone number.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  // Only reachable with a rider-typed value at all on the
                  // Google-signup path — a phone-OTP signup's number is
                  // already real and verified by the time it gets here (the
                  // field is read-only then), so this can't fire for that
                  // case. digitsOnly + a 10-char limit on the field itself
                  // already stop most malformed input; this catches
                  // anything shorter left in an otherwise-valid state.
                  if (!hasKnownPhone && phone.length != 10) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter a valid 10-digit phone number.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  // Email and date of birth are optional on this step — only
                  // name and phone are required to continue. Email is still
                  // format-checked when the rider does enter one, since a
                  // malformed address is worth catching here rather than
                  // failing silently server-side; an empty field skips that
                  // check entirely rather than being treated as invalid.
                  if (email.isNotEmpty && !GetUtils.isEmail(email)) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter a valid email address.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  setState(() => _isSubmitting = true);

                  try {
                    await Get.find<AuthController>().fillPersonalInfoApi(
                      // Was widget.phonenumber — the screen's original
                      // constructor value, not what's actually in the
                      // field. Harmless for a phone-OTP signup (the field
                      // is read-only there, so the two are always the
                      // same), but for a Google signup it meant whatever
                      // the rider had just typed and had validated above
                      // was silently discarded, and the empty
                      // widget.phonenumber sent instead.
                      phone: phone,
                      name: name,
                      email: email,
                      gender: selectedGender,
                      dob: dob,
                      profileimage: selectedImage,
                      context: context,
                    );
                  } catch (e) {
                    debugPrint('fillPersonalInfoApi Error: $e');
                    AnimatedTopToast.show(
                      context: context,
                      message: "Something went wrong. Please try again.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                  } finally {
                    if (mounted) setState(() => _isSubmitting = false);
                  }
                  // Get.find<AuthController>().fillPersonalInfoApi(
                  //   name: nameController.text.trim(),
                  //   email: emailController.text.trim(),
                  //   gender: selectedGender.toString(),
                  //   dob: dob,
                  //   profileimage: selectedImage,
                  //   context: context,
                  // );
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      File file = File(image.path);

      // 🔽 Compress again for safety
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      File compressedFile = file;

      if (result != null) {
        compressedFile = File(file.path)..writeAsBytesSync(result);
      }

      // 🔍 Final size check (optional but recommended)
      int sizeInKB = compressedFile.lengthSync() ~/ 1024;

      if (sizeInKB > 2048) {
        Get.snackbar("Error", "Image must be less than 2MB");
        return;
      }

      setState(() {
        selectedImage = compressedFile;
      });
    }
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: PoppinsMedium.copyWith(fontSize: 14, color: Colors.black),
      ),
    );
  }

  // Was readOnly whenever *either* ApiConstants.usernames or
  // .emailAddress was non-empty — a single combined check controlling
  // both the Name and the Email field, regardless of which one this call
  // actually is, so a Google signup (which always sets both together)
  // locked both fields at once. Compounding that: nothing in this class
  // ever assigned that Google data into nameController/emailController in
  // the first place — the only code that did (getNumber(), below) is
  // never called — so a Google-signup rider landed on two fields that
  // were simultaneously locked *and* empty: unable to type, with nothing
  // pre-filled to look at either. Both fields are unconditionally
  // editable now — pre-filling is a convenience (see initState below),
  // never a restriction on fixing what it filled in.
  Widget buildTextField(TextEditingController controller, {IconData? icon}) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFF1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
