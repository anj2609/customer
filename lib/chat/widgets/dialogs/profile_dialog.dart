
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../models/chat_user.dart';


// class ProfileDialog extends StatelessWidget {
//   ProfileDialog({super.key, required this.user});

//   final ChatUser user;


//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return AlertDialog(
//       contentPadding: EdgeInsets.zero,
//       backgroundColor: Colors.white.withOpacity(.9),
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(15))),
//       content: SizedBox(
//           width: screenWidth * .6,
//           height: screenHeight * .35,
//           child: Stack(
//             children: [
//               //user profile picture
//               Positioned(
//                 top: screenHeight * .075,
//                 left: screenWidth * .1,
//                 child: ProfileImage(size: screenWidth * .5, url: user.image),
//               ),

//               //user name
//               Positioned(
//                 left: screenWidth * .04,
//                 top: screenHeight * .02,
//                 width: screenWidth * .55,
//                 child: Text(user.name,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.w500)),
//               ),

//               //info button
//               Positioned(
//                   right: 8,
//                   top: 6,
//                   child: MaterialButton(
//                     onPressed: () async {
//                       //for hiding image dialog

//                       //move to view profile screen
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (_) => ViewProfileScreen(user: user)));
//                       final bool isBlock = await APIs.isBlocked(user.id);
//                       if (editProfileController.member?.member?.accountType ==
//                           1) {
//                         if (!profileDetailsController.isLoading.value) {
//                           if (!isBlock) {
//                             // ignore: use_build_context_synchronously
//                             profileDetailsController.profileDetails(
//                                 context, user.id, "", "", [
//                               "1",
//                               "2",
//                               "3",
//                               "4",
//                               "5",
//                               "6",
//                               "7",
//                               "8",
//                               "9",
//                               "10",
//                               "11",
//                               "12",
//                               "13",
//                               "14",
//                               "15"
//                             ]);
//                           } else {
//                             Dialogs.showSnackbar(context, "Blocked user!");
//                           }
//                         }
//                       } else {
//                         if (!checkProfileLimitController.isLoading.value) {
//                           checkProfileLimitController.checkProfileLimit(
//                               context, user.id, "", "", [
//                             "1",
//                             "2",
//                             "3",
//                             "4",
//                             "5",
//                             "6",
//                             "7",
//                             "8",
//                             "9",
//                             "10",
//                             "11",
//                             "12",
//                             "13",
//                             "14",
//                             "15"
//                           ]);
//                         }
//                       }
//                       Navigator.pop(context);
//                     },
//                     minWidth: 0,
//                     padding: const EdgeInsets.all(0),
//                     shape: const CircleBorder(),
//                     child: const Icon(Icons.info_outline,
//                         color: AppColors.primaryColor, size: 30),
//                   ))
//             ],
//           )),
//     );
//   }
// }
