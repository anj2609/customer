
// import 'dart:io';

// import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
// import 'package:evfual/config/utils/colors.dart';
// import 'package:evfual/config/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController nameController = TextEditingController(text: "");

//   final TextEditingController emailController = TextEditingController(text: "");

//   final TextEditingController phoneController = TextEditingController(text: "");

//   final TextEditingController dobController = TextEditingController();

//   String selectedGender = "Male";

//   List<String> genderList = ["Male", "Female", "Other"];
//   File? selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> pickImage(ImageSource source) async {
//     final XFile? image = await _picker.pickImage(source: source);

//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//   }

//   void showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text("Camera"),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo),
//                 title: const Text("Gallery"),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResources.backgroundColor,
//       appBar: AppBar(
//         backgroundColor:ColorResources.backgroundColor,
//         elevation: 0,
//         leading: const Icon(Icons.arrow_back, color: Colors.black),
//         centerTitle: true,
//         title: Text(
//           "Fill Personal Info",
//           style: PoppinsMedium.copyWith(height: 15),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: selectedImage != null
//                         ? FileImage(selectedImage!)
//                         : const AssetImage("assets/profile.jpg")
//                               as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: showImageSourceDialog,
//                       child: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.blue,
//                         ),
//                         child: const Icon(
//                           Icons.edit,
//                           size: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// Full Name
//             Text("Full Name", style: PoppinsMedium.copyWith()),
//             const SizedBox(height: 8),
//             buildTextField(nameController),

//             const SizedBox(height: 20),

//             /// Email
//             Text("Email", style: PoppinsMedium.copyWith()),
//             const SizedBox(height: 8),
//             buildTextField(emailController, icon: Icons.email_outlined),

//             const SizedBox(height: 20),

//             /// Phone
//             Text("Phone Number", style: PoppinsMedium.copyWith()),
//             const SizedBox(height: 8),
//             buildTextField(phoneController, icon: Icons.phone),

//             const SizedBox(height: 20),

//             /// Gender Dropdown
//             Text("Gender", style: PoppinsMedium.copyWith()),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               height: 55,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEFEFF1),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedGender,
//                   isExpanded: true,
//                   icon: const Icon(Icons.keyboard_arrow_down),
//                   items: genderList
//                       .map(
//                         (e) => DropdownMenuItem(
//                           value: e,
//                           child: Text(e, style: PoppinsMedium.copyWith()),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedGender = value!;
//                     });
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// Date of Birth
//             Text("Date of Birth", style: PoppinsMedium.copyWith()),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime(2000),
//                   firstDate: DateTime(1950),
//                   lastDate: DateTime.now(),
//                 );

//                 if (pickedDate != null) {
//                   dobController.text =
//                       "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                 }
//               },
//               child: AbsorbPointer(
//                 child: buildTextField(
//                   dobController,
//                   icon: Icons.calendar_today,
//                 ),
//               ),
//             ),

//             const Spacer(),

