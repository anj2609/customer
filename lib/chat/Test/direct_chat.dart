// import 'package:devotee/chat/api/apis.dart';
// import 'package:devotee/constants/widget/Snackbar.dart';
// import 'package:devotee/chat/models/chat_user.dart';
// import 'package:devotee/chat/screens/chat_screen.dart';
// import 'package:flutter/material.dart';

// class DirectChat {
//   static final APIs _userService = APIs();
//   static Future<void> _directchat(BuildContext context, String userId) async {
//     ChatUser? _chatUser = await _userService.getUserById(userId);
//     if (_chatUser != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatScreen(user: _chatUser!, block: false),
//         ),
//       );
//     } else {
//       Dialogs.showSnackbar(context, 'Unable to fetch data');
//     }
//   }
// }
