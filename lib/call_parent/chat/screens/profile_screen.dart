import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivashri/call_parent/chat/api/apis.dart';
import 'package:vivashri/call_parent/chat/models/chat_user.dart';
import 'package:vivashri/call_parent/chat/widgets/Snackbar.dart';
import 'package:vivashri/call_parent/chat/widgets/profile_image.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      // for hiding keyboard
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        //app bar
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: ColorResources.primarycolor2,
          title: const Text('User Profile'),
        ),

        //floating button to log out
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 10),
        //   child: FloatingActionButton.extended(
        //       backgroundColor: Colors.redAccent,
        //       onPressed: () async {
        //         //for showing progress dialog
        //         Dialogs.showLoading(context);

        //         await APIs.updateActiveStatus(false);

        //         //  // sign out from app
        //         // await APIs.auth.signOut().then((value) async {
        //         //   await GoogleSignIn().signOut().then((value) {
        //         //     //for hiding progress dialog
        //         //     Navigator.pop(context);

        //         //     //for moving to home screen
        //         //     Navigator.pop(context);

        //         //     // APIs.auth = FirebaseAuth.instance;

        //         //     //replacing home screen with login screen
        //         //     Navigator.pushReplacement(
        //         //         context,
        //         //         MaterialPageRoute(
        //         //             builder: (_) => const LoginScreen()));
        //         //   });
        //         // });
        //       },
        //       icon: const Icon(Icons.logout),
        //       label: const Text('Logout')
        //       ),
        // ),

        //body
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Image.asset("assets/images/background.png"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // for adding some space
                      SizedBox(width: screenWidth, height: screenHeight * .03),

                      //user profile picture
                      Stack(
                        children: [
                          //profile picture
                          _image != null
                              ?
                                //local image
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(screenHeight * .1),
                                  ),
                                  child: Image.file(
                                    File(_image!),
                                    width: screenHeight * .2,
                                    height: screenHeight * .2,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              :
                                //image from server
                                ProfileImage(
                                  size: screenHeight * .2,
                                  url: widget.user.image,
                                ),

                          //edit image button
                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: MaterialButton(
                          //     elevation: 1,
                          //     onPressed: () {
                          //       _showBottomSheet();
                          //     },
                          //     shape: const CircleBorder(),
                          //     color: Colors.white,
                          //     child: const Icon(Icons.edit, color: Colors.blue),
                          //   ),
                          // )
                        ],
                      ),

                      // for adding some space
                      SizedBox(height: screenHeight * .02),

                      // user email label
                      Text(
                        "${widget.user.name}",
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),

                      // for adding some space
                      SizedBox(height: screenHeight * .03),

                      // name input field
                      // TextFormField(
                      //   initialValue: widget.user.name,
                      //   onSaved: (val) => APIs.me.name = val ?? '',
                      //   validator: (val) => val != null && val.isNotEmpty
                      //       ? null
                      //       : 'Required Field',
                      //   decoration: const InputDecoration(
                      //       prefixIcon: Icon(Icons.person, color: Colors.blue),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(12)),
                      //       ),
                      //       hintText: 'eg. Happy Singh',
                      //       label: Text('Name')),
                      // ),

                      // for adding some space
                      SizedBox(height: screenHeight * .02),

                      // about input field
                      TextFormField(
                        initialValue: widget.user.about,
                        onSaved: (val) => APIs.me.about = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration:  InputDecoration(
                          prefixIcon: Icon(
                            Icons.info_outline,
                            color: ColorResources.primarycolor2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide:  BorderSide(
                              color: ColorResources.primarycolor2,
                            ),
                          ),
                          hintText: 'eg. Feeling Happy',
                          label: Text(
                            'About',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      // for adding some space
                      SizedBox(height: screenHeight * .05),

                      // update profile button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: ColorResources.primarycolor2,
                          minimumSize: Size(
                            screenWidth * .5,
                            screenHeight * .05,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                context,
                                'Profile Updated Successfully!',
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.edit, size: 24),
                        label: Text(
                          'UPDATE',
                          style: opensansRegular.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: screenHeight * .03,
            bottom: screenHeight * .05,
          ),
          children: [
            //pick profile picture label
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            //for adding some space
            SizedBox(height: screenHeight * .02),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //pick from gallery button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(screenWidth * .3, screenHeight * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));

                      // for hiding bottom sheet
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/add_image.png'),
                ),

                //take picture from camera button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(screenWidth * .3, screenHeight * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));

                      // for hiding bottom sheet
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/camera.png'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
