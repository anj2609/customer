// import 'package:devotee/chat/helper/my_date_util.dart';
// import 'package:devotee/chat/models/chat_user.dart';
// import 'package:devotee/constants/color_constant.dart';
// import 'package:devotee/constants/font_constant.dart';
// import 'package:flutter/material.dart';
// import '../../constants/widget/profile_image.dart';

// //view profile screen -- to view profile of user
// class ViewProfileScreen extends StatefulWidget {
//   final ChatUser user;

//   const ViewProfileScreen({super.key, required this.user});

//   @override
//   State<ViewProfileScreen> createState() => _ViewProfileScreenState();
// }

// class _ViewProfileScreenState extends State<ViewProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return GestureDetector(
//       // for hiding keyboard
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//           backgroundColor: AppColors.background,
//           //app bar
//           appBar: AppBar(
//               elevation: 0,
//               backgroundColor: AppColors.primaryColor,
//               title: Text(widget.user.name)),

//           //user about
//           floatingActionButton: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Joined On: ',
//                 style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15),
//               ),
//               Text(
//                   MyDateUtil.getLastMessageTime(
//                       context: context,
//                       time: widget.user.createdAt,
//                       showYear: true),
//                   style: const TextStyle(color: Colors.black54, fontSize: 15)),
//             ],
//           ),

//           //body
//           body: Stack(children: [
//             Container(
//                 width: double.infinity,
//                 alignment: Alignment.topRight,
//                 child: Image.asset("assets/images/background.png")),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // for adding some space
//                     SizedBox(width: screenWidth, height: screenHeight * .03),

//                     //user profile picture
//                     ProfileImage(
//                       size: screenHeight * .2,
//                       url: widget.user.image,
//                     ),

//                     // for adding some space
//                     SizedBox(height: screenHeight * .03),

//                     // user email label
//                     Text(widget.user.name,
//                         style: FontConstant.styleSemiBold(
//                             fontSize: 16, color: AppColors.black)),

//                     // for adding some space
//                     SizedBox(height: screenHeight * .02),

//                     //user about
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'About: ',
//                           style: FontConstant.styleRegular(
//                               fontSize: 15, color: AppColors.black),
//                         ),
//                         Text(widget.user.about,
//                             style: FontConstant.styleRegular(
//                                 fontSize: 15, color: AppColors.darkgrey)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ])),
//     );
//   }
// }