//             /// Continue Button
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorResources.blueeebutton,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {
//                   print("Name: ${nameController.text}");
//                   print("Email: ${emailController.text}");
//                   print("Phone: ${phoneController.text}");
//                   print("Gender: $selectedGender");
//                   print("DOB: ${dobController.text}");
//                   Get.to(MainNavigation());
//                 },
//                 child: Text(
//                   "Continue",
//                   style: PoppinsMedium.copyWith(color: Colors.white),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(TextEditingController controller, {IconData? icon}) {
//     return Container(
//       height: 55,
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFEFF1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           if (icon != null) ...[
//             Icon(icon, color: Colors.grey),
//             const SizedBox(width: 10),
//           ],
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: const InputDecoration(border: InputBorder.none),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:io';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/config/utils/colors.dart';

import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();

//   String selectedGender = "Male";
//   List<String> genderList = ["Male", "Female", "Other"];

//   File? selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> pickImage(ImageSource source) async {
//     final XFile? image = await _picker.pickImage(source: source);

//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//   }

//   void showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text("Camera"),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo),
//                 title: const Text("Gallery"),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF5F6F8),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Fill Personal Info",
//           style: PoppinsMedium.copyWith(
//             fontSize: width * 0.045,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: height * 0.03),

//               /// Profile Image
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: width * 0.14,
//                       backgroundColor: Colors.grey.shade300,
//                       backgroundImage: selectedImage != null
//                           ? FileImage(selectedImage!)
//                           : const AssetImage("assets/profile.jpg")
//                               as ImageProvider,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: showImageSourceDialog,
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.blue,
//                           ),
//                           child: const Icon(
//                             Icons.edit,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: height * 0.04),

//               /// Full Name
//               buildLabel("Full Name"),
//               buildTextField(nameController),

//               SizedBox(height: height * 0.025),

//               /// Email
//               buildLabel("Email"),
//               buildTextField(emailController,
//                   icon: Icons.email_outlined),

//               SizedBox(height: height * 0.025),

//               /// Phone
//               buildLabel("Phone Number"),
//               buildTextField(phoneController, icon: Icons.phone),

//               SizedBox(height: height * 0.025),

//               /// Gender
//               buildLabel("Gender"),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 height: 55,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEFEFF1),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: selectedGender,
//                     isExpanded: true,
//                     icon: const Icon(Icons.keyboard_arrow_down),
//                     items: genderList
//                         .map(
//                           (e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e,
//                                 style: PoppinsMedium.copyWith()),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedGender = value!;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               SizedBox(height: height * 0.025),

//               /// DOB
//               buildLabel("Date of Birth"),
//               GestureDetector(
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime(2000),
//                     firstDate: DateTime(1950),
//                     lastDate: DateTime.now(),
//                   );

//                   if (pickedDate != null) {
//                     dobController.text =
//                         "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: buildTextField(
//                     dobController,
//                     icon: Icons.calendar_today,
//                   ),
//                 ),
//               ),

//               SizedBox(height: height * 0.05),

//               /// Continue Button
//               /// 
//               CustomPrimaryButton(
//                 text: "Continue",
//                 onTap: () {
//                   Get.offAll(
//                     MainNavigation(),
//                     transition: Transition.leftToRight,
//                     duration: Duration(milliseconds: 0),
//                   );
//                 },
//               ),
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 55,
//               //   child:
                
//               //    ElevatedButton(
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: ColorResources.blueeebutton,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(30),
//               //       ),
//               //     ),
//               //     onPressed: () {
//               //       Get.to(MainNavigation());
//               //     },
//               //     child: Text(
//               //       "Continue",
//               //       style: PoppinsMedium.copyWith(
//               //           color: Colors.white),
//               //     ),
//               //   ),
//               // ),

//               SizedBox(height: height * 0.03),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: PoppinsMedium.copyWith(
//           fontSize: 14,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(TextEditingController controller,
//       {IconData? icon}) {
//     return Container(
//       height: 55,
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFEFF1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           if (icon != null) ...[
//             Icon(icon, color: Colors.grey),
//             const SizedBox(width: 10),
//           ],
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController nameController =
      TextEditingController(text: "Ansh Saxena");

  final TextEditingController emailController =
      TextEditingController(text: "ansh@infinitetechsolution.com");

  final TextEditingController phoneController =
      TextEditingController(text: "+91 987 654 3210");

  final TextEditingController dobController =
      TextEditingController();

  String selectedGender = "Male";
  List<String> genderList = ["Male", "Female", "Other"];

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     backgroundColor:ColorResources.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor:ColorResources.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "Fill Personal Info",
          style: PoppinsMedium.copyWith(
           
            color: Colors.black,
          ),
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
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : const AssetImage("assets/images/profile.png")
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
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

              buildLabel("Email"),
              buildTextField(emailController,
                  icon: Icons.mail_outline),

              const SizedBox(height: 22),

              /// Phone with Flag
              buildLabel("Phone Number"),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Text("🇮🇳",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
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
                            child: Text(e,
                                style: PoppinsMedium),
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

              buildLabel("Date of Birth"),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate =
                      await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                text: "Continue",
                onTap: () {
                  Get.offAll(
                    MainNavigation(),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 0),
                  );
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: PoppinsMedium.copyWith(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller,
      {IconData? icon}) {
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
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}