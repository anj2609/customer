
import 'package:flutter/material.dart';
import 'package:vivashri/call_parent/chat/api/apis.dart';
import 'package:vivashri/call_parent/chat/models/chat_user.dart';
import 'package:vivashri/call_parent/chat/screens/chat_screen.dart';
import 'package:vivashri/call_parent/chat/widgets/Snackbar.dart';

class DirectChat {
  static final APIs _userService = APIs();
  static Future<void> _directchat(BuildContext context, String userId) async {
    ChatUser? _chatUser = await _userService.getUserById(userId);
    if (_chatUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(user: _chatUser!, block: false),
        ),
      );
    } else {
      Dialogs.showSnackbar(context, 'Unable to fetch data');
    }
  }
}
